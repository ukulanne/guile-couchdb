#!/usr/local/bin/guile \
--no-auto-compile -s
!#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                  ;;
;; <ukulanne@gmail.com>          ;;
;; March 26, 2019                ;;
;; Couchdb guile wrapper test    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Time-stamp: <2019-03-27 21:43:46 panda> 

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
(display "[COUCHDB] Get panda with id 'tohui'\n")
(display (couchdb-get "panda" "tohui"))
;;(display "[COUCHDB] Get all from db panda")
;;(newline)
;;(display (couchdb-list "panda"))
