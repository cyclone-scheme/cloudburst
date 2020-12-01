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
    ;; Sample REST API for "key-value" entities
    get:key-values
    post:key-value
    put:key-value
    delete:key-value

  )
  (begin

    (define (get:key-values)
      ;; For REST functions we return sexp to the framwork and
      ;; let it do the JSON (or whatever) conversion
      (demo-model:get-all))

    (define (post:key-value)
      (let* ((vars (decode-form (req:body)))
             (key (form vars "key"))
             (value (form vars "value"))
            )
      ;; TODO: 404 (500?) if no key or value
      (demo-model:insert! key value)
      ;; TODO: would be nice if we could just return a value from REST API
      `(Inserted ,key ,value)
    ))

    (define (put:key-value)
      (let* ((vars (decode-form (req:body)))
             (key (form vars "key"))
             (value (form vars "value"))
            )
      ;; TODO: 404 (500?) if no key or value
      (demo-model:update! key value)
      ;; TODO: would be nice if we could just return a value from REST API
      `(Updated ,key ,value)
    ))

    (define (delete:key-value)
      (let* ((vars (decode-form (req:body)))
             (key (form vars "key"))
            )
      ;; TODO: 404 (500?) if no key or value
      (demo-model:delete! key)
      ;; TODO: would be nice if we could just return a value from REST API
      `(Deleted ,key)
    ))
  ))
