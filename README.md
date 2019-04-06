# guile-couchdb

Welcome to the fascinating world of Guile, Scheme and Couchdb. Why would you like to use it? I don't know. Not sure how many pandas are out there interested but please free to reach out with any issue or comments. API will be changing rapidly
so bear with me. My intentions is to wrap every single couchdb API function.

guile-couchdb wraps [couchdb's REST API](https://docs.couchdb.org/en/stable/api/index.html).

Happy Scheming!

# REQUIREMENTS

- [GNU Guile](https://www.gnu.org/software/guile/) 2.x
- A [couchdb](http://couchdb.apache.org/) server to connect to. Tested with 2.3.x but should work with older versions
- I use couchdb for Fedora from this [copr](https://copr.fedorainfracloud.org/coprs/adrienverge/couchdb/) and [github](https://github.com/adrienverge/copr-couchdb)
- test.scm uses [guile-json 3.1.0](https://github.com/aconchillo/guile-json) 

To be able to connect through https you will [gnutls-guile bindings](https://www.gnutls.org/manual/gnutls-guile.html).

# INSTALL
```
[panda@pandaville guile-couchdb]$ sudo ./install.scm 
[HELLO] Installer script for guile-couchdb
[INFO] Running under: Linux x86_64
[INFO] Guile version: 2.9.1
[INFO] Guile library dir: /usr/local/share/guile/3.0
[INFO] Module guile-json found
[WARN] Module gnutls-guile not found
[INFO] Installing couchdb.scm module...
[INFO] Installation was succesful
[INFO] You can now use couchdb.scm with (use-modules (couchdb))
[BUH-BYE] Happy scheming!

```

# API

### Server
 ```
 (couchdb-root)
 (couchdb-server! url port)
 (couchdb-server-info)
 (couchdb-up?) 
 (couchdb-uuids n)
 (couchdb-version)
```
### Database
```
 (couchdb-db-create cdb)
 (couchdb-db-index cdb)
 (couchdb-db-list)
 (couchdb-db-find selector)
``` 
 ## Doc
 ```
 (couchdb-doc-delete cdb id)
 (couchdb-doc-get cdb id)
 (couchdb-doc-insert cdb id . rev)
 (couchdb-doc-index cdb)
 (couchdb-doc-list cdb)

```

# test.scm

```
[panda@pandaville guile-couchdb]$ ./test.scm 
[INFO]    couchdb test using: http://localhost:5984
[INFO]    Guile version: 2.9.1
[COUCHDB] Couchdb server running: ok
[COUCHDB] Couchdb server version: 2.3.1
[COUCHDB] List all dbs: ["panda"]
[COUCHDB] Create DB panda
{"error":"file_exists","reason":"The database could not be created, the file already exists."}
[COUCHDB] Insert panda with id 'po'
{"error":"conflict","reason":"Document update conflict."}
[COUCHDB] Insert panda with id 'xiao'
{"ok":true,"id":"xiao","rev":"27-be31fddab5fbbcdf0015dc66eba459db"}
[COUCHDB] Get panda revision for id 'xiao'
27-be31fddab5fbbcdf0015dc66eba459db
[COUCHDB] Delete panda with id: 'xiao' and rev: 27-be31fddab5fbbcdf0015dc66eba459db
{"ok":true,"id":"xiao","rev":"28-8680843361a4b2e26b32abd31dfc2f08"}
```
# LICENSE

Copyright (C) 2019 Anne Summers &lt;ukulanne@gmail.com&gt;

guile-couchdb is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

guile-couchdb is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with guile-couchdb. If not, see https://www.gnu.org/licenses/.

