(define-library (app controllers index)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
  )
  (export
    index
  )
  (begin
    (define (index)
      (display "Welcome to my-app!"))
  ))
