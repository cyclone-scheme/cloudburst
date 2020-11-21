(define-library (app controllers demo-api)
  (import 
    (scheme base)
    (scheme write)
    (srfi 69)
    (cyclone json)
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

    ;; Sample REST API for "key-value" entities
    get:key-values
    post:key-value
    put:key-value
    delete:key-value

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

    (define (get:key-values)
      ;; TODO: easier to just return sexp from API functions, and let
      ;; framework do the JSON conversion?
      (display (scm->json (list->vector (hash-table->alist demo-model:*key-values*))))
      ;(display (hash-table->alist demo-model:*key-values*))
    )

    (define (post:key-value)
      (display 'TODO-POST))

    (define (put:key-value)
      (display 'TODO-PUT))

    (define (delete:key-value)
      (display 'TODO-DELETE))
  ))
