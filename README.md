# guile-couchdb

Hello. This library is work in progress. Why would you like to use it? I don't know. Not sure how many pandas out there
are interested in guile and couchdb but please free to reach out with any issue or comments. API will be changing rapidly
so bear with me.

Happy Scheming!

# REQUIREMENTS

- [GNU Guile](https://www.gnu.org/software/guile/) 2.x
- A [couchdb](http://couchdb.apache.org/) server to connect to. Tested with 2.3.x but should work with older versions
- I use couchdb for Fedora from this [copr](https://copr.fedorainfracloud.org/coprs/adrienverge/couchdb/) and [github](https://github.com/adrienverge/copr-couchdb)
- test.scm uses [guile-json 3.1.0](https://github.com/aconchillo/guile-json) 

# INSTALL
```
[panda@pandaville guile-couchdb]$ sudo ./install.scm 
[HELLO] Installer script for couchdb.scm
[INFO] Guile version: 2.9.1
[INFO] Guile library dir: /usr/local/share/guile/3.0
[INFO] Installing couchdb.scm module...
[INFO] Installation was succesful
[INFO] You can now use couchdb.scm with (use-modules (couchdb))
[BYE] Happy scheming!
```

# API

`(couchdb-create db)`

`(coucdhb-db-delete db)`

`(couchdb-get cdb id)`

`(couchdb-insert cdb id . rev)`

`(couchdb-list cdb)`

`(couchdb-delete cdb id)`

`(couchdb-version)`

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
[COUCHDB] Get panda with id 'tohui'
{"_id":"tohui","_rev":"1-3e4f3249025980223cfbe7a7b750986e","name":"Tohui Panda","country":"Mexico"}
```
# LICENSE

Copyright (C) 2019 Anne Summers <ukulanne@gmail.com>

guile-couchdb is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

guile-couchdb is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with guile-couchdb. If not, see https://www.gnu.org/licenses/.

