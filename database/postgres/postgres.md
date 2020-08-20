# Postgres

- [Postgres](#postgres)
  - [postgresql.conf](#postgresqlconf)
  - [sql](#sql)
    - [get the current number of connections](#get-the-current-number-of-connections)

## postgresql.conf

- `max_connections`

  max number of connections

## sql

### get the current number of connections

    SELECT sum(numbackends) FROM pg_stat_database;
