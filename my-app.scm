;;
;; TODO: move all of the framework logic below into a library,
;;       figure out what actually needs to be in the main program

(import (scheme base)
        (scheme char)
        (scheme write)
        (scheme eval)
        (scheme read)
        (scheme file)
        (scheme cyclone libraries)
        (scheme cyclone util)
        (cyclone web temple)
        (srfi 2)
        (srfi 18)
        (srfi 69)
        (lib dirent)
        (lib http)
        (lib log)
        (prefix (lib request) req:)
        (lib fcgi))

(include "lib/router.scm")

;; Dynamically import and load controllers
(dyn-import)
(gen-ctrl-table)


;; TODO: command-line interface to allow testing (maybe -t?) or just run as an
;;       FCGI service (default behavior)

;; TESTING
(begin
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

  (exit 0)
) ;; END


(fcgx:init)
;; TODO: initiate minor GC to ensure no thread-local data??
;; TODO: make this multithreaded based on the threaded.c example
;; TODO: make sure to include error handling via with-handler 

(define (main-handler)
  (fcgx:loop 
    (lambda (req)
      ;; TODO: need to fix dynamic-wind to guarantee after section is called, otherwise
      ;; what happens if error is called by a controller? may be able to get around it
      ;; by having a with-handler though to catch any exceptions
      (parameterize ((current-output-port (open-output-string)))
        (with-handler
          (lambda (err)
            (log-error (string-append "Error in fcgx:loop: ") err)
            (send-error-response "Internal error"))
          (let ((uri (fcgx:get-param req "REQUEST_URI" ""))
                (req-method (fcgx:get-param req "REQUEST_METHOD" "GET")))
            (route-to-controller uri req-method))
          (fcgx:print-request req (get-output-string (current-output-port))))))))

;          (display (http:make-header "text/html" 200))
;;          ;(display "Hello, world:")
;;          (display `(DEBUG1 ,(Cyc-opaque? req) ,req))
;;          (display `(DEBUG2 ,(Cyc-opaque? (thread-specific (current-thread))) ,(thread-specific (current-thread))))
;
;;;TODO: create a new (lib fcgi ???) to make it easier to get params, etc
;;;write such that the API expects to be user-facing
;
;          (display (req:method)) ;(fcgx:get-param req "REQUEST_METHOD" "GET"))
;          (display (req:body))
;          (display (req:content-type))
;          ; TODO: example of getting POST (put, delete??) params, will need later
;          ;(let* ((len-str (fcgx:get-param req "CONTENT_LENGTH" "0"))
;          ;       (len (string->number len-str))
;          ;       (len-num (if len len 0)))
;          ;  (display "<p>") ;; TODO: function like "(htm:p)" to make this easier???
;          ;  (display (fcgx:get-string req len-num))
;          ;  (display "<p>"))
;          (fcgx:print-request req (get-output-string (current-output-port))))))))

;; TODO: make number of thread configurable?
(let loop ((i 20))
  (thread-start! (make-thread main-handler))
  (if (> i 1)
      (loop (- i 1))))
(main-handler)
