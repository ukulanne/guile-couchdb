;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                  ;;
;; <ukulanne@gmail.com>          ;;
;; March 25, 2019                ;;
;; Couchdb guile wrapper         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Time-stamp: <2019-04-05 04:17:47 panda> 

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
  #:export (couchdb-db-create couchdb-db-list couchdb-doc-delete couchdb-doc-get couchdb-doc-insert couchdb-doc-list 
            couchdb-server-info couchdb-server! couchdb-up? couchdb-version couchdb-uuids))

;; SERVER
;; (couchdb-root)
;; (couchdb-server! url port)
;; (couchdb-server-info)
;; (couchdb-up?) 
;; (couchdb-uuids n)
;; (couchdb-version)
;; DATABASE
;; (couchdb-db-create db)
;; (couchdb-db-index db)
;; (couchdb-db-list)
;; (couchdb-db-find selector)
;; DOC
;; (couchdb-doc-delete cdb id)
;; (couchdb-doc-get cdb id)
;; (couchdb-doc-insert cdb id . rev)
;; (couchdb-doc-index cdb)
;; (couchdb-doc-list cdb)

(define COUCHDB-SERVER "localhost")
(define COUCHDB-PORT 5984)
(define COUCHDB-USER #f)
(define COUCHDB-PASSWORD #f)

(define* (couchdb-make-uri path #:optional (query #f))
  (build-uri 'http #:host COUCHDB-SERVER #:port COUCHDB-PORT #:path path #:query query))
(define* (make-uri path #:optional (query #f))
  (build-uri 'http #:host COUCHDB-SERVER #:port COUCHDB-PORT #:path path #:query query))

(define-macro (define-couchdb-api api verb path)
  `(define* (,api #:optional (db ""))
     (let ((uri (make-uri (string-append ,path db))))
    (call-with-values
        (lambda () (,verb uri #:decode-body? #t #:keep-alive? #f))
      (lambda (request body) (utf8->string body))))))

(define (couchdb-server-info) (string-append "http://" COUCHDB-SERVER ":" (number->string COUCHDB-PORT)))

(define (couchdb-server! url port)
  (set! COUCHDB-SERVER url)
  (set! COUCHDB-PORT port))
(define-couchdb-api couchdb-root http-get "/")
(define-couchdb-api couchdb-up? http-get "/_up")
(define-couchdb-api couchdb-version http-get "")
(define-couchdb-api couchdb-db-list http-get "/_all_dbs")
(define-couchdb-api couchdb-db-create http-put "/")
(define-couchdb-api couchdb-uuids http-get "/_uuids?count=")

(define (couchdb-doc-delete db id rev)
  (let ((uri (couchdb-make-uri (string-append "/" db "/" id) (string-append "rev=" rev))))
    (call-with-values
        (lambda () (http-delete uri #:keep-alive? #f ))
      (lambda (request body) (utf8->string body)))))

(define (couchdb-doc-get cdb id)
  (let ((uri (couchdb-make-uri (string-append "/" cdb "/" id "?include_docs=true"))))
    (call-with-values
        (lambda () (http-get uri #:decode-body? #t #:keep-alive? #f))
      (lambda (request body) (utf8->string body)))))

(define (couchdb-doc-insert db id json)
  (let ((uri (couchdb-make-uri (string-append "/" db "/" id))))
    (call-with-values
        (lambda () (http-put uri #:keep-alive? #f #:body json))
      (lambda (request body) (utf8->string body)))))

(define (couchdb-doc-list cdb)
  (let ((uri (couchdb-make-uri (string-append "/" cdb "?include_docs=true"))))
    (call-with-values
        (lambda () (http-get uri #:keep-alive? #f))
      (lambda (request body) (utf8->string body)))))


