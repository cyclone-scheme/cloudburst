(define-library (app controllers task-api)
  (import 
    (scheme base)
    (scheme write)
    (srfi 69)
    (lib json)
    (lib uri)
    (prefix (lib request) req:)
    (prefix (app models task) task-model:)
  )
  (export
    ;; Sample REST API for "key-value" entities
    get:tasks
    ;post:task
    ;put:task
    ;delete:task

  )
  (begin

    (define (get:tasks)
      (task-model:get-all))

    ;(define (post:key-value)
    ;  (let* ((vars (decode-form (req:body)))
    ;         (key (form vars "key"))
    ;         (value (form vars "value"))
    ;        )
    ;  ;; This returns 404 if no key
    ;  (when key
    ;    (demo-model:insert! key value)
    ;    `(Inserted ,key ,value))))

    ;(define (put:key-value)
    ;  (let* ((vars (decode-form (req:body)))
    ;         (key (form vars "key"))
    ;         (value (form vars "value"))
    ;        )
    ;  ;; Return 404 if no key
    ;  (when key
    ;    (demo-model:update! key value)
    ;    `(Updated ,key ,value))))

    ;(define (delete:key-value)
    ;  (let* ((vars (decode-form (req:body)))
    ;         (key (form vars "key"))
    ;        )
    ;  ;; Return 404 if no key
    ;  (when key
    ;    (demo-model:delete! key)
    ;    `(Deleted ,key))))

  ))

