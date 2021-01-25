;; Simple library for working with S-expression based config files
;;
;; Assumes the config is a single list of a-lists so we can read
;; keys via assoc, or potentially load them into a hash table.
;;
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
    ;; Read config file as a single S-expression
    (define (read-file filename)
      (with-handler
        (lambda (err)
          (error `(Unable to read configuration file ,filename ,err)))
        (with-input-from-file filename (lambda () (read)))))

    ;; Read configuration value for given config data structure and key
    (define (value config key)
      (with-handler
        (lambda (err)
          (error `(Unable to read configuration setting for key ,key error ,err)))
        (cdr (assoc key config))))
  ))

