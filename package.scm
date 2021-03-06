(package
 (name           cloudburst)
 (version        0.1)
 (license        "MIT")
 (authors        "Justin Ethier")
 (maintainers    "Justin Ethier <justin.ethier at gmail dot com>")
 (description    "The Cloudburst web framework")
 (tags           "web" "networking")
 (docs           "https://github.com/cyclone-scheme/cloudburst/wiki/sha2")
 ;(test           "test-sha2.scm")
 (dependencies   (postgresql srfi-152 syslog temple))

 (program
   (name cloudburst)
   (description "Front-end program to make it easier to use Cloudburst"))
)
