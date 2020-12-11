(define-library (lib database)
  (import 
    (scheme base)
    (prefix (lib config) config:)
    (cyclone postgresql)
  )
  (export
    file-contents
    connect
  )
  (begin

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
