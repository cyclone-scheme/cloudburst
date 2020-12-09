(define-library (lib config)
  (import 
    (scheme base)
    (scheme cyclone util)
    (scheme file)
    (scheme read)
  )
  (export
    read-file
    value
  )
  (begin
    ;; TODO: just a placeholder, but the idea is for any helpers for sending responses to go here
    (define (read-file filename)
      (with-input-from-file filename (lambda () (read))))

    ;; Read configuration value for given config data structure and key
    (define (value config key)
      (with-handler
        (lambda (err)
          (error `(Unable to read configuration setting for key ,key error ,err)))
        (cdr (assoc key config))))
  ))

