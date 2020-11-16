(import (scheme base) 
        (scheme write)
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

(define (usage)
  (display
    "Usage: cloudburst COMMAND

  Commands:
  
    help - Display this usage text
    ")
)

(usage)
