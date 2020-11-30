;;;; Cloudburst web framework
;;;; https://github.com/cyclone-scheme/cloudburst
;;;;                                                                             
;;;; This module contains helper functions for working with URI's
;;;;             
(define-library (lib uri)
  (import 
    (scheme base)
    (prefix (scheme cyclone util) util:)
    (srfi 152)
  )
  (include-c-header "uri_encode.c")
  (export
    encode
    decode
    decode-form
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

(define (flatten x)                                                              
  (cond ((null? x) '())                                                          
        ((pair? x) (append (flatten (car x)) (flatten (cdr x))))                 
        (else (list x)))) 

    ;; Added to this module since it depends on (decode) and is closely
    ;; related to this module's original intended purpose:
    ;;
    ;; Decode application/x-www-form-urlencoded format. This format encodes an
    ;; ordered data sets of pairs consisting of a name and a value, with pairs 
    ;; seperated by ampersand or semicolon and names and values seperated by the 
    ;; equal sign. Space characters are replaced with plus sign and any characters
    ;; not in the unreserved character set is encoded using the percent-encoding 
    ;; scheme also used for resource identifiers. A percent-encoded octet is 
    ;; encoded as a character triplet, consisting of the percent character "%" 
    ;; followed by the two hexadecimal digits representing that octet's numeric value.
    ;;
    (define (decode-form str)
      (let* ((str* (util:string-replace-all str "+" " ")) ;; Convert + to spaces
             (spairs
                ;; Split pairs on & or ;
                (flatten 
                  (map (lambda (s) (string-split s ";")) 
                    (string-split str* "&"))))
             ;; Split name/values on =
             (pairs (map (lambda (s)
                           (string-split s "="))
                         spairs))
             ;; Decode all %HH encoded chars, and convert to pairs via cons
             (result
               (map 
                 (lambda(p)
                   (cons (decode (car p))
                         (decode (cadr p))))
                 pairs)))
          result))

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
