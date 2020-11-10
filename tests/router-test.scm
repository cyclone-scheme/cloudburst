
(import (scheme base)
        (scheme char)
        (scheme write)
        (scheme eval)
        (scheme read)
        (scheme file)
        (scheme cyclone libraries)
        (scheme cyclone util)
        (cyclone web temple)
        (cyclone test)
        (srfi 2)
        (srfi 18)
        (srfi 69)
        (lib dirent)
        (lib http)
        (lib log)
        (prefix (lib request) req:)
        ;(lib fcgi)
        )

(include "lib/router.scm")

(test-group
  "TODO"
  (test 1 1))

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
  (route-to-controller "http://localhost/" "GET") (newline)
  (route-to-controller "http://localhost" "GET") (newline)
  (route-to-controller "http://localhost/demo2" "GET") (newline)

(test-exit)
