# Mysql Command

- [Mysql Command](#mysql-command)
  - [Mysql 8.0](#mysql-80)
    - [Show isolation level for the transactions](#show-isolation-level-for-the-transactions)
    - [Set isolation level](#set-isolation-level)
    - [Show sessions](#show-sessions)

## Mysql 8.0

### Show isolation level for the transactions

- session

      SELECT @@transaction_isolation;

- global

      SELECT @@global.transaction_isolation;

### Set isolation level

    REPEATABLE READ
    READ COMMITTED
    READ UNCOMMITTED
    SERIALIZABLE

- session

      SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

- global

      SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

### Show sessions

    show processlist;
