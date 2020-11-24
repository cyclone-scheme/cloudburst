(define-library (app controllers demo)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
    (cyclone web temple)
  )
  (export
    ;; Functions exported here are URL "routes" 
    ;; TODO: better description, and documentation for this
    index
    view
    test
    get:test2
  )
  (begin
    (define (index)
    ;; TODO: link to view instead, and explain what is happening a bit more
    ;;  EG: "this is the cb demo, here are links to some other pages"
      (display "demo index page"))
    (define (view)
      (render
        "app/views/view-1.html"
        '((rows . '(
                    ("view-1.html" . "View 1")
                    ("view-2.html" . "View 2")
                    ("view-3.html" . "View 3")
                   ))
          (link . car)
          (desc . cdr)))
    )

    (define (test)
      (display "demo test"))

    (define (get:test2 arg1 arg2)
      (display "demo : test")
      (display ": ")
      (display arg1)
      (display ": ")
      (display arg2))
  ))
