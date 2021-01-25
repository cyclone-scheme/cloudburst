;; TODO: relocate this to (lib database postgresql)
;; TODO: generalize common parts to (lib database)
;; TODO: add another DB driver, maybe sqlite
(define-library (lib database)
  (import 
    (scheme base)
    (scheme write)
    (srfi 18)
    (prefix (lib config) config:)
    (cyclone postgresql)
  )
  (export
    file-contents
    connect
    query
    query/file
    fetch!
    disconnect!
    ;; TODO: with-db-lock (??)
    call-with-lock
    ;with-lock
  )
  (begin

(define *lock* (make-mutex))

(define (call-with-lock thunk)
  (let ((result #f))
    (mutex-lock! *lock*)
    (with-handler
      (lambda (err)
        (mutex-unlock! *lock*)
        (raise err))
      (set! result (thunk (connect))))
    (mutex-unlock! *lock*)
    result))
    
;(define-syntax with-lock
;  (er-macro-transformer
;    (lambda (exp rename compare)
;      `(call-with-lock
;         (lambda ()
;           ,@(cdr exp))))))

(define (connect)
  (define cfg (config:read-file "config/database.scm"))

  (define *hostname* (config:value cfg 'hostname))
  (define *port* (config:value cfg 'port))
  (define *database* (config:value cfg 'database))
  (define *username* (config:value cfg 'username))
  (define *password* (config:value cfg 'password))

  (let ((conn (make-postgresql-connection 
                *hostname* *port* *database* *username* *password*)))
    ;; open the connection
    (postgresql-open-connection! conn)
    
    ;; login
    (postgresql-login! conn)

    conn))

(define (query conn cmd)
;; TODO: use prepared statement instead??
;;       seems more appopriate, esp if we are using fetch anyway
  (postgresql-execute-sql! conn cmd))

(define (query/file conn filename)
  (guard (e (else (display (error-object-message e))))
    (postgresql-execute-sql! conn
      (file-contents filename))))

(define (fetch! conn result-set)
  (postgresql-fetch-query! result-set))

(define (disconnect! conn)
  (postgresql-terminate! conn))

;; TODO: do we keep this or turn it into (lib db postgresql) and just have
;;       a seprate driver for each type of DB we support??

;; TODO: extract this out into a postgres DB driver for our framework????
;;       will need to handle things like escaping (does our library do that?), etc

;; Read all contents of file and return as a string
(define (file-contents filename)
  (let loop ((fp (open-input-file filename))
             (contents ""))
    (let ((in (read-string 1024 fp)))
      (cond
        ((eof-object? in)
         (close-port fp)
         contents)
        (else
          (loop fp (string-append contents in)))))))

  )
)
