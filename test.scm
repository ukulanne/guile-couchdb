#!/usr//bin/guile \
--no-auto-compile -s
!#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                  ;;
;; <ukulanne@gmail.com>          ;;
;; March 26, 2019                ;;
;; Couchdb guile wrapper test    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Time-stamp: <2019-04-13 23:05:03 panda> 

;; Copyright (C) 2019 Anne Summers <ukulanne@gmail.com>

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

(use-modules (couchdb) (json))

;; Strings can be used to insert as documents:
(define tohui-json "{\"_id\": \"tohui\",\"name\": \"Tohui Panda\",\"country\": \"Mexico\"}")
(define po-json "{\"_id\": \"po\",\"name\": \"Po Kung Fu Panda\",\"country\": \"USA\"}")
(define bulk-json "{\"docs\": [{\"_id\": \"Pandette\"},{\"_id\" : \"Ying_ying\"}]}")

;; Scheme objects can be used and then turned into a json string thanks to guile-json
(define xiao-json '(("_id" . "xiao")
                    ("name" . "Xiao Liwu")
                    ("country" . "China")))

;;Whenever you try to set https as the protocol, guile loads it if available
(couchdb-server! 'https "localhost" 5984)

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
(display (couchdb-db-list))
(display "[COUCHDB] Create DB panda")
(newline)
(display (couchdb-db-create "panda"))
(display "[COUCHDB] Insert panda with id 'po'\n")
(display (couchdb-doc-insert "panda" "po" po-json))
(display "[COUCHDB] Insert panda with id 'xiao'\n")
(display (couchdb-doc-insert "panda" "xiao" (scm->json-string xiao-json)))
(display "[COUCHDB] Get panda revision for id 'xiao'\n")
(define xiao-rev  (cdr (assoc "_rev" (json-string->scm (couchdb-doc-get "panda" "xiao")))))
(display xiao-rev)(newline)
(display (string-append "[COUCHDB] Delete panda with id: 'xiao' and rev: " xiao-rev "\n"))
(display (couchdb-doc-delete "panda" "xiao" xiao-rev))
;;(display "[COUCHDB] Get all from db panda\n")
;;(newline)
;;(display (couchdb-list "panda"))
(display "[COUCHDB] Get 3 uuids: ")
(display (couchdb-uuids "3"))
;;(display "[COUCHDB] Show server root")
;;(display (couchdb-root))
(display "[COUCHDB] Bulk insert\n")
(display (couchdb-db-insert-bulk "panda" bulk-json))
(display "[COUCHDB] Display all documents:")
(display (couchdb-db-all-docs "panda"))
(display "[COUCHDB] Remove the pandas we just inserted\n")
(display (couchdb-doc-delete "panda" "Pandette" (cdr (assoc "_rev" (json-string->scm (couchdb-doc-get "panda" "Pandette"))))))
(display (couchdb-doc-delete "panda" "Ying_ying" (cdr (assoc "_rev" (json-string->scm (couchdb-doc-get "panda" "Ying_ying"))))))
;;(display "[COUCHDB] Display all changes:")
;;(display (couchdb-db-changes "panda")
;;FIXME:
(display "[COUCHDB] Bullk get\n")
(display (couchdb-db-bulk-get "panda" (scm->json-string `((docs . #(((id . tohui)) ((id . po))))))))
(display "[COUCHDB] Active tasks\n")
(display (couchdb-active-tasks))
