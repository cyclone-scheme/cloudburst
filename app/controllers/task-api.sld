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

  )
  (begin

    (define (get:tasks)
      (task-model:get-all))

  ))

