(define-library (app models task)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
    (lib config)
    (prefix (lib database) db:)
    (srfi 69)
  )
  (export
;    get
    get-all
;    insert!
;    update!
;    delete!
  )
  (begin

;; TODO: BIG consideration is how to make all of this thread-safe,
;;       and how much of that is DB-dependent (EG: pg vs sqlite)

;; TODO: instead of using config/postgres directly, extract that to a DB driver
;; and use something streamlined here

    (define (get-all)
     'TODO
      ;; TODO: connect, query, loop over query and cons until #f, then return
      ;(let loop ((conn (db:connect))
      ;          ( 
      ;      )
      ;  (db:disconnect! conn))
    )

;    (define (get key)
;      (hash-table-ref/default *kv-tbl* key))
;
;
;    (define (insert! key val)
;      (hash-table-set! *kv-tbl* key val))
;
;    (define (update! key val)
;      (hash-table-set! *kv-tbl* key val))
;
;    (define (delete! key)
;      (hash-table-delete! *kv-tbl* key))

  )
)
