#!/usr/local/bin/guile -s 
!#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                  ;;
;; <ukulanne@gmail.com>          ;;
;; March 26, 2019                ;;
;; Couchdb guile wrapper test    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; Time-stamp: <2019-03-08 14:55:40 panda> 

(use-modules (json)
             (couchdb))

;;(load "./couchdb.scm")
(display "[INFO] couchdb test using localhost\n")
(display (string-append "[INFO] Guile version: " (version)))
(newline)
(newline)
(display "[COUCHDB] Couchdb server version")
(display (couchdb-version))
(newline)
(display "[COUCHDB] Create DB panda")
(newline)
(display (couchdb-create "panda"))
(newline)
(display "[COUCHDB] Get panda with id 'tohui'")
(display (couchdb-get "panda" "tohui"))
(newline)
(display "[COUCHDB] Get all from db panda")
(newline)
(display (couchdb-list "panda"))
