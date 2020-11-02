(define-library (lib json)
  (import 
    (scheme base)
    (scheme write)
    (scheme cyclone util)
  )
  (export
    json-scalar?
    ->json
    ->json-string
  )
  (begin

(define (->json-string expr)
  (parameterize ((current-output-port (open-output-string)))
    (with-handler
      (lambda (err)
        #f)
      (->json expr)
      (get-output-string (current-output-port)))))

(define (json-scalar? expr)
  (or (boolean? expr)
      (null? expr)
      (number? expr)
      (char? expr)
      (string? expr)
      (symbol? expr)))

(define (->json expr)
  (cond
    ((eq? expr #t) (display "true"))
    ((eq? expr #f) (display "false"))
    ((eq? expr '()) (display "null"))
    ((number? expr) (display expr)) ;; Good enough?
    ((string? expr) 
     (display "\"")
     (let loop ((lis (string->list expr)))
       (case
        (car lis)
        ((#\") (display "\\\""))
        ((#\\) (display "\\\\"))
        ((#\/) (display "\\/"))
        ((#\backspace) (display "\\b"))
        ((#\x12) (display "\\f"))
        ((#\newline) (display "\\n"))
        ((#\return) (display "\\r"))
        ((#\tab) (display "\\t"))
        (else
          (display (car lis))))
       (when (not (null? (cdr lis)))
        (loop (cdr lis))))
     (display "\""))
    ((char? expr)   (->json (string expr)))
    ((symbol? expr) (->json (symbol->string expr)))
    ((list? expr)
     (cond
      ((every
         (lambda (e)
           (and (pair? e)
                (json-scalar? (car e))))
         expr)
       (display "{")
       (let loop ((first? #t)
                  (lis expr))
        (if (not first?) (display ", "))
        (let ((cell (car lis)))
          (cond
            ((or (char? (car cell))
                 (string? (car cell))
                 (symbol? (car cell)))
             (->json (car cell)))
            (else
              (display "\"")
              (->json (car cell))
              (display "\"")))
          (display ":")
          (->json (cdr cell)))
        (if (not (null? (cdr lis)))
            (loop #f (cdr lis))))
       (display "}"))
      (else
       (display "[")
       (let loop ((first? #t)
                  (lis expr))
        (if (not first?) (display ", "))
        (->json (car lis))
        (if (not (null? (cdr lis)))
            (loop #f (cdr lis))))
       (display "]"))))
    ((pair? expr)
     (->json (pair->list expr)))
    ((vector? expr)
     (display "[")
     (let loop ((i 0)
                (count (vector-length expr)))
      (when (> count i)
        (if (zero? i)
            (display "")
            (display ", "))
        (->json (vector-ref expr i))
        (loop (+ i 1) count)))
     (display "]"))
    ((bytevector? expr)
     (display "[")
     (let loop ((i 0)
                (count (bytevector-length expr)))
      (when (> count i)
        (if (zero? i)
            (display "")
            (display ", "))
        (->json (bytevector-u8-ref expr i))
        (loop (+ i 1) count)))
     (display "]"))
    ;; TODO: hash table?
    (else (error "Unknown expression" expr)))) ;; TODO: or  just a string representation?

))
