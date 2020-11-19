(define-library (app models demo)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
    (srfi 69)
  )
  (export
    get-data
    *key-values*
  )
  (begin

    (define *key-values* 
      (alist->hash-table '((string . "Sample String")
                           (vector . #(sample vector))
                           (list . (sample list)))))

    ;; TODO: real app would probably read/write from a DB
    (define (get-data)
      '(1 2 3
        a b c
        "x" "y" "z"))
  ))
