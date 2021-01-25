(import (scheme base)
        (scheme write)
        (prefix (lib database) db:)
        (cyclone postgresql))

(define (print . args) (for-each display args) (newline))

(define conn (db:connect))

(print "create tables")
;; may not be there yet (causes an error if there isn't)
(guard (e (else #t)) (postgresql-execute-sql! conn "drop table task;"))
(guard (e (else (print (error-object-message e))))
  (postgresql-execute-sql! conn
    (db:file-contents "scripts/create-db.sql")))

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
