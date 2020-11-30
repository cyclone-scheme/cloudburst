(define-library (app controllers demo-api)
  (import 
    (scheme base)
    (scheme write)
    (srfi 69)
    (lib json)
    (lib uri)
    (prefix (lib request) req:)
    (prefix (app models demo) demo-model:)
  )
  (export
    ;; TODO: document significance of get: / post: /etc prefix
    ;;       for a REST API.

    ;; TODO: complete CRUD demo, can use in-memory storage since
    ;; it is just a demonstration
    ;get:status
;    get:test
;    get:test2

    ;; Sample REST API for "key-value" entities
    get:key-values
    post:key-value
    put:key-value
    delete:key-value

  )
  (begin

  ;; TODO: should return properly-formatted JSON. also what about
  ;; other data types?

;    (define (get:status)
;      (display (status-ok)))

;    (define (get:test arg1)
;      (display (demo-model:get-data)))
;
;    (define (get:test2 arg1 arg2)
;      (display "demo : test")
;      (display ": ")
;      (display arg1)
;      (display ": ")
;      (display arg2))

    (define (get:key-values)
      ;; TODO: easier to just return sexp from API functions, and let
      ;; framework do the JSON (or whatever) conversion
      (display
        (->json (demo-model:get-all)))
    )

    (define (post:key-value)
      (let* ((vars (decode-form (req:body)))
             (key (form vars "key"))
             (value (form vars "value"))
            )
      ;; TODO: 404 (500?) if no key or value
      (demo-model:insert! key value)
      ;; TODO: would be nice if we could just return a value from REST API
      (write `(Inserted ,key ,value))
    ))

    (define (put:key-value)
      (let* ((vars (decode-form (req:body)))
             (key (form vars "key"))
             (value (form vars "value"))
            )
      ;; TODO: 404 (500?) if no key or value
      (demo-model:update! key value)
      ;; TODO: would be nice if we could just return a value from REST API
      (write `(Updated ,key ,value))
    ))

    (define (delete:key-value)
      (let* ((vars (decode-form (req:body)))
             (key (form vars "key"))
            )
      ;; TODO: 404 (500?) if no key or value
      (demo-model:delete! key)
      ;; TODO: would be nice if we could just return a value from REST API
      (write `(Deleted ,key))
    ))
  ))
