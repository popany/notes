# sqlserver

- [sqlserver](#sqlserver)
  - [WITH (NOLOCK)](#with-nolock)
    - [Using WITH (NOLOCK)](#using-with-nolock)
    - [Use of NoLock in Select Distinct yield duplicate](#use-of-nolock-in-select-distinct-yield-duplicate)
    - [How NOLOCK Will Block Your Queries](#how-nolock-will-block-your-queries)
    - [Can NOLOCK cause DISTINCT to fail?](#can-nolock-cause-distinct-to-fail)
    - [The Effect of NOLOCK on Performance](#the-effect-of-nolock-on-performance)
    - [SQL Server table hints – WITH (NOLOCK) best practices](#sql-server-table-hints-%e2%80%93-with-nolock-best-practices)
    - [Understanding the SQL Server NOLOCK hint](#understanding-the-sql-server-nolock-hint)

## WITH (NOLOCK)

### [Using WITH (NOLOCK)](https://sqlserverplanet.com/tsql/using-with-nolock)

Disadvantages:

- Uncommitted data can be read leading to dirty reads
- Explicit hints against a table are generally bad practice

### [Use of NoLock in Select Distinct yield duplicate](https://www.sqlservercentral.com/forums/topic/use-of-nolock-in-select-distinct-yield-duplicate)

### [How NOLOCK Will Block Your Queries](https://bertwagner.com/2017/10/10/how-nolock-will-block-your-queries/)

### [Can NOLOCK cause DISTINCT to fail?](https://stackoverflow.com/questions/46835425/can-nolock-cause-distinct-to-fail)

### [The Effect of NOLOCK on Performance](https://www.sqlservercentral.com/articles/the-effect-of-nolock-on-performance)

### [SQL Server table hints – WITH (NOLOCK) best practices](https://www.sqlshack.com/understanding-impact-clr-strict-security-configuration-setting-sql-server-2017/)

### [Understanding the SQL Server NOLOCK hint](https://www.mssqltips.com/sqlservertip/2470/understanding-the-sql-server-nolock-hint/)
