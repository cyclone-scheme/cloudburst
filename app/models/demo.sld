(define-library (app models demo)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
    (srfi 69)
  )
  (export
    get
    get-all
    insert!
    update!
    delete!
    *kv-tbl*
  )
  (begin

    (define *kv-tbl*
      (alist->hash-table '((string . "Sample String")
                           (vector . '#((sample . list)))
                           (list . (sample list)))))

    ;; FUTURE: real app would probably read/write from a DB
    (define (get key)
      (hash-table-ref/default *kv-tbl* key))

    (define (get-all)
      (hash-table->alist *kv-tbl*))

    (define (insert! key val)
      (hash-table-set! *kv-tbl* key val))

    (define (update! key val)
      (hash-table-set! *kv-tbl* key val))

    (define (delete! key)
      (hash-table-delete! *kv-tbl* key))

  )
)
