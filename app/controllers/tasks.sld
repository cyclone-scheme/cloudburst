(define-library (app controllers tasks)
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

  ))
