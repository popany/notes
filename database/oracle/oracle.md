# Oracle

- [Oracle](#oracle)
  - [Oracle Network Configuration (listener.ora, tnsnames.ora, sqlnet.ora)](#oracle-network-configuration-listenerora-tnsnamesora-sqlnetora)
    - [Assumptions](#assumptions)
    - [listener.ora](#listenerora)
    - [tnsnames.ora](#tnsnamesora)
    - [sqlnet.ora](#sqlnetora)
    - [Testing](#testing)
  - [Troubleshooting](#troubleshooting)
    - [ORA-28040: No matching authentication protocol](#ora-28040-no-matching-authentication-protocol)
    - [ORA-01950: no privileges on tablespace 'USERS'](#ora-01950-no-privileges-on-tablespace-users)
  - [sqlplus](#sqlplus)
    - [Run Oracle SQL*PLUS Script from Command Line in Windows](#run-oracle-sqlplus-script-from-command-line-in-windows)
  - [Oracle SQL Glossary of Terms](#oracle-sql-glossary-of-terms)
  - [Oracle Database Reference](#oracle-database-reference)
  - [Cases](#cases)
    - [`DROP TABLESPACE`](#drop-tablespace)
  - [sql](#sql)
    - [查询锁表](#查询锁表)
    - [查看当前正在执行的sql](#查看当前正在执行的sql)
    - [计算时间差](#计算时间差)
    - [创建存储过程](#创建存储过程)
    - [session](#session)
      - [The number of sessions the database was configured to allow](#the-number-of-sessions-the-database-was-configured-to-allow)
      - [The number of sessions currently active](#the-number-of-sessions-currently-active)
    - [Merge Into](#merge-into)
      - [oracle中merge into用法解析](#oracle中merge-into用法解析)
      - [Oracle merge into 函数 (增量更新、全量更新)](#oracle-merge-into-函数-增量更新全量更新)

## [Oracle Network Configuration (listener.ora, tnsnames.ora, sqlnet.ora)](https://oracle-base.com/articles/misc/oracle-network-configuration)

### Assumptions

The example files below are relevant for an Oracle installation and instance with the following values.

- HOST : myserver.example.com
- ORACLE_HOME : /u01/app/oracle/product/11.2.0.4/db_1
- ORACLE_SID : orcl
- Service : orcl
- DOMAIN : example.com

### listener.ora

The "listerner.ora" file contains server side network configuration parameters. It can be found in the "$ORACLE_HOME/network/admin" directory on the server. Here is an example of a basic "listener.ora" file from Linux. We can see the listener has the default name of "LISTENER" and is listening for TCP connections on port 1521. Notice the reference to the hostname "myserver.example.com". If this is incorrect, the listener will not function correctly.

    LISTENER =
      (DESCRIPTION_LIST =
        (DESCRIPTION =
          (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1)) 
          (ADDRESS = (PROTOCOL = TCP)(HOST = myserver.example.com)(PORT = 1521))
        )
      )

After the "listener.ora" file is amended the listener should be restarted or reloaded to allow the new configuration to take effect.

Restart:

    lsnrctl stop
    lsnrctl start

Or Reload:

    lsnrctl reload

The listener defined above doesn't have any services defined. These are created when database instances **auto-register** with it. In some cases you may want to manually configure services, so they are still visible even when the database instance is down. If this is the case, you may use a "listener.ora" file like the following.

    LISTENER =
      (DESCRIPTION_LIST =
        (DESCRIPTION =
          (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1)) 
          (ADDRESS = (PROTOCOL = TCP)(HOST = myserver.example.com)(PORT = 1521))
        )
      )

    SID_LIST_LISTENER =
      (SID_LIST =
        (SID_DESC =
          (GLOBAL_DBNAME = orcl.example.com)
          (ORACLE_HOME = /u01/app/oracle/product/11.2.0.4/db_1)
          (SID_NAME = orcl)
        )
      )

If there are multiple database instances on the server, you can added multiple `SID_DESC` entries inside the    `SID_LIST` section.

### tnsnames.ora

The "tnsnames.ora" file contains client side network configuration parameters. It can be found in the "$ORACLE_HOME/network/admin" directory on the client. This file will also be present on the server if client style connections are used on the server itself. Here is an example of a "tnsnames.ora" file.

    LISTENER = (ADDRESS = (PROTOCOL = TCP)(HOST = myserver.example.com)(PORT = 1521))

    orcl.example.com =
      (DESCRIPTION =
        (ADDRESS_LIST =
          (ADDRESS = (PROTOCOL = TCP)(HOST = myserver.example.com)(PORT = 1521))
        )
        (CONNECT_DATA =
          (SERVICE_NAME = orcl)
        )
      )

The alias used at the start of the entry can be whatever you want. It doesn't have to match the name of the instance or service. Notice the `PROTOCOL`, `HOST` and `PORT` match that of the listener. The `SERVICE_NAME` can be any valid service presented by the listener. You can check the available services by issuing the `lsnrctl status` or `lsnrctl service` commands **on the database server**. Typically there is at least one service matching the ORACLE_SID of the instance, but you can create more.

### sqlnet.ora

The "sqlnet.ora" file contains client side network configuration parameters. It can be found in the "$ORACLE_HOME/network/admin" directory on the client. This file will also be present on the server if client style connections are used on the server itself, or if some additional server connection configuration is required. Here is an example of an "sqlnet.ora" file.

    NAMES.DIRECTORY_PATH= (TNSNAMES, ONAMES, HOSTNAME)
    NAMES.DEFAULT_DOMAIN = example.com

    # The following entry is necessary on Windows if OS authentication is required.
    SQLNET.AUTHENTICATION_SERVICES= (NTS)

There are lots of parameters that can be added to control tracing, encryption, wallet locations etc. These are out of the scope of this article.

### Testing

Once the files are present in the correct location and amended as necessary the configuration can be tested using SQL*Plus by attempting to connect to the database using the appropriate username (SCOTT), password (TIGER) and service (orcl.example.com).

    sqlplus scott/tiger@orcl.example.com

## Troubleshooting

### [ORA-28040: No matching authentication protocol](https://logic.edchen.org/how-to-resolve-ora-28040-no-matching-authentication-protocol/)

> - Description
>
>   ORA-28040: No matching authentication protocol
>
> - Cause
>
>   There was no acceptable authentication protocol for either client or server.
>
> - Action
>
>   The administrator should set the values of the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` and `SQLNET.ALLOWED_LOGON_VERSION_CLIENT` parameters, on **both the client and on the server**, to values that match the minimum version software supported in the system. This error `ORA-28040` is also raised when the client is authenticating to a user account which was created without a verifier suitable for the client software version. In this situation, that **account's password must be reset**, in order for the required verifier to be generated and allow authentication to proceed successfully.

### [ORA-01950: no privileges on tablespace 'USERS'](https://stackoverflow.com/questions/21671008/ora-01950-no-privileges-on-tablespace-users)

You cannot insert data because you have a quota of 0 on the tablespace. To fix this, run

    ALTER USER <user> quota unlimited on <tablespace name>;

or

    ALTER USER <user> quota 100M on <tablespace name>;

as a DBA user (depending on how much space you need / want to grant).

## sqlplus

### Run Oracle SQL*PLUS Script from Command Line in Windows

    sqlplus username/psw@orcl @your_script.sql

To run the script with parameters, for example, you want to pass the employee number 7852 and the employee name SCOTT to the SQL script, below is the example:

    sqlplus username/psw@orcl @extract_employees_record.sql 7852 SCOTT

## [Oracle SQL Glossary of Terms](https://www.databasestar.com/oracle-sql-glossary/)

- SID
  
    SID stands for System Identifier, and it uniquely identifies an Oracle database instance on a system.
    It can also identify a unique session in the session database views.

- TNS

    TNS stands for Transparent Network Substrate, and is a technology for connecting to Oracle databases.
    There are many error messages that relate to TNS errors.
    There's also a TNSNAMES.ORA file that contains connection data.

- TNSNAMES.ora

    A file that contains network service names and how they map to connection descriptors or connection strings.

## Oracle Database Reference

- [USER_OBJECTS](https://docs.oracle.com/cd/B19306_01/server.102/b14237/statviews_4378.htm#i1634422)

  USER_OBJECTS describes all objects owned by the current user. Its columns are the same as those in "[ALL_OBJECTS](https://docs.oracle.com/cd/B19306_01/server.102/b14237/statviews_2005.htm#i1583352)".

## Cases

### `DROP TABLESPACE`

    DROP TABLESPACE tablespace_name INCLUDING CONTENTS AND DATAFILES;

- If `.DBF` file was removed before, `DROP TABLESPACE` will fail

      SQL> DROP TABLESPACE TS_WOLF INCLUDING CONTENTS AND DATAFILES;
      DROP TABLESPACE TS_WOLF INCLUDING CONTENTS AND DATAFILES
      *
      ERROR at line 1:
      ORA-01116: error in opening database file 169
      ORA-01110: data file 169: '/opt/oracle/oradata/XE/TS_WOLF.DBF'
      ORA-27041: unable to open file
      Linux-x86_64 Error: 2: No such file or directory
      Additional information: 3

- Solution

      SQL> alter database datafile '/opt/oracle/oradata/XE/TS_WOLF.DBF' offline drop;

      Database altered.

      SQL> DROP TABLESPACE TS_WOLF INCLUDING CONTENTS AND DATAFILES;

      Tablespace dropped.

## sql

- Show INVALIDE Object

      select OBJECT_NAME, OBJECT_TYPE, status from user_objects where status='INVALID';

- Select object of a user

    select object_name, object_type, owner, status from all_objects where owner='user_name';

- Recompile Procedure

      alter procedure MYPROC compile;

- Recomplie View

      ALTER VIEW customer_ro COMPILE;

- [强制终止在执行的sql](https://blog.csdn.net/qq6412110/article/details/91360366)

- [死锁查询及处理](https://blog.csdn.net/rznice/article/details/6683905)

### 查询锁表

    SELECT object_name, machine, s.sid, s.serial#
    FROM gv$locked_object l, dba_objects o, gv$session s
    WHERE l.object_id　= o.object_id
    AND l.session_id = s.sid;

### [查看当前正在执行的sql](https://blog.csdn.net/qq_33301113/article/details/54766751)

    select a.program, b.spid, c.sql_text,c.SQL_ID
    from v$session a, v$process b, v$sqlarea c
    where a.paddr = b.addr
    and a.sql_hash_value = c.hash_value
    and a.username is not null;

### 计算时间差

    select ROUND(TO_NUMBER(to_date(to_char(sysdate,'yyyy-MM-dd hh24:mi:ss'),'yyyy-MM-dd hh24:mi:ss') - to_date('2020-06-29 20:00:00','yyyy-MM-dd hh24:mi:ss'))*24*60*60) from dual

### [创建存储过程](http://www.hechaku.com/Oracle/oracle_pl_others.html)

    CREATE OR REPLACE PROCEDURE SP_TEST_WAIT
    (
      SECONDS IN INT,
      RETURN_CODE OUT INT,
      RETURN_MSG OUT CHAR
    ) IS
      V_ELAPSED NUMBER := 0;
      V_STARTTIME DATE;
      V_CURRENTTIME DATE;

    BEGIN

      SELECT TO_DATE(TO_CHAR(SYSDATE,'yyyy-MM-dd hh24:mi:ss'),'yyyy-MM-dd hh24:mi:ss') into V_STARTTIME FROM DUAL;
  
      WHILE V_ELAPSED < SECONDS LOOP
        SELECT TO_DATE(TO_CHAR(SYSDATE,'yyyy-MM-dd hh24:mi:ss'),'yyyy-MM-dd hh24:mi:ss') into V_CURRENTTIME FROM DUAL;
        V_ELAPSED := ROUND(TO_NUMBER(V_CURRENTTIME - V_STARTTIME)*24*60*60);

      END LOOP;

      RETURN_CODE := 0;
      RETURN_MSG := TO_CHAR(V_STARTTIME, 'yyyy-MM-dd hh24:mi:ss') || ' - ' || TO_CHAR(V_CURRENTTIME, 'yyyy-MM-dd hh24:mi:ss');
    END;

### session

#### The number of sessions the database was configured to allow

    SELECT name, value 
      FROM v$parameter
      WHERE name = 'sessions'

#### The number of sessions currently active

    SELECT COUNT(*)
      FROM v$session

### Merge Into

#### [oracle中merge into用法解析](https://blog.csdn.net/jeryjeryjery/article/details/70047022)

#### [Oracle merge into 函数 (增量更新、全量更新)](https://blog.csdn.net/weixin_41922349/article/details/88052113)
