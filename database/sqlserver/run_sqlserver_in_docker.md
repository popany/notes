# Docker

- [Docker](#docker)
  - [Quickstart: Run SQL Server container images with Docker](#quickstart-run-sql-server-container-images-with-docker)
    - [Pull and run the container image](#pull-and-run-the-container-image)
    - [Change the SA password](#change-the-sa-password)
    - [Connect to SQL Server](#connect-to-sql-server)
    - [Create and query data](#create-and-query-data)
      - [Create a new database](#create-a-new-database)
      - [Insert data](#insert-data)
      - [Select data](#select-data)
      - [Exit the sqlcmd command prompt](#exit-the-sqlcmd-command-prompt)
    - [Connect from outside the container](#connect-from-outside-the-container)
      - [Use Visual Studio Code to create and run Transact-SQL scripts](#use-visual-studio-code-to-create-and-run-transact-sql-scripts)
  - [Docker Hub](#docker-hub)
  - [mssql-docker GitHub repository](#mssql-docker-github-repository)
  - [Practice](#practice)
    - [run docker container](#run-docker-container)

## [Quickstart: Run SQL Server container images with Docker](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-bash)

In this quickstart, you use Docker to pull and run the SQL Server 2019 container image, [mssql-server](https://hub.docker.com/r/microsoft/mssql-server). Then connect with `sqlcmd` to create your first database and run queries.

This image consists of SQL Server running on Linux based on Ubuntu 18.04. It can be used with the Docker Engine 1.8+ on Linux or on Docker for Mac/Windows. This quickstart specifically focuses on using the SQL Server on linux image. The Windows image is not covered, but you can learn more about it on the [mssql-server-windows-developer Docker Hub page](https://hub.docker.com/r/microsoft/mssql-server-windows-developer/).

### Pull and run the container image

1. Pull the SQL Server 2019 Linux container image from Docker Hub.

       docker pull mcr.microsoft.com/mssql/server:2019-CU3-ubuntu-18.04

2. To run the container image with Docker

       docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<YourStrong@Passw0rd>" \
       -p 1433:1433 --name sql1 \
       -d mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04

### Change the SA password

The SA account is a system administrator on the SQL Server instance that gets created during setup. After creating your SQL Server container, the `SA_PASSWORD` environment variable you specified is discoverable by running `echo $SA_PASSWORD` in the container. For security purposes, change your SA password

1. Choose a strong password to use for the SA user

2. Use docker exec to run sqlcmd to change the password using Transact-SQL. In the following example, replace the old password, <YourStrong!Passw0rd>, and the new password, <YourNewStrong!Passw0rd>, with your own password values.

       docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd \
       -S localhost -U SA -P "<YourStrong@Passw0rd>" \
       -Q 'ALTER LOGIN SA WITH PASSWORD="<YourNewStrong@Passw0rd>"'

### Connect to SQL Server

Use the SQL Server command-line tool, sqlcmd, inside the container to connect to SQL Server

1. Use the docker exec -it command to start an interactive bash shell inside your running container. In the following example sql1 is name specified by the --name parameter when you created the container

       docker exec -it sql1 "bash"

2. Once inside the container, connect locally with sqlcmd. Sqlcmd is not in the path by default, so you have to specify the full path

       /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "<YourNewStrong@Passw0rd>"

3. If successful, you should get to a sqlcmd command prompt: 1>.

### Create and query data

The following sections walk you through using sqlcmd and Transact-SQL to create a new database, add data, and run a simple query

#### Create a new database

Create a new database named TestDB

1. From the sqlcmd command prompt, paste the following Transact-SQL command to create a test database

       CREATE DATABASE TestDB

2. On the next line, write a query to return the name of all of the databases on your server

       SELECT Name from sys.Databases

3. The previous two commands were not executed immediately. You must type GO on a new line to execute the previous commands

       GO

#### Insert data

Create a new table, Inventory, and insert two new rows

1. From the sqlcmd command prompt, switch context to the new TestDB database

       USE TestDB

2. Create new table named Inventory

       CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT)

3. Insert data into the new table

       INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);

4. Type GO to execute the previous commands

       GO

#### Select data

Run a query to return data from the Inventory table

1. From the sqlcmd command prompt, enter a query that returns rows from the Inventory table where the quantity is greater than 152

       SELECT * FROM Inventory WHERE quantity > 152;

2. Execute the command
       GO

#### Exit the sqlcmd command prompt

1. To end your sqlcmd session, type QUIT

       QUIT

2. To exit the interactive command-prompt in your container, type exit. Your container continues to run after you exit the interactive bash shell

### Connect from outside the container

1. Find the IP address for the machine that hosts your container. On Linux, use ifconfig or ip addr. On Windows, use ipconfig

2. For this example, install the sqlcmd tool on your client machine. For more information, see [Install sqlcmd on Windows](https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver15) or [Install sqlcmd on Linux](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver15)

3. Run sqlcmd specifying the IP address and the port mapped to port 1433 in your container. In this example, that is the same port, 1433, on the host machine. If you specified a different mapped port on the host machine, you would use it here

       sqlcmd -S <ip_address>,1433 -U SA -P "<YourNewStrong@Passw0rd>"

4. Run Transact-SQL commands. When finished, type QUIT

#### [Use Visual Studio Code to create and run Transact-SQL scripts](https://docs.microsoft.com/en-us/sql/tools/visual-studio-code/sql-server-develop-use-vscode?view=sql-server-ver15)

## [Docker Hub](https://hub.docker.com/_/microsoft-mssql-server?tab=description)

## [mssql-docker GitHub repository](https://github.com/Microsoft/mssql-docker)

## Practice

### run docker container

    docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Abcd_1234" \
    -p 1433:1433 --name sqlserver \
    -d mcr.microsoft.com/mssql/server:2019-CU3-ubuntu-18.04
