# sql script

- [sql script](#sql-script)
  - [object](#object)
    - [Show INVALIDE Object](#show-invalide-object)
    - [Select object of a user](#select-object-of-a-user)
  - [Procedure](#procedure)
    - [Recompile Procedure](#recompile-procedure)
    - [创建存储过程](#创建存储过程)
      - [调用上面创建的存储过程](#调用上面创建的存储过程)
  - [View](#view)
    - [Recomplie View](#recomplie-view)
  - [强制终止在执行的sql](#强制终止在执行的sql)
  - [死锁查询及处理](#死锁查询及处理)
    - [查询锁表](#查询锁表)
    - [查看当前正在执行的sql](#查看当前正在执行的sql)
  - [Date/Time](#datetime)
    - [计算时间差](#计算时间差)
  - [Session](#session)
    - [The number of sessions the database was configured to allow](#the-number-of-sessions-the-database-was-configured-to-allow)
    - [The number of sessions currently active](#the-number-of-sessions-currently-active)
  - [Merge Into](#merge-into)
    - [oracle中merge into用法解析](#oracle中merge-into用法解析)
    - [Oracle merge into 函数 (增量更新、全量更新)](#oracle-merge-into-函数-增量更新全量更新)
  - [Privilege](#privilege)
    - [Viewing Privilege and Role Information](#viewing-privilege-and-role-information)
    - [Find out the user and its privileges in Oracle](#find-out-the-user-and-its-privileges-in-oracle)
      - [Check all user having sys privileges](#check-all-user-having-sys-privileges)
      - [Check all system privileges granted related to all users/roles](#check-all-system-privileges-granted-related-to-all-usersroles)
      - [Check object level privileges to User](#check-object-level-privileges-to-user)
      - [Check all the roles granted to users/roles](#check-all-the-roles-granted-to-usersroles)
      - [Check all the column level privileges for user/role](#check-all-the-column-level-privileges-for-userrole)
      - [Find out current user permissions](#find-out-current-user-permissions)
    - [Check user, roles and privileges](#check-user-roles-and-privileges)
      - [Roles granted to user](#roles-granted-to-user)
      - [Privileges granted to user](#privileges-granted-to-user)
      - [Privileges granted to role](#privileges-granted-to-role)
      - [System privileges granted to user](#system-privileges-granted-to-user)
      - [Permissions granted to role](#permissions-granted-to-role)
  - [Tablespaces & Datafiles](#tablespaces--datafiles)
    - [CREATE TABLESPACE statement](#create-tablespace-statement)
    - [DROP TABLESPACE statement](#drop-tablespace-statement)
    - [Viewing Information about Tablespaces and Datafiles](#viewing-information-about-tablespaces-and-datafiles)
      - [View information about Tablespaces](#view-information-about-tablespaces)
      - [View information about Datafiles](#view-information-about-datafiles)
      - [View information about Tempfiles](#view-information-about-tempfiles)
      - [View information about free space in datafiles](#view-information-about-free-space-in-datafiles)
      - [View information about free space in tempfiles](#view-information-about-free-space-in-tempfiles)
  - [Database/Instance Name](#databaseinstance-name)
    - [Instance Name](#instance-name)
    - [Database Name](#database-name)
  - [User](#user)
    - [List Users](#list-users)
    - [Check USER Tablespace quota limit](#check-user-tablespace-quota-limit)
    - [Create user](#create-user)
    - [CREATE USER statement](#create-user-statement)
    - [DROP USER statement](#drop-user-statement)
  - [Roles](#roles)
    - [Create Role](#create-role)
    - [Grant TABLE Privileges to Role](#grant-table-privileges-to-role)
    - [Revoke Table Privileges from Role](#revoke-table-privileges-from-role)
    - [Grant Function/Procedure Privileges to Role](#grant-functionprocedure-privileges-to-role)
    - [Revoke Function/Procedure Privileges from Role](#revoke-functionprocedure-privileges-from-role)
    - [Grant Role to User](#grant-role-to-user)
    - [Revoke Role from User](#revoke-role-from-user)
    - [Enable/Disable Role (Set Role Statement)](#enabledisable-role-set-role-statement)
    - [Set role as DEFAULT Role](#set-role-as-default-role)
    - [Drop Role](#drop-role)
  - [Table](#table)
    - [CREATE TABLE Statement](#create-table-statement)
    - [ALTER TABLE statement](#alter-table-statement)

## object

### Show INVALIDE Object

    select OBJECT_NAME, OBJECT_TYPE, status from user_objects where status='INVALID';

### Select object of a user

    select object_name, object_type, owner, status from all_objects where owner='user_name';

## Procedure

### Recompile Procedure

    alter procedure MYPROC compile;

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

#### 调用上面创建的存储过程

    declare
        v_seconds int:=1;  --入数
        v_return_code int;  --出参1
        v_return_msg varchar(200);  --出参2
    begin
        sp_test_wait(v_seconds, v_return_code, v_return_msg);
        -- 打印输出信息
        dbms_output.put_line(v_return_code);
        dbms_output.put_line(v_return_msg);
        dbms_output.put_line('putline======');
    end;
    /

注意, 使用 sqlplus 时:

- 最后一行的 `/` 时必须的

- 若要查看 dbms_output 打印结果, 需要提前执行 `set serveroutput on`

## View

### Recomplie View

    ALTER VIEW customer_ro COMPILE;

## [强制终止在执行的sql](https://blog.csdn.net/qq6412110/article/details/91360366)

## [死锁查询及处理](https://blog.csdn.net/rznice/article/details/6683905)

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

## Date/Time

### 计算时间差

    select ROUND(TO_NUMBER(to_date(to_char(sysdate,'yyyy-MM-dd hh24:mi:ss'),'yyyy-MM-dd hh24:mi:ss') - to_date('2020-06-29 20:00:00','yyyy-MM-dd hh24:mi:ss'))*24*60*60) from dual

## Session

### The number of sessions the database was configured to allow

    SELECT name, value 
      FROM v$parameter
      WHERE name = 'sessions'

### The number of sessions currently active

    SELECT COUNT(*)
      FROM v$session

## Merge Into

### [oracle中merge into用法解析](https://blog.csdn.net/jeryjeryjery/article/details/70047022)

### [Oracle merge into 函数 (增量更新、全量更新)](https://blog.csdn.net/weixin_41922349/article/details/88052113)

## Privilege

### [Viewing Privilege and Role Information](https://docs.oracle.com/cd/B10501_01/server.920/a96521/privs.htm#15665)

### [Find out the user and its privileges in Oracle](https://smarttechways.com/2017/06/08/find-out-the-user-and-its-privileges-in-oracle/)

#### Check all user having sys privileges

    select * from V$PWFILE_USERS;

#### Check all system privileges granted related to all users/roles

    SELECT * FROM DBA_SYS_PRIVS;

- `GRANTEE` is the name, role, or user that was assigned the privilege.

- `PRIVILEGE` is the privilege that is assigned.

- `ADMIN_OPTION` indicates if the granted privilege also includes the ADMIN option.

#### Check object level privileges to User

    select * from DBA_TAB_PRIVS;

- `GRANTEE` is the name of the user with granted access.

- `TABLE_NAME` is the name of the object (table, index, sequence, etc).

- `PRIVILEGE` is the privilege assigned to the GRANTEE for the associated object.

#### Check all the roles granted to users/roles

    select * from dba_role_privs;

#### Check all the column level privileges for user/role

    SELECT GRANTEE, TABLE_NAME, COLUMN_NAME, PRIVILEGE FROM DBA_COL_PRIVS;

#### Find out current user permissions

    -- your permissions
    select * from USER_ROLE_PRIVS where USERNAME = USER;
    select * from USER_TAB_PRIVS where GRANTEE = USER;
    select * from USER_SYS_PRIVS where USERNAME = USER;

### [Check user, roles and privileges](https://www.support.dbagenesis.com/post/check-users-roles-and-privileges-in-oracle)

#### Roles granted to user

Query to check the granted roles to a user

    SELECT * 
     FROM DBA_ROLE_PRIVS 
     WHERE GRANTEE = '&USER';

#### Privileges granted to user

Query to check privileges granted to a user

    SELECT * 
     FROM DBA_TAB_PRIVS 
     WHERE GRANTEE = 'USER';

#### Privileges granted to role

Privileges granted to a role which is granted to a user

    SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE IN 
    (SELECT granted_role FROM DBA_ROLE_PRIVS WHERE GRANTEE = '&USER') order by 3;

#### System privileges granted to user

Query to check if user is having system privileges

    SELECT * 
     FROM DBA_SYS_PRIVS 
     WHERE GRANTEE = '&USER';

#### Permissions granted to role

Query to check permissions granted to a role

    select * from ROLE_ROLE_PRIVS where ROLE = '&ROLE_NAME';
    select * from ROLE_TAB_PRIVS where ROLE = '&ROLE_NAME';
    select * from ROLE_SYS_PRIVS where ROLE = '&ROLE_NAME';

## Tablespaces & Datafiles

### [CREATE TABLESPACE statement](https://www.techonthenet.com/oracle/tablespaces/create_tablespace.php)

    CREATE TABLESPACE tbs_01
      DATAFILE '/opt/oracle/oradata/<DB_NAME>/tbs_01.dat'
        SIZE 10M
        AUTOEXTEND ON
        NOLOGGING
        EXTENT MANAGEMENT
          LOCAL;

### [DROP TABLESPACE statement](https://www.techonthenet.com/oracle/tablespaces/drop_tablespace.php)

    DROP TABLESPACE tbs_01
      INCLUDING CONTENTS AND DATAFILES
        CASCADE CONSTRAINTS;

### [Viewing Information about Tablespaces and Datafiles](https://oracle-dba-online.com/renaming-or-relocating-datafiles.htm)

#### View information about Tablespaces

    select * from dba_tablespaces;
    select * from v$tablespace;

#### View information about Datafiles

    select * from dba_data_files;
    select * from v$datafile;

#### View information about Tempfiles

    select * from dba_temp_files;
    select * from v$tempfile;

#### View information about free space in datafiles

    select * from dba_free_space;

#### View information about free space in tempfiles

    select * from V$TEMP_SPACE_HEADER;

## Database/Instance Name

### Instance Name

    SELECT sys_context('USERENV','INSTANCE_NAME') AS Instance
    FROM dual;

### Database Name

    SELECT sys_context('USERENV','DB_NAME') AS Database_Name
    FROM dual;

## User

### List Users

    SELECT * FROM ALL_USERS;

    SELECT * FROM DBA_USERS;

### Check USER Tablespace quota limit

    SELECT * FROM DBA_TS_QUOTAS where username = '<USERNAME>';

### [Create user](https://www.oracletutorial.com/oracle-administration/oracle-create-user)

Syntax:

    CREATE USER username
        IDENTIFIED BY password
        [DEFAULT TABLESPACE tablespace]
        [QUOTA {size | UNLIMITED} ON tablespace]
        [PROFILE profile]
        [PASSWORD EXPIRE]
        [ACCOUNT {LOCK | UNLOCK}];

Example:

    CREATE USER john IDENTIFIED BY abcd1234;

### [CREATE USER statement](https://www.techonthenet.com/oracle/users/create_user.php)

Syntax:

    CREATE USER user_name 
      IDENTIFIED { BY password
                 | EXTERNALLY [ AS 'certificate_DN' ]
                 | GLOBALLY [ AS '[ directory_DN ]' ]
                 }
      [ DEFAULT TABLESPACE tablespace
      | TEMPORARY TABLESPACE
           { tablespace | tablespace_group }
      | QUOTA integer [ K | M | G | T | P | E ]
            | UNLIMITED }
            ON tablespace
        [ QUOTA integer [ K | M | G | T | P | E ]
            | UNLIMITED }
                ON tablespace
        ]
      | PROFILE profile_name
      | PASSWORD EXPIRE
      | ACCOUNT { LOCK | UNLOCK }
         [ DEFAULT TABLESPACE tablespace
         | TEMPORARY TABLESPACE
             { tablespace | tablespace_group }
         | QUOTA integer [ K | M | G | T | P | E ]
               | UNLIMITED }
               ON tablespace
           [ QUOTA integer [ K | M | G | T | P | E ]
               | UNLIMITED }
               ON tablespace
            ]
         | PROFILE profile
         | PASSWORD EXPIRE
         | ACCOUNT { LOCK | UNLOCK } ]
         ] ;

Example:

    CREATE USER smithj
      IDENTIFIED BY pwd4smithj
      DEFAULT TABLESPACE tbs_perm_01
      TEMPORARY TABLESPACE tbs_temp_01
      QUOTA 20M on tbs_perm_01;

### [DROP USER statement](https://www.techonthenet.com/oracle/users/drop_user.php)

Syntax:

    DROP USER user_name [ CASCADE ];

Example:

    DROP USER smithj;

    DROP USER smithj CASCADE;

## [Roles](https://www.techonthenet.com/oracle/roles.php)

### Create Role

Syntax:

    CREATE ROLE role_name
    [ NOT IDENTIFIED | 
    IDENTIFIED {BY password | USING [schema.] package | EXTERNALLY | GLOBALLY } ;

Example:

    CREATE ROLE test_role;

    CREATE ROLE test_role
    IDENTIFIED BY test123;

### Grant TABLE Privileges to Role

Syntax:

    GRANT privileges ON object TO role_name

Example:

    GRANT select, insert, update, delete ON suppliers TO test_role;

    GRANT all ON suppliers TO test_role;

### Revoke Table Privileges from Role

Syntax:

    REVOKE privileges ON object FROM role_name;

Example:

    REVOKE delete ON suppliers FROM test_role;

    REVOKE all ON suppliers FROM test_role;

### Grant Function/Procedure Privileges to Role

Syntax:

    GRANT EXECUTE ON object TO role_name;

Example:

    GRANT execute ON Find_Value TO test_role;

### Revoke Function/Procedure Privileges from Role

Syntax:

    REVOKE execute ON object FROM role_name;

Example:

    REVOKE execute ON Find_Value FROM test_role;

### Grant Role to User

Syntax:

    GRANT role_name TO user_name;

Example:

    GRANT test_role TO smithj;

### Revoke Role from User

    Revoke test_role from smithj;

### Enable/Disable Role (Set Role Statement)

Syntax:

    SET ROLE ( role_name [ IDENTIFIED BY password ] | ALL [EXCEPT role1, role2, ... ] | NONE );

Example:

    SET ROLE test_role IDENTIFIED BY test123;

### Set role as DEFAULT Role

Syntax:

    ALTER USER user_name
    DEFAULT ROLE
    ( role_name | ALL [EXCEPT role1, role2, ... ] | NONE );

Example:

    ALTER USER smithj
    DEFAULT ROLE
    test_role;

    ALTER USER smithj
    DEFAULT ROLE
    ALL;

    ALTER USER smithj
    DEFAULT ROLE
    ALL EXCEPT test_role;

### Drop Role

Syntax:

    DROP ROLE role_name;

Example:

    DROP ROLE test_role;

## Table

### [CREATE TABLE Statement](https://www.techonthenet.com/oracle/tables/create_table.php)

### [ALTER TABLE statement](https://www.techonthenet.com/oracle/tables/alter_table.php)
