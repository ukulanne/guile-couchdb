#!/usr/local/bin/guile \
--no-auto-compile -s 
!#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                    ;;
;; <ukulanne@gmail.com>            ;;
;; March 26, 2019                  ;;
;; Couchdb guile module installer  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Time-stamp: <2019-04-05 23:11:38 panda> 

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
(define gj-msg "[INFO] Module guile-json found\n")
(define gtls-msg "[INFO] Module gnutls-guile found\n")
(define u (uname))

(display "[HELLO] Installer script for guile-couchdb\n")
(display (apply string-append `("[INFO] Running under: " ,(utsname:sysname u) " " ,(utsname:machine u) "\n")))
(display (string-append "[INFO] Guile version: " (version) "\n"))
(display (apply string-append `("[INFO] Guile library dir: " ,(%library-dir) "\n")))
(catch #t
       (lambda () (use-modules (json)))
       (lambda (k . p) (set! gj-msg "[WARN] Module guile-json not found\n")))
(catch #t
       (lambda () (use-modules (gnutls)))
       (lambda (k . p) (set! gtls-msg "[WARN] Module gnutls-guile not found\n")))
(display gj-msg)
(display gtls-msg)
(display "[INFO] Installing couchdb.scm module...\n")
(copy-file *COUCHDB-FILE* (string-append (%library-dir) "/" *COUCHDB-FILE*))
(display "[INFO] Installation was succesful\n")
(display "[INFO] You can now use couchdb.scm with (use-modules (couchdb))\n")
(display "[BUH-BYE] Happy scheming!\n")
