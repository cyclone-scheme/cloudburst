(define-library (app controllers demo-api)
  (import 
    (scheme base)
    (scheme write)
    (srfi 69)
    (lib json)
    ;(lib http)
    (prefix (lib request) req:)
    (prefix (app models demo) demo-model:)
  )
  (export
    ;; TODO: document significance of get: / post: /etc prefix
    ;;       for a REST API.

    ;; TODO: complete CRUD demo, can use in-memory storage since
    ;; it is just a demonstration
    ;get:status
;    get:test
;    get:test2

    ;; Sample REST API for "key-value" entities
    get:key-values
    post:key-value
    put:key-value
    delete:key-value

  )
  (begin

  ;; TODO: should return properly-formatted JSON. also what about
  ;; other data types?

;    (define (get:status)
;      (display (status-ok)))

;    (define (get:test arg1)
;      (display (demo-model:get-data)))
;
;    (define (get:test2 arg1 arg2)
;      (display "demo : test")
;      (display ": ")
;      (display arg1)
;      (display ": ")
;      (display arg2))

    (define (get:key-values)
      ;; TODO: easier to just return sexp from API functions, and let
      ;; framework do the JSON conversion?
     ; (display (scm->json (list->vector (hash-table->alist demo-model:*key-values*))))
      (display
        (->json (demo-model:get-all)))
    )

    (define (post:key-value)
;; TODO: some examples here: https://www.educative.io/edpresso/how-to-perform-a-post-request-using-curl
;;
;; TODO: how to decode URI-encoded chars in params, EG: & symbols? It might make sense to have a dedicated controller library (app controller) or such with helper for common tasks such as that
;;
;; TODO: see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/decodeURIComponent
;;
;; how to decode uri encoding in our framework -
;; also need to setup tests for below:
;;
;;function containsEncodedComponents(x) {
;;    // ie ?,=,&,/ etc
;;      return (decodeURI(x) !== decodeURIComponent(x));
;;}
;;
;;console.log(containsEncodedComponents('%3Fx%3Dtest')); // ?x=test
;;// expected output: true
;;
;;console.log(containsEncodedComponents('%D1%88%D0%B5%D0%BB%D0%BB%D1%8B')); // шеллы
;;// expected output: false

      (display `(body ,(req:body)))
      (display `(content-type ,(req:content-type)))
      (display `(content-length ,(req:content-length)))
      (display 'TODO-POST))

;; TODO: why do we get data corruption here??
;
; $ curl --data-urlencode "key=val ue" --data-urlencode "x=y" http://localhost/demo-api/key-value
; (DEBUG 16)(DEBUG key=val          3272717984e&x=y)(body key=val          3272879760e&x=y)(content-type application/x-www-form-urlencoded)(content-length 16)TODO-POST
;
; Maybe this is not data corruption at all, at least in our app. Perhaps we are 
; sending a response back with the wrong encoding????
    (define (put:key-value)
      (display 'TODO-PUT))

    (define (delete:key-value)
      (display 'TODO-DELETE))
  ))
