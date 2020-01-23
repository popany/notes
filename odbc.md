# ODBC

## ODBC config

### Linux

#### oracle

[Using the Oracle ODBC Driver](https://docs.oracle.com/en/database/oracle/oracle-database/19/adfns/odbc-driver.html)

[Oracle Instant Client ODBC Installation Notes](https://www.oracle.com/database/technologies/releasenote-odbc-ic.html)

[ODBC Connection](https://docs.genesys.com/Documentation/ES/8.5.1/Depl/ODBC)

1. `odbc_update_ini.sh / <dir of libsqora.so*> <Driver_Name> <DSN> <ODBCINI>`

2. edit `ServerName` in `~/.odbc.ini`

3. 

##### problems
["\[unixODBC\]\[DriverSManager\]Can't open lib..."](https://stackoverflow.com/questions/22999798/01000unixodbcdriver-managercant-open-lib-usr-local-easysoft-oracle-inst)

[Package unixODBC is missing shared library libodbcinst.so.1](https://bugzilla.redhat.com/show_bug.cgi?id=498311)

## [ODBC Programmer's Reference](https://docs.microsoft.com/en-us/sql/odbc/reference/odbc-programmer-s-reference?view=sql-server-ver15)
