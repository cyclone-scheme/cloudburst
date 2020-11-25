;;;; The Cloudburst web framework
;;;; https://github.com/cyclone-scheme/cloudburst
;;;;
;;;; Copyright (c) 2020, Justin Ethier
;;;; All rights reserved.
;;;;
;;;; Unit tests of the framework's router module.
;;;;
(import (scheme base)
        (scheme char)
        (scheme write)
        (scheme eval)
        (scheme read)
        (scheme file)
        (scheme cyclone libraries)
        (scheme cyclone util)
        (cyclone web temple)
        (cyclone syslog)
        (cyclone test)
        (srfi 2)
        (srfi 18)
        (srfi 69)
        (lib dirent)
        (lib http)
        (prefix (lib request) req:)
        )

(include "lib/router.scm")

(define-syntax test/output
  (syntax-rules ()
      ((_ desc expected body ...)
       (_test/output
         desc
         expected
         (lambda ()
           body ...)))))

(define (_test/output desc expected thunk)
  (call-with-port 
    (open-output-string) 
    (lambda (p)
      (parameterize ((current-output-port p))
        (thunk)
        (test 
          desc
          expected
          (get-output-string p))))))

(test-group "Route Output"

  (test/output
   "Index Page"
   "Content-type: text/html\r\nStatus: 200 OK\r\n\r\nWelcome to my-app!"
   (route-to-controller "http://localhost/" "GET"))

  (test/output
   "Index Page (2)"
   "Content-type: text/html\r\nStatus: 200 OK\r\n\r\nWelcome to my-app!"
   (route-to-controller "http://localhost" "GET"))
)
   
; TODO: add more tests, perhaps after demo is finalized a bit -

;  ;; No controller, do we provide a default one?
;  (route-to-controller "http://10.0.0.4/" "GET") (newline)
;  ;; No action, should have a means of default
;  (route-to-controller "http://10.0.0.4/demo" "GET") (newline)
;  (route-to-controller "http://10.0.0.4/demo/" "GET") (newline)
;  ;; ID arguments, should provide them. also should error if mismatched (too many/few for controller's action
;  (route-to-controller "http://10.0.0.4/demo/test/1/2/3" "GET") (newline)
;  (route-to-controller "http://10.0.0.4/demo/test2/arg1/arg2" "GET") (newline)
;  (route-to-controller "http://10.0.0.4/demo/status" "GET") (newline)
;  (route-to-controller "http://10.0.0.4/demo2/test" "GET") (newline)
;  (route-to-controller "http://10.0.0.4/controller/action/id" "GET") (newline)
;  (route-to-controller "http://localhost/demo.cgi" "GET") (newline)

;; TODO: get this to work with top-level index, then another with ctrl index
;  (route-to-controller "http://localhost/demo2" "GET") (newline)

(test-exit)
