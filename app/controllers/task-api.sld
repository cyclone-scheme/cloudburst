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
    post:task
    put:task
    delete:task

  )
  (begin

    (define (get:tasks)
      (task-model:get-all))

    (define (post:task)
      (let* ((vars (decode-form (req:body)))
             (body (form vars "body"))
            )
      ;; This returns 404 if no body
      (when body
        (let ((id (task-model:insert! body)))
        `(Inserted ,body as id ,id)))))

    (define (put:task)
      (let* ((vars (decode-form (req:body)))
             (id (form vars "id"))
             (body (form vars "body"))
            )
      ;; Return 404 if no id
      (when id
        (task-model:update! id body)
        `(Updated ,id ,body))))

    (define (delete:task)
      (let* ((vars (decode-form (req:body)))
             (id (form vars "id"))
            )
      ;; Return 404 if no id
      (when id
        (task-model:delete! id)
        `(Deleted ,id))))

  ))

