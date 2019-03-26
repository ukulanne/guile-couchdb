#!/usr/bin/env guile -s
!#

(load "./couchdb.scm")

(display (couchdb-create "panda"))
(newline)
(display (couchdb-get "panda" "tohui"))
(newline)
(display (couchdb-list "panda"))
