;;;; Minimal version of corresponding library from cyclone-winds.
;;;; Longer-term this should probably be consolidated with that one.
(define-library (lib system-calls)
  (import (scheme base)
          (only (scheme write) display)
          (srfi 28)) ; basic format strings
  (export  *log-level*
           ok?
           download!
           validate-sha256sum
           extract!
           delete!
           make-dir!
           copy-file-to-dir!
           copy-dir-to-dir!
           copy-file!
           touch!)
  (begin
    ;; Minimal log system
    (define *log-level* (make-parameter 'warning))

    (define-syntax DEBUG
      (syntax-rules ()
        ((_ cmd)
         (if (eq? (*log-level*) 'debug)
             cmd))))

    (define (DEBUG?)
      (eq? (*log-level*) 'debug))

    (define (ok? return-code)
      (eq? 0 return-code))

    (define (command-exists? command)
      (ok? (system (format "command -v ~a > /dev/null" command))))

    (define (download! url outfile)
      (let ((result
             (cond ((command-exists? "wget")
                    (if (DEBUG?)
                        (system (format "wget --progress=bar:force:noscroll -O ~a ~a" outfile url))
                        (system (format "wget --quiet -O ~a ~a > /dev/null" outfile url))))
                   ((command-exists? "curl")
                    (if (DEBUG?)
                        (system (format "curl -L ~a --output ~a" url outfile))
                        (system (format "curl -s -L ~a --output ~a" url outfile))))
                   (else (error (format "Could not find curl/wget. Please install one of those programs to continue~%"))))))
        (if (ok? result)
            (begin (DEBUG (display (format "[OK] Downloaded ~a~%" outfile)))
                   outfile)
            (error (format "Could not download ~a. Lack of permissions? Return code" outfile) result))))

    (define (validate-sha256sum sha256sum file)
      (let ((result
             (cond ((command-exists? "sha256sum")
                    (if (DEBUG?)
                        (system (format "echo ~a ~a | sha256sum --status --check -" sha256sum file))
                        (system (format "echo ~a ~a | sha256sum --status --check - > /dev/null" sha256sum file))))
                   ((command-exists? "sha256")
                    (if (DEBUG?)
                        (system (format "sha256 -c ~a ~a" sha256sum file))
                        (system (format "sha256 -c ~a ~a > /dev/null" sha256sum file))))
                   (else (error (format "Could not find sha256/sha256sum. Please install one of those programs to continue~%"))))))
        (if (ok? result)
            (begin (DEBUG (display (format "[OK] Passed sha256sum verification~%" )))
                   file)
            (error (format "Incorrect sha256sum for file ~a. Return code~%" file) result))))

    (define (extract! file dir)
      (let ((result (system (format "tar zxf ~a --strip=1 -C ~a" file dir))))
        (if (ok? result)
            (begin (DEBUG (display (format "[OK] Extracted ~a into ~a~%" file dir)))
                   dir)
            (error (format "Could not extract ~a into ~a. Lack of permissions? Return code" file dir) result))))

    (define (delete! file-or-dir)
      (let ((result (system (format "rm -Rf ~a" file-or-dir))))
        (if (ok? result)
            (begin (DEBUG (display (format "[OK] Deleted ~a~%" file-or-dir)))
                   file-or-dir)
            (error (format "Could not delete ~a. Lack of permissions? Return code" file-or-dir) result))))

    (define (make-dir! path)
      (let ((result (system (format "mkdir -p ~a" path))))
        (if (ok? result)
            (begin (DEBUG (display (format "[OK] Created dir ~a~%" path)))
                   path)
            (error (format "Could not create path ~a. Lack of permissions? Return code" path) result))))

    (define (copy-file-to-dir! file to-dir)
      (make-dir! to-dir)
      (let ((result (system (format "cp ~a ~a" file to-dir))))
        (if (ok? result)
            (begin (DEBUG (display (format "[OK] File ~a copied into ~a~%" file to-dir)))
                   file)
            (error (format "Could not copy file ~a into ~a. Lack of permissions? Return code" file to-dir) result))))

    (define (copy-dir-to-dir! dir to-dir)
      (make-dir! to-dir)
      (let ((result (system (format "cp -Rf ~a ~a" dir to-dir))))
        (if (ok? result)
            (begin (DEBUG (display (format "[OK] Directory ~a copied into ~a~%" dir to-dir)))
                   dir)
            (error (format "Could not copy directory ~a into ~a. Lack of permissions? Return code" dir to-dir) result))))

    (define (copy-file! file to-file)
      (let ((result (system (format "cp ~a ~a" file to-file))))
        (if (ok? result)
            (begin (DEBUG (display (format "[OK] File ~a copied to ~a~%" file to-file)))
                   file)
            (error (format "Could not copy file ~a to ~a. Lack of permissions? Return code" file to-file) result))))

    (define (touch! file)
      (let ((result (system (format "touch ~a" file))))
        (if (ok? result)
            (begin (DEBUG (display (format "[OK] Touched file ~a~%" file)))
                   file)
            (error (format "Could not touch file ~a. Lack of permissions? Return code" file) result))))))
