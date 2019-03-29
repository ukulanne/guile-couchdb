#!/usr/local/bin/guile \
--no-auto-compile -s
!#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                  ;;
;; <ukulanne@gmail.com>          ;;
;; March 26, 2019                ;;
;; Couchdb guile wrapper test    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Time-stamp: <2019-03-28 20:25:59 panda> 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    This program is free software: you can redistribute it and/or modify         ;;
;;    it under the terms of the GNU Lesser General Public License as published by  ;;
;;    the Free Software Foundation, either version 3 of the License, or            ;;
;;    (at your option) any later version.                                          ;;
;;                                                                                 ;;
;;    This program is distributed in the hope that it will be useful,              ;;
;;    but WITHOUT ANY WARRANTY; without even the implied warranty of               ;;
;;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                ;;
;;    GNU Lesser General Public License for more details.                          ;;
;;                                                                                 ;;
;;    You should have received a copy of the GNU Lesser General Public License     ;;
;;    along with this program.  If not, see <https://www.gnu.org/licenses/>.       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-modules (json)
             (couchdb))

;; Normal string can be used to insert as documents:
(define tohui-json "{\"_id\": \"tohui\",\"name\": \"Tohui Panda\",\"country\": \"Mexico\"}")
(define po-json "{\"_id\": \"po\",\"name\": \"Po Kung Fu Panda\",\"country\": \"USA\"}")

;; Scheme objects can be used and then turned into a json string:
(define xiao-json '(("_id" . "xiao")
                    ("name" . "Xiao Liwu")
                    ("country" . "China")))

(display "[INFO]    couchdb test using: ")
(display (couchdb-server-info))
(newline)
(display (string-append "[INFO]    Guile version: " (version) "\n"))
(display "[COUCHDB] Couchdb server running: ")
(display (cdr (assoc "status" (json-string->scm (couchdb-up?)))))
(newline)
(display "[COUCHDB] Couchdb server version: ")
(display (cdr (assoc "version" (json-string->scm (couchdb-version)))))
(newline)
(display "[COUCHDB] List all dbs: ")
(display (couchdb-list-all))
(display "[COUCHDB] Create DB panda")
(newline)
(display (couchdb-create "panda"))
(display "[COUCHDB] Insert panda with id 'po'\n")
(display (couchdb-insert "panda" "po" po-json))
(display "[COUCHDB] Insert panda with id 'xiao'\n")
(display (couchdb-insert "panda" "xiao" (scm->json-string xiao-json)))
(display "[COUCHDB] Get panda revision for id 'xiao'\n")
(define xiao-rev  (cdr (assoc "_rev" (json-string->scm (couchdb-get "panda" "xiao")))))
(display xiao-rev)(newline)
(display (string-append "[COUCHDB] Delete panda with id: 'xiao' and rev: "))
(display (couchdb-doc-delete "panda" "xiao" xiao-rev))
;;(display "[COUCHDB] Get all from db panda\n")
;;(newline)
;;(display (couchdb-list "panda"))
