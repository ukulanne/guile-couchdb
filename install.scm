#!/usr/local/bin/guile \
--no-auto-compile -s 
!#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                    ;;
;; <ukulanne@gmail.com>            ;;
;; March 26, 2019                  ;;
;; Couchdb guile module installer  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Time-stamp: <2019-03-27 21:49:18 panda> 

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

(define *COUCHDB-FILE* "couchdb.scm")

(display "[HELLO] Installer script for couchdb.scm\n")
(display (string-append "[INFO] Guile version: " (version) "\n"))
(display (apply string-append `("[INFO] Guile library dir: " ,(%library-dir) "\n")))
(display "[INFO] Installing couchdb.scm module...\n")
(copy-file *COUCHDB-FILE* (string-append (%library-dir) "/" *COUCHDB-FILE*))
(display "[INFO] Installation was succesful\n")
(display "[INFO] You can now use couchdb.scm with (use-modules (couchdb couchdb))\n")
(display "[BYE] Happy scheming!\n")
