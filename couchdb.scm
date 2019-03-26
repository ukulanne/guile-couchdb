;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                  ;;
;; <ukulanne@gmail.com>          ;;
;; March 25, 2019                ;;
;; Guile web app server example  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

(use-modules (web uri)
	     (web client))

(define COUCHDB-SERVER "localhost")
(define COUCHDB-PORT 5984)
(define COUCHDB-USER #f)
(define COUCHDB-PASSWORD #f)
(define COUCHDB-DB #f)

;; (couchdb-use args) ;; server user password
;; (couchdb-create db)
;; (couchdb-get cdb id)
;; (couchdb-insert cdb id . rev)
;; (couchdb-list cdb)
;; (couchdb-delete cdb id)

(define (couchdb-use db) (set! COUCHDB-DB db))

(define (couchdb-create db)
  (let ((uri (build-uri 'http #:host COUCHDB-SERVER #:port COUCHDB-PORT #:path (string-append "/" db))))
    (display (string-append COUCHDB-SERVER "5984" "/" db))
    (call-with-values
        (lambda ()  (http-put uri #:keep-alive? #f))
      (lambda (request body) body))))

(define (couchdb-list cdb)
  (let ((uri (build-uri 'http #:host COUCHDB-SERVER #:port COUCHDB-PORT
                        #:path (string-append "/" cdb "?include_docs=true"))))
    (call-with-values
        (lambda ()  (http-get uri #:keep-alive? #f))
      (lambda (request body) body))))

(define (couchdb-get cdb id)
  (let ((uri (build-uri 'http #:host COUCHDB-SERVER #:port COUCHDB-PORT
                        #:path (string-append "/" cdb "/" id "?include_docs=true"))))
    (call-with-values
        (lambda ()  (http-get uri #:keep-alive? #f))
      (lambda (request body) body))))

(display (couchdb-create "panda"))
(display (couchdb-get "panda" "tohui"))
