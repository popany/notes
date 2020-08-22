# Access DataBase

- [Access DataBase](#access-database)
  - [Oracle](#oracle)
  - [Postgres](#postgres)

## Oracle

    import cx_Oracle
    connection = cx_Oracle.connect('test', 'test', 'localhost/XE')

## Postgres

    import psycopg2
    conn = psycopg2.connect(database='postgres', user='postgres', password='123', host='localhost', port='5432')
