# tools

## [tnsping](http://www.orafaq.com/wiki/Tnsping)

**TNSPING** is a utility in the [ORACLE HOME](http://www.orafaq.com/wiki/ORACLE_HOME)/bin directory used to test if a [SQL*Net](http://www.orafaq.com/wiki/SQL*Net) [connect string](http://www.orafaq.com/wiki/Connect_string) can connect to a remote [listener](http://www.orafaq.com/wiki/Listener) (check if the socket is reachable).

Note: This utility only tests if the listener is available. It cannot tell if the databases behind the listener is up or not.

### Examples

When using a local [TNSNAMES.ORA](http://www.orafaq.com/wiki/Tnsnames.ora) file - `NAMES.DIRECTORY_PATH=(TNSNAMES)` in [sqlnet.ora](http://www.orafaq.com/wiki/Sqlnet.ora):

    $ tnsping myDB

    TNS Ping Utility for Linux: Version 10.2.0.1.0 - Production on 24-MAY-2007 08:55:13
    Copyright (c) 1997, 2005, Oracle.  All rights reserved.
    Used parameter files:
    /app/oracle/product/10.2.0/db_1/network/admin/sqlnet.ora

    Used TNSNAMES adapter to resolve the alias
    Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = MyDB)))
    OK (10 msec)

When using an [LDAP](http://www.orafaq.com/wiki/LDAP) ([OID](http://www.orafaq.com/wiki/OID)) server - `NAMES.DIRECTORY_PATH=(LDAP)` in [sqlnet.ora](http://www.orafaq.com/wiki/Sqlnet.ora):

    $ tnsping myDB

    TNS Ping Utility for Solaris: Version 9.2.0.7.0 - Production on 10-DEC-2007 15:05:50
    Copyright (c) 1997 Oracle Corporation.  All rights reserved.
    Used parameter files:
    /app/oracle/product/10.2.0/db_1/network/admin/sqlnet.ora

    Used LDAP adapter to resolve the alias
    Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = MyDB)))
    OK (300 msec)

