(define-library (app controllers demo-api)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
    (prefix (app models demo) demo-model:)
  )
  (export
    ;; TODO: document significance of get: / post: /etc prefix
    ;;       for a REST API.

    ;; TODO: complete CRUD demo, can use in-memory storage since
    ;; it is just a demonstration
    get:status
    get:test
    get:test2
  )
  (begin

  ;; TODO: should return properly-formatted JSON. also what about
  ;; other data types?

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
