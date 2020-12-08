(define-library (app controllers graph)
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
      (render
        "app/views/graph.html"
        '())
    )

    ;; TODO: CPU graph, what else?
    ;; TODO: bunch of demo's, all linked from index page
  )
)
