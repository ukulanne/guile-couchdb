;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                  ;;
;; <ukulanne@gmail.com>          ;;
;; March 25, 2019                ;;
;; Couchdb guile wrapper         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Time-stamp: <2019-03-29 19:01:15 panda> 

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
  #:export (couchdb-db-create couchdb-doc-delete couchdb-doc-get couchdb-doc-insert couchdb-doc-list couchdb-db-list
            couchdb-server-info couchdb-server! couchdb-up? couchdb-version))

;; SERVER
;; (couchdb-server! url port)
;; (couchdb-server-info)
;; (couchdb-up?) 
;; (couchdb-version)

;; DATABASE
;; (couchdb-db-create db)
;; (couchdb-db-list)

;; DOC
;; (couchdb-doc-delete cdb id)
;; (couchdb-doc-get cdb id)
;; (couchdb-doc-insert cdb id . rev)
;; (couchdb-doc-find sexp)
;; (couchdb-doc-find-by-json json)
;; (couchdb-doc-index cdb)
;; (couchdb-doc-list cdb)

(define COUCHDB-SERVER "localhost")
(define COUCHDB-PORT 5984)
(define COUCHDB-USER #f)
(define COUCHDB-PASSWORD #f)

;;FIXME Just one with define* to handle #:query
(define (couchdb-make-uri path)
  (build-uri 'http #:host COUCHDB-SERVER #:port COUCHDB-PORT #:path path))
;;(define* (panda #:optional (a 1) (b 2))(display a)(newline)(display b))
(define (couchdb-make-uri-with-query path query)
         (build-uri 'http #:host COUCHDB-SERVER #:port COUCHDB-PORT #:path path #:query query))


(define (couchdb-server-info) (string-append "http://" COUCHDB-SERVER ":" (number->string COUCHDB-PORT)))

(define (couchdb-server! url port)
  (set! COUCHDB-SERVER url)
  (set! COUCHDB-PORT port))

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



(define (couchdb-db-create db)
  (let ((uri (couchdb-make-uri (string-append "/" db))))
    (call-with-values
        (lambda () (http-put uri #:keep-alive? #f))
      (lambda (request body) (utf8->string body)))))

(define (couchdb-db-list)
  (let ((uri (couchdb-make-uri (string-append "/_all_dbs"))))
    (call-with-values
        (lambda () (http-get uri #:keep-alive? #f))
      (lambda (request body) (utf8->string body)))))

(define (couchdb-doc-delete db id rev)
  (let ((uri (couchdb-make-uri-with-query (string-append "/" db "/" id) (string-append "rev=" rev))))
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
