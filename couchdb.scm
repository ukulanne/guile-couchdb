;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                  ;;
;; <ukulanne@gmail.com>          ;;
;; March 25, 2019                ;;
;; Couchdb guile wrapper         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Time-stamp: <2019-04-06 19:11:31 panda> 

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

(define CDB-PROTOCOL 'http)
(define CDB-SERVER "localhost")
(define CDB-PORT 5984)
(define CDB-USER #f)
(define CDDB-PASSWORD #f)

(define call/wv call-with-values)
(define* (make-uri path #:optional (query #f)) (build-uri CDB-PROTOCOL #:host CDB-SERVER #:port CDB-PORT #:path path #:query query))

(define-macro (define-couchdb-api api verb path tail)
  `(define* (,api . args)
     (let ((uri (make-uri (string-append ,path (apply string-append (map (lambda (x) (string-append x "/")) args)) ,tail))))
       (call/wv (lambda () (,verb uri #:decode-body? #t #:keep-alive? #t  #:headers `((content-type . (application/json)))))
                (lambda (request body) (utf8->string body))))))

(define-macro (define-couchdb-api-body api verb path tail) 
  `(define (,api cdb id json)
    (let ((uri (make-uri (string-append ,path cdb "/" id ,tail))))
      (call/wv (lambda () (,verb uri #:keep-alive? #f #:body json #:headers `((content-type . (application/json)))))
               (lambda (request body) (utf8->string body))))))

(define (couchdb-server-info) (string-append (symbol->string CDB-PROTOCOL) "://" CDB-SERVER ":" (number->string CDB-PORT)))
(define (couchdb-server! protocol url port)
  (set! CDB-PROTOCOL protocol)
  (catch #t
         (lambda () (if  (equal? 'https protocol)(use-modules (gnutls))))
         (lambda (k . p) (display "[ERROR] Module gnutls-guile not found and https cannot be used\n")(quit)))
  (set! CDB-SERVER url)
  (set! CDB-PORT port))

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

(define-couchdb-api-body couchdb-doc-insert http-put "/" "")
(define-couchdb-api-body couchdb-db-insert-bulk http-post "/" "_bulk_docs")

(define (couchdb-doc-delete db id rev)
  (let ((uri (make-uri (string-append "/" db "/" id) (string-append "rev=" rev))))
    (call/wv (lambda () (http-delete uri #:keep-alive? #f ))
             (lambda (request body) (utf8->string body)))))
