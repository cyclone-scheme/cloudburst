;;;; Cloudburst web framework
;;;; https://github.com/cyclone-scheme/cloudburst
;;;;                                                                             
;;;; This module contains helper functions for working with URI's
;;;;             
(define-library (lib uri)
  (import 
    (scheme base)
    (scheme cyclone util)
  )
  (include-c-header "uri_encode.c")
  (export
    encode
    decode
  )
  (begin
;size_t uri_encode (const char *src, const size_t len, char *dst);
;size_t uri_decode (const char *src, const size_t len, char *dst);

    (define-c decode
      "(void *data, int argc, closure _, object k, object uri)"
      " Cyc_check_str(data, uri);
        char *dst = alloca(string_len(uri) + 1); // Ensure sufficient space
        int bytes = uri_decode(string_str(uri),
                               string_len(uri),
                               dst);
        make_utf8_string_noalloc(str, dst, bytes);
        str.num_cp = Cyc_utf8_count_code_points((uint8_t *)dst); 
        return_closcall1(data, k, &str);
     ")

    (define-c encode
      "(void *data, int argc, closure _, object k, object uri)"
      " Cyc_check_str(data, uri);
        char *dst = alloca(string_len(uri) * 3 + 1); // Ensure sufficient space
                      // TODO: what if length is too large?
        int bytes = uri_encode(string_str(uri),
                               string_len(uri),
                               dst);
        make_utf8_string_noalloc(str, dst, bytes);
        str.num_cp = Cyc_utf8_count_code_points((uint8_t *)dst); 
        return_closcall1(data, k, &str);
     ")
  )
 )
