(define-library (lib log)
  (import 
    (scheme base)
    (scheme write))
  (export
    log-notice
    log-error)
  (begin
    (define (log-error msg . err)
      (let ((fp (current-error-port)))
        (display msg fp)
        (newline fp)
        (if (not (null? err))
            (display err fp))
        (newline fp)))
    
    (define log-notice log-error)
  )
)
