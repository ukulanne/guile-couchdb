;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                  ;;
;; <ukulanne@gmail.com>          ;;
;; March 25, 2019                ;;
;; Couchdb guile wrapper         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Time-stamp: <2019-03-27 21:43:01 panda> 

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

(define-module (couchdb)
  #:use-module (rnrs bytevectors) 
  #:use-module (web uri)
  #:use-module (web client)
  #:export (couchdb-create couchdb-get couchdb-list couchdb-list-all
            couchdb-server-info couchdb-server! couchdb-up? couchdb-version))

;; SERVER
;; (couchdb-server! url port)
;; (couchdb-server-info)
;; (couchdb-up?)
;; (couchdb-version)

;; DATABASE
;; (couchdb-create db)
;; (couchdb-list-all)

;; DOC
;; (couchdb-delete cdb id)
;; (couchdb-get cdb id)
;; (couchdb-insert cdb id . rev)
;; (couchdb-find sexp)
;; (couchdb-find-by-json json)
;; (couchdb-index cdb)
;; (couchdb-list cdb)

(define COUCHDB-SERVER "localhost")
(define COUCHDB-PORT 5984)
(define COUCHDB-USER #f)
(define COUCHDB-PASSWORD #f)

(define (couchdb-make-uri path)
  (build-uri 'http #:host COUCHDB-SERVER #:port COUCHDB-PORT #:path path))

(define (couchdb-server-info) (string-append "http://" COUCHDB-SERVER ":" (number->string COUCHDB-PORT)))

(define (couchdb-server! url port)
  (set! COUCHDB-SERVER url)
  (set! COUCHDB-PORT port))

(define (couchdb-create db)
  (let ((uri (couchdb-make-uri (string-append "/" db))))
    (call-with-values
        (lambda () (http-put uri #:keep-alive? #f))
      (lambda (request body) (utf8->string body)))))

(define (couchdb-list cdb)
  (let ((uri (couchdb-make-uri (string-append "/" cdb "?include_docs=true"))))
    (call-with-values
        (lambda () (http-get uri #:keep-alive? #f))
      (lambda (request body) (utf8->string body)))))

(define (couchdb-list-all)
  (let ((uri (couchdb-make-uri (string-append "/_all_dbs"))))
    (call-with-values
        (lambda () (http-get uri #:keep-alive? #f))
      (lambda (request body) (utf8->string body)))))

(define (couchdb-get cdb id)
  (let ((uri (couchdb-make-uri (string-append "/" cdb "/" id "?include_docs=true"))))
    (call-with-values
        (lambda () (http-get uri #:decode-body? #t #:keep-alive? #f))
      (lambda (request body) (utf8->string body)))))

(define (couchdb-up?)
  (let ((uri (couchdb-make-uri "/_up")))
    (call-with-values
        (lambda () (http-get uri #:decode-body? #t #:keep-alive? #f))
      (lambda (request body) (utf8->string body)))))

(define (couchdb-version)
  (let ((uri (couchdb-make-uri "")))
    (call-with-values
        (lambda () (http-get uri #:keep-alive? #f))
      (lambda (request body) (utf8->string body)))))
