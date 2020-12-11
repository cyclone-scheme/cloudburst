(define-library (app models task)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
    (lib config)
    (cyclone postgresql)
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

;; TODO: instead of using config/postgres directly, extract that to a DB driver
;; and use something streamlined here

    (define (get-all)
      'todo
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
