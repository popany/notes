# Postgres

- [Postgres](#postgres)
  - [postgresql.conf](#postgresqlconf)
  - [log sql queries](#log-sql-queries)
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

## log sql queries

[How to Log Queries in PostgreSQL](https://chartio.com/resources/tutorials/how-to-log-queries-in-postgresql/)

[How to log PostgreSQL queries?](https://stackoverflow.com/questions/722221/how-to-log-postgresql-queries)

find config file

    postgres=# SHOW config_file;
                config_file
    ------------------------------------------
    /etc/postgresql/9.3/main/postgresql.conf

edit config file

    log_destination = 'csvlog'

    logging_collector = on

    log_directory = 'log'

    log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'

    log_statement = 'all'

Restart the PostgreSQL Service

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
