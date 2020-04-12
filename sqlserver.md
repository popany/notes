# sqlserver

- [sqlserver](#sqlserver)
  - [WITH (NOLOCK)](#with-nolock)
    - [Using WITH (NOLOCK)](#using-with-nolock)
    - [Use of NoLock in Select Distinct yield duplicate](#use-of-nolock-in-select-distinct-yield-duplicate)
    - [How NOLOCK Will Block Your Queries](#how-nolock-will-block-your-queries)
    - [Can NOLOCK cause DISTINCT to fail?](#can-nolock-cause-distinct-to-fail)
    - [The Effect of NOLOCK on Performance](#the-effect-of-nolock-on-performance)
    - [SQL Server table hints – WITH (NOLOCK) best practices](#sql-server-table-hints-%c3%a2%e2%82%ac-with-nolock-best-practices)
    - [Understanding the SQL Server NOLOCK hint](#understanding-the-sql-server-nolock-hint)
  - [Docker](#docker)
    - [Quickstart: Run SQL Server container images with Docker](#quickstart-run-sql-server-container-images-with-docker)
      - [Pull and run the container image](#pull-and-run-the-container-image)
    - [Docker Hub](#docker-hub)

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

## Docker

### [Quickstart: Run SQL Server container images with Docker](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-bash)

In this quickstart, you use Docker to pull and run the SQL Server 2019 container image, [mssql-server](https://hub.docker.com/r/microsoft/mssql-server). Then connect with `sqlcmd` to create your first database and run queries.

This image consists of SQL Server running on Linux based on Ubuntu 18.04. It can be used with the Docker Engine 1.8+ on Linux or on Docker for Mac/Windows. This quickstart specifically focuses on using the SQL Server on linux image. The Windows image is not covered, but you can learn more about it on the [mssql-server-windows-developer Docker Hub page](https://hub.docker.com/r/microsoft/mssql-server-windows-developer/).

#### Pull and run the container image

1. Pull the SQL Server 2019 Linux container image from Docker Hub.

      docker pull mcr.microsoft.com/mssql/server:2019-CU3-ubuntu-18.04














### [Docker Hub](https://hub.docker.com/_/microsoft-mssql-server?tab=description)










