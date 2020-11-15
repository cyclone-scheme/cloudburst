
;; Dynamically create an (import) statement for all the controllers
(define-syntax dyn-import
  (er-macro-transformer
    (lambda (expr rename compare)
      (define (load-controllers ctrl-files)
        (map
          (lambda (fname)
            (call-with-input-file (string-append "app/controllers/" fname) (lambda (fp)
              (let* ((lib (read fp))
                     (lib-name (lib:name lib))
                     (ctrl-name (car (reverse lib-name)))
                     (lib-exports (lib:exports lib)))
                ;(display `(Loading ,lib-name))
                ;(newline)
                ;(set! ctrls (cons ctrl-name ctrls))
                ;(set! ctrl-funcs (cons (cons ctrl-name lib-exports) ctrl-funcs))
                `(prefix ,lib-name 
                         ,(string->symbol 
                            (string-append (symbol->string ctrl-name) ":")))
                ))))
          ctrl-files))
      (eval `(import (lib dirent)))
      (cons 'import 
            (load-controllers
              (eval '(find-files "app/controllers/" ".sld")))))))

;; Generate a lookup table for all controller action functions
(define-syntax gen-ctrl-table
  (er-macro-transformer
    (lambda (expr rename compare)
      (define (import->string import)
        (foldr (lambda (id s)
                 (string-append "_" (mangle id) s))
               ""
               (lib:list->import-set import)))
      (define (load-controllers ctrl-files)
        (map
          (lambda (fname)
            (call-with-input-file (string-append "app/controllers/" fname) (lambda (fp)
              (let* ((lib (read fp))
                     (lib-name (lib:name lib))
                     (ctrl-name (car (reverse lib-name)))
                     (lib-exports (lib:exports lib)))
                (cons 'list
                  (cons
                   `(quote ,ctrl-name)
                   (map
                    (lambda (export)
                      (let* ((export-parts 
                               (string-split 
                                 (string-downcase 
                                   (symbol->string export))
                                 #\:))
                             (rest-indicator
                              (cond
                                ((<= (length export-parts) 1)
                                 #f)
                                ((member (car export-parts) '("get" "post" "put" "delete"))
                                 (car export-parts))
                                (else #f)))
                             (sym (string->symbol 
                                   (string-append 
                                     (symbol->string ctrl-name) ":" (symbol->string export)))))
;;TODO: also append REST request type, if a rest function
                        `(list (quote ,sym) ,sym ,rest-indicator)))
                    lib-exports)))
                ))))
          ctrl-files))
      (eval `(import (lib dirent)))
      (list 'define '*ctrl-action-table*
        (cons 'list
              (load-controllers
                (eval '(find-files "app/controllers/" ".sld"))))))))

;; ctrl/action->function :: string -> string -> string -> Maybe pair boolean
;; Lookup function for given controller / action pair
(define (ctrl/action->function ctrl action req-method)
  (and-let* (((not (rest-method? action)))
             (action-str action)
             (action-sym 
               (string->symbol
                 (string-append ctrl ":" action-str)))
             (rest-action-str
              (if (> (string-length req-method) 0)
                  (string-append req-method ":" action)
                  action))
             (rest-action-sym 
               (string->symbol
                 (string-append ctrl ":" rest-action-str)))
             (ctrl-sym (string->symbol ctrl))
             (ctrl-alis (assoc ctrl-sym *ctrl-action-table*)))
    (let ((action-alis (assoc action-sym (cdr ctrl-alis)))
          (rest-action-alis (assoc rest-action-sym (cdr ctrl-alis))))
      (cond
        (rest-action-alis (cons 'rest (cadr rest-action-alis)))
        (action-alis (cons 'html (cadr action-alis)))
        (else #f)))))

(define (rest-method? action)
  (let ((parts (string-split (string-downcase action) #\:)))
    (and
      (> (length parts) 1)
      (member (car parts) '("get" "post" "put" "delete")))))

(define (send-error-response msg)
  (display (http:make-header "text/html" 500))
  (display msg))

(define (send-404-response)
  (display (http:make-header "text/html" 404))
  (display "Not found."))

;; TODO: parse out id arguments and pass them along, if available
;; TODO: get the request type, then should a prefix "get:" "post:" (if available) route to by req type
(define (route-to-controller url req-method)
  (with-handler
    (lambda (err)
      (send-log ERR (string-append "Error calling route-to-controller for " url ":") err)
      (send-error-response "An error occurred"))
    (let* ((path-parts (url->path-parts url))
           (ctrl-part (if (pair? path-parts)
                          (car path-parts)
                          "index")) ;; Default controller
           (action-part (if (and (pair? path-parts) 
                              (> (length path-parts) 2))
                            (cadr path-parts)
                            "index"))
           (id-parts (if (and (pair? path-parts) 
                              (> (length path-parts) 2))
                         (cddr path-parts)
                         '()))
          )

;TODO: need to modify/generate path-parts with index parts inserted

      ;(send-log INFO
      ;  (list `(path-parts ,path-parts)
      ;        `(controller ,ctrl-part) 
      ;        `(action ,action-part)
      ;        `(args ,id-parts)
      ;        `(len args ,(length id-parts))
      ;        ))
      ;(let ((fnc (string->symbol
      ;             (string-append ctrl-part ":" (cadr path-parts)))))
      ; (send-log INFO (list "running: " fnc))
       (let ((type/fnc 
               (ctrl/action->function 
                 ctrl-part
                 action-part
                 (if (string? req-method)
                     (string-downcase req-method)
                     ""))))

         ;;(send-log INFO `(DEBUG ,ctrl-part ,path-parts ,req-method ,type/fnc))
         (cond
          (type/fnc
           (display (http:make-header 
                      (if (equal? (car type/fnc) 'rest)
                          "application/json" 
                          "text/html")
                      200))
           (apply (cdr type/fnc) id-parts))
          (else
           (send-404-response)))))))

;; Dynamically import and load controllers into memory
(dyn-import)
(gen-ctrl-table)

