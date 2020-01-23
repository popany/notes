# ODBC

## ODBC config

### Linux

#### oracle

##### reference

[Using the Oracle ODBC Driver](https://docs.oracle.com/en/database/oracle/oracle-database/19/adfns/odbc-driver.html)

[Oracle Instant Client ODBC Installation Notes](https://www.oracle.com/database/technologies/releasenote-odbc-ic.html)

[ODBC Connection](https://docs.genesys.com/Documentation/ES/8.5.1/Depl/ODBC)

[Oracle Network Configuration (listener.ora , tnsnames.ora , sqlnet.ora)](https://oracle-base.com/articles/misc/oracle-network-configuration)

[Configuring the Oracle Net client](https://www.ibm.com/support/knowledgecenter/en/SSBNJ7_1.4.3/oracle/ttnpm_ora_configoraclenetclien.html)

[Profile Parameters (sqlnet.ora)](https://docs.oracle.com/cd/B28359_01/network.111/b28317/sqlnet.htm#NETRF006)

##### procedure

1. `odbc_update_ini.sh / <dir of libsqora.so*> <Driver_Name> <DSN> <ODBCINI>`

2. edit `~/TNSNAMES.ora`

3. edit `ServerName` in `~/.odbc.ini` with respect to `TNSNAMES.ora`

##### problems
["\[unixODBC\]\[DriverSManager\]Can't open lib..."](https://stackoverflow.com/questions/22999798/01000unixodbcdriver-managercant-open-lib-usr-local-easysoft-oracle-inst)

[Package unixODBC is missing shared library libodbcinst.so.1](https://bugzilla.redhat.com/show_bug.cgi?id=498311)

[ORA-12154: TNS:could not resolve the connect identifier specified](https://docs.oracle.com/cd/B19306_01/server.102/b14219/net12150.htm)

## [ODBC Programmer's Reference](https://docs.microsoft.com/en-us/sql/odbc/reference/odbc-programmer-s-reference?view=sql-server-ver15)
