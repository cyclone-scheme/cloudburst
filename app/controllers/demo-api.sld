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
      ;; This returns 404 if no key
      (when key
        (demo-model:insert! key value)
        `(Inserted ,key ,value))))

    (define (put:key-value)
      (let* ((vars (decode-form (req:body)))
             (key (form vars "key"))
             (value (form vars "value"))
            )
      ;; Return 404 if no key
      (when key
        (demo-model:update! key value)
        `(Updated ,key ,value))))

    (define (delete:key-value)
      (let* ((vars (decode-form (req:body)))
             (key (form vars "key"))
            )
      ;; Return 404 if no key
      (when key
        (demo-model:delete! key)
        `(Deleted ,key))))
  ))
