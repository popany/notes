# sqlplus

- [sqlplus](#sqlplus)
  - [Use](#use)
    - [Run Oracle SQL*PLUS Script from Command Line in Windows](#run-oracle-sqlplus-script-from-command-line-in-windows)
    - [SQLPlus: ORA-01756: quoted string not properly terminated](#sqlplus-ora-01756-quoted-string-not-properly-terminated)
  - [cmd](#cmd)
    - [login](#login)
    - [Get current logged-in user](#get-current-logged-in-user)

## Use

### Run Oracle SQL*PLUS Script from Command Line in Windows

    sqlplus username/psw@orcl @your_script.sql

To run the script with parameters, for example, you want to pass the employee number 7852 and the employee name SCOTT to the SQL script, below is the example:

    sqlplus username/psw@orcl @extract_employees_record.sql 7852 SCOTT

### [SQLPlus: ORA-01756: quoted string not properly terminated](https://stackoverflow.com/questions/42065449/sqlplus-ora-01756-quoted-string-not-properly-terminated)

## cmd

### login

    sqlplus -s /nolog

    connect system/<password>@//localhost:1521/<oracle sid>

or

    connect system/<password>@//localhost:1521/<oracle sid> as sysdba

### Get current logged-in user

    select user from dual;
