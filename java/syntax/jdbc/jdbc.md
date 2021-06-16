# JDBC

- [JDBC](#jdbc)
  - [Transaction](#transaction)

## Transaction

[How to start a transaction in JDBC?](https://stackoverflow.com/questions/4940648/how-to-start-a-transaction-in-jdbc)

- JDBC connections start out with auto-commit mode enabled, where each SQL statement is implicitly demarcated with a transaction.

- Users who wish to execute multiple statements per transaction must turn [auto-commit off](https://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html#setAutoCommit-boolean-).

- Changing the auto-commit mode triggers a commit of the current transaction (if one is active).

- [Connection.setTransactionIsolation()](http://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html#setTransactionIsolation-int-) may be invoked anytime if auto-commit is enabled.

- If auto-commit is disabled, [Connection.setTransactionIsolation()](http://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html#setTransactionIsolation-int-) may only be invoked before or after a transaction. Invoking it in the middle of a transaction leads to undefined behavior.

Sources:

- [Javadoc](http://download.oracle.com/javase/6/docs/api/java/sql/Connection.html#setTransactionIsolation%28int%29)
- [JDBC Tutorial](http://download.oracle.com/javase/tutorial/jdbc/basics/transactions.html)
