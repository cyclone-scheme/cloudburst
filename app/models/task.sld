(define-library (app models task)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
    (lib config)
    (prefix (lib database) db:)
    (cyclone postgresql) ;; TODO: only temporary, try to generalize via (lib database)
    (srfi 69)
  )
  (export
    get-all
    insert!
    update!
    delete!
  )
  (begin

;; TODO: BIG consideration is how to make all of this thread-safe,
;;       and how much of that is DB-dependent (EG: pg vs sqlite)

;; TODO: instead of using config/postgres directly, extract that to a DB driver
;; and use something streamlined here

    (define (get-all)
      (db:call-with-lock 
       (lambda (conn)
        (let* ((r (db:query conn "select * from task"))
               (rs (let loop ((acc '())
                              (row (db:fetch! conn r)))
                     (cond
                       (row 
                         (loop 
                           (cons 
                             `((id . ,(vector-ref row 0))
                               (task . ,(vector-ref row 1))
                               (priority . ,(vector-ref row 2))
                              )
                             acc)
                           (db:fetch! conn r)))
                       (else
                         acc)))))
          (db:disconnect! conn)
          (reverse rs)))))

    (define (insert! body)
      (let* ((conn (db:connect))
             (p (postgresql-prepared-statement conn 
                  "insert into task (body) values ($1)")))
        (postgresql-prepared-statement-sql p)
        (postgresql-bind-parameters! p body)
        (define q (postgresql-execute! p))
        (postgresql-close-prepared-statement! p)
        (db:disconnect! conn)
        q)) ;; TODO: possible to return ID?

    ; Experiment -
    ;(define (insert2! body)
    ;  (let* ((conn (db:connect)))
    ;    (postgresql-execute-sql! conn 
    ;      (string-append
    ;        "insert into task (body) values ('"
    ;        body
    ;        "')"))))

    (define (update! id body)
      (let* ((conn (db:connect))
             (p (postgresql-prepared-statement conn 
                  "update task set body = $1 where id = $2")))
        (postgresql-prepared-statement-sql p)
        (postgresql-bind-parameters! p body id)
        (define q (postgresql-execute! p))
        (postgresql-close-prepared-statement! p)
        (db:disconnect! conn)
        q))

    (define (delete! id)
      (let* ((conn (db:connect))
             (p (postgresql-prepared-statement conn 
                  "delete from task where id = $1")))
        (postgresql-prepared-statement-sql p)
        (postgresql-bind-parameters! p id)
        (define q (postgresql-execute! p))
        (postgresql-close-prepared-statement! p)
        (db:disconnect! conn)
        q))

  )
)
