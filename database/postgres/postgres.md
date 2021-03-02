# Postgres

- [Postgres](#postgres)
  - [postgresql.conf](#postgresqlconf)
  - [sql](#sql)
    - [get the current number of connections](#get-the-current-number-of-connections)
    - [`show databases`](#show-databases)
    - [`show tables`](#show-tables)
    - [`describe table_name`](#describe-table_name)
    - [Show current database](#show-current-database)
    - [show current user](#show-current-user)

## postgresql.conf

- `max_connections`

  max number of connections

## sql

### get the current number of connections

    SELECT sum(numbackends) FROM pg_stat_database;

### `show databases`

    select datname from pg_database;

### `show tables`

    SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

### `describe table_name`

    SELECT column_name FROM information_schema.columns WHERE table_name ='table_name';

### Show current database

    select current_database();

### show current user

    select user;

or

    select current_user;
