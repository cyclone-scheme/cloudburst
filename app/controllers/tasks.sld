(define-library (app controllers tasks)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
    (cyclone web temple)
  )
  (export
    index
  )
  (begin
    (define (index)
      (render "app/views/tasks.html" '()))

;    (define (view)
;      (render
;        "app/views/view-1.html"
;        '((rows . '(
;                    ("view-1.html" . "View 1")
;                    ("view-2.html" . "View 2")
;                    ("view-3.html" . "View 3")
;                   ))
;          (link . car)
;          (desc . cdr)))
;    )

  ))
