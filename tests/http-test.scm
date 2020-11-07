(import 
  (scheme base)
  (lib http)
  (cyclone test))

(test-group 
 "urls"
 (define url "http://10.0.0.4/demo/test2/arg1/arg2")
 (define url-p (url-parse url))
 (define path (url/p->path url url-p))

 (test "/demo/test2/arg1/arg2" path)
)

(test-exit)
