# Glossary

- [Glossary](#glossary)
  - [ORACLE SID](#oracle-sid)
    - [Switching between databases](#switching-between-databases)

## [ORACLE SID](http://www.orafaq.com/wiki/ORACLE_SID)

The Oracle System ID ([SID](http://www.orafaq.com/wiki/SID)) is used to uniquely identify a particular database on a system. For this reason, one cannot have more than one database with the same SID on a computer system.

When using [RAC](http://www.orafaq.com/wiki/RAC), all instances belonging to the same database must have unique SID's.

### Switching between databases

Set the ORACLE_SID environment variable (or ORA_SID on VMS systems) to work on a particular database. Remember that the SID is case sensitive in Unix / Linux environments.

- Windows:

      set ORACLE_SID=orcl

- Unix/ Linux:

      export ORACLE_SID=orcl
