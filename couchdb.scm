;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                  ;;
;; <ukulanne@gmail.com>          ;;
;; March 25, 2019                ;;
;; Couchdb guile wrapper         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Time-stamp: <2019-04-06 17:23:07 panda> 

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

(define-module (couchdb)
  #:use-module (rnrs bytevectors) 
  #:use-module (web uri)
  #:use-module (web client)
  #:export (couchdb-db-create couchdb-db-changes couchdb-db-list couchdb-db-all-docs couchdb-doc-delete
            couchdb-doc-get couchdb-doc-insert  couchdb-db-insert-bulk couchdb-doc-list couchdb-root couchdb-server-info
            couchdb-server! couchdb-up? couchdb-version couchdb-uuids))

(define COUCHDB-SERVER "localhost")
(define COUCHDB-PORT 5984)
(define COUCHDB-USER #f)
(define COUCHDB-PASSWORD #f)

(define call/wv call-with-values)
(define* (make-uri path #:optional (query #f)) (build-uri 'http #:host COUCHDB-SERVER #:port COUCHDB-PORT #:path path #:query query))

(define-macro (define-couchdb-api api verb path tail)
  `(define* (,api . args)
     (let ((uri (make-uri (string-append ,path (apply string-append (map (lambda (x) (string-append x "/")) args)) ,tail))))
       (call/wv (lambda () (,verb uri #:decode-body? #t #:keep-alive? #t))
                (lambda (request body) (utf8->string body))))))

(define-macro (define-couchdb-api-body api verb path tail) 
  `(define (,api cdb id json)
    (let ((uri (make-uri (string-append ,path cdb "/" id ,tail))))
      (call/wv (lambda () (,verb uri #:keep-alive? #f #:body json #:headers `((content-type . (application/json)))))
               (lambda (request body) (utf8->string body))))))

(define (couchdb-server-info) (string-append "http://" COUCHDB-SERVER ":" (number->string COUCHDB-PORT)))
(define (couchdb-server! url port) (set! COUCHDB-SERVER url) (set! COUCHDB-PORT port))

(define-couchdb-api couchdb-root        http-get "/" "")
(define-couchdb-api couchdb-up?         http-get "/_up" "")
(define-couchdb-api couchdb-uuids       http-get "/_uuids?count=" "")
(define-couchdb-api couchdb-version     http-get "" "")
(define-couchdb-api couchdb-db-changes  http-get "/" " /db/_changes?style=all_docs")
(define-couchdb-api couchdb-db-list     http-get "/_all_dbs" "")
(define-couchdb-api couchdb-db-create   http-put "/" "")
(define-couchdb-api couchdb-db-all-docs http-get  "/" "/_all_docs")
(define-couchdb-api couchdb-doc-list    http-get "/" "?include_docs=true")
(define-couchdb-api couchdb-doc-get     http-get "/"  "?include_docs=true")

(define (couchdb-doc-delete db id rev)
  (let ((uri (make-uri (string-append "/" db "/" id) (string-append "rev=" rev))))
    (call/wv (lambda () (http-delete uri #:keep-alive? #f ))
             (lambda (request body) (utf8->string body)))))

(define-couchdb-api-body couchdb-doc-insert http-put "/" "")
(define-couchdb-api-body couchdb-db-insert-bulk http-post "/" "_bulk_docs")
