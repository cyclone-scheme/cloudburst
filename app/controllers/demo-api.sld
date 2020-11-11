TODO: rename this rest-demo, provide post/put/delete functionality
      can use an in-memory object for testing/demo purposes

(define-library (app controllers demo)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
    (prefix (app models demo) demo-model:)
  )
  (export
    get:status
    get:test
    get:test2
  )
  (begin
    (define (get:status)
      (display (status-ok)))
    (define (get:test arg1)
      (display (demo-model:get-data)))
    (define (get:test2 arg1 arg2)
      (display "demo : test")
      (display ": ")
      (display arg1)
      (display ": ")
      (display arg2))
  ))
