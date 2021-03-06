(import (scheme base) 
        (scheme file)
        (scheme process-context)
        (scheme write)
        (cyclone match)
        (cyclone web temple)
        (lib system-calls)
        )

;; TODO:
;;
;;    Commands like "create (name)", "add ctrl", etc
;;    
;;    Create downloads a copy of tagged repo via whet, unpacks, and renames as needed
;;    
;;    Adding new objects could take one from a Template directory and replace symbols as needed. Envision comments with file explaining how it works (optional?)
;;    Also template controllers could be literal templates that we use temple to render, so we can preserve comments and dynamically add scheme code
;;    
;;    Cyclone winds just installs tool program, with dependencies
;;    
;;    How to install C deps? May include instructions in readme
;;    
;;    Need CI to do all this in the cloud for testing
;;    
;;    Need to figure out deployment, what goes along with app? How are views handled? Do we compile them now?
;;    What else?
;;

;; TODO: this particular URL is only temporary, also need a means of comparing a SHA256 to verify integrity/identity
(define *default-cb-tar-gz-url* "https://github.com/cyclone-scheme/cloudburst/archive/master.tar.gz")

(define (usage)
  (display
    "Usage: cloudburst COMMAND

  Commands:
  
    init NAME - Create a new Cloudburst project in directory NAME
    add ctrl NAME - Add a new controller called NAME
    help - Display this usage text

    ")
  ;; TODO:
    ;add rest NAME - Add a new REST controller called NAME
    ;add model NAME - Add a new model called NAME
    ;add view NAME - Add a new view called NAME
)

(define (main cmd)
  (match 
    cmd
    (("init" name)
     (main `("init" ,name ,*default-cb-tar-gz-url*)))
    (("init" name url)
     (when (file-exists? name)
       (error `(Project ,name already exists)))
     (download! url "cb.tar.gz")
     (make-dir! name)
     (extract! "cb.tar.gz" name)
    )
    (("add" "ctrl" name)
     (with-output-to-file
       (string-append "app/controllers/" name ".sld")
       (lambda ()
         (render "templates/ctrl.sld" `((name . ,name))))))
    (else
      (usage))))

(main (cdr (command-line)))
