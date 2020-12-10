(import (scheme base)
        (scheme write)
        (prefix (lib config) config:)
        (cyclone postgresql))

;; TODO: load config/database.scm
(define cfg (config:read-file "config/database.scm"))

(define *hostname* (config:value cfg 'hostname))
(define *port* (config:value cfg 'port))
(define *database* (config:value cfg 'database))
(define *username* (config:value cfg 'username))
(define *password* (config:value cfg 'password))

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

(define (print . args) (for-each display args) (newline))

(define conn (make-postgresql-connection 
  *hostname* *port* *database* *username* *password*))

;; open the connection
(postgresql-open-connection! conn)

;; login
(postgresql-login! conn)

(print "create tables")
;; may not be there yet (causes an error if there isn't)
(guard (e (else #t)) (postgresql-execute-sql! conn "drop table test"))
(guard (e (else (print (error-object-message e))))
  (postgresql-execute-sql! conn
    (file-contents "scripts/create-db.sql")))

;(print "simple query")
;(let ((r (postgresql-execute-sql! conn "select * from test")))
;  (print (postgresql-query-descriptions r))
;  (print (postgresql-fetch-query! r)))
;
;(postgresql-execute-sql! conn 
;  "insert into test (id, name) values (1, 'name')")
;(postgresql-execute-sql! conn 
;  "insert into test (id, name) values (2, 'test name')")
;(postgresql-execute-sql! conn 
;  "insert into test (id, name) values (-1, 'test name2')")
;(postgresql-execute-sql! conn  "commit")
;
;(print "insert with prepared statement")
;(let ((p (postgresql-prepared-statement 
;	  conn "insert into test (id, name) values ($1, $2)")))
;  (print (postgresql-prepared-statement-sql p))
;  (print (postgresql-bind-parameters! p 3 "name"))
;  (let ((q (postgresql-execute! p)))
;    (print q))
;  (postgresql-close-prepared-statement! p))
;
;(let ((p (postgresql-prepared-statement 
;	  conn "insert into test (id, name) values ($1, $2)")))
;  (print (postgresql-prepared-statement-sql p))
;  (print (postgresql-bind-parameters! p 3 '()))
;  (let ((q (postgresql-execute! p)))
;    (print q))
;  (postgresql-close-prepared-statement! p))
;
;(print "select * from test")
;(let ((r (postgresql-execute-sql! conn "select * from test")))
;  (print (postgresql-query-descriptions r))
;  (print (postgresql-fetch-query! r))
;  (print (postgresql-fetch-query! r))
;  (print (postgresql-fetch-query! r))
;  (print (postgresql-fetch-query! r))
;  (print (postgresql-fetch-query! r)))
;
;(let ((p (postgresql-prepared-statement 
;	  conn "select * from test where name = $1")))
;  (print (postgresql-prepared-statement-sql p))
;  (print (postgresql-bind-parameters! p "name"))
;  (let ((q (postgresql-execute! p)))
;    (print q)
;    (print (postgresql-fetch-query! q))
;    (print (postgresql-fetch-query! q)))
;  (postgresql-close-prepared-statement! p))
;
;(let ((p (postgresql-prepared-statement 
;	  conn "select * from test where id = $1")))
;  (print (postgresql-prepared-statement-sql p))
;  (print (postgresql-bind-parameters! p 1))
;  (let ((q (postgresql-execute! p)))
;    (print q)
;    (print (postgresql-fetch-query! q))
;    (print (postgresql-fetch-query! q)))
;  (postgresql-close-prepared-statement! p))
;
;;; delete
;(print "delete")
;(print (postgresql-execute-sql! conn "delete from test"))


;; terminate and close connection
(print "terminate")
(postgresql-terminate! conn)
