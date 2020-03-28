# Oracle

## Oracle Database XE

### [Oracle Database XE Quick Start](https://www.oracle.com/database/technologies/appdev/xe/quickstart.html)

### [Oracle Database on Docker](https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance)

#### [Running Oracle Database 18c Express Edition in a Docker container](https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance)

To run your Oracle Database 18c Express Edition Docker image use the docker run command as follows:

    docker run --name <container name> \
        -p <host port>:1521 -p <host port>:5500 \
        -e ORACLE_PWD=<your database passwords> \
        -e ORACLE_CHARACTERSET=<your character set> \
        -v [<host mount point>:]/opt/oracle/oradata \
        oracle/database:18.4.0-xe

    Parameters:
        --name:
            The name of the container (default: auto generated)

        -p:
            The port mapping of the host port to the container port.
            Two ports are exposed: 1521 (Oracle Listener), 8080 (APEX)

        -e ORACLE_PWD:
            The Oracle Database SYS, SYSTEM and PDB_ADMIN password (default: auto generated)

        -e ORACLE_CHARACTERSET:
            The character set to use when creating the database (default: AL32UTF8)

        -v /opt/oracle/oradata
            The data volume to use for the database.
            Has to be writable by the Unix "oracle" (uid: 54321) user inside the container!
            If omitted the database will not be persisted over container recreation.

        -v /opt/oracle/scripts/startup | /docker-entrypoint-initdb.d/startup
            Optional: A volume with custom scripts to be run after database startup.
            For further details see the "Running scripts after setup and on startup" section below.

        -v /opt/oracle/scripts/setup | /docker-entrypoint-initdb.d/setup
            Optional: A volume with custom scripts to be run after database setup.
            For further details see the "Running scripts after setup and on startup" section below.

Once the container has been started and the database created you can connect to it just like to any other database:

    sqlplus sys/<your password>@//localhost:1521/XE as sysdba
    sqlplus system/<your password>@//localhost:1521/XE
    sqlplus pdbadmin/<your password>@//localhost:1521/XEPDB1

The Oracle Database inside the container also has Oracle Enterprise Manager Express configured. To access OEM Express, start your browser and follow the URL:

    https://localhost:5500/em/

On the first startup of the container a random password will be generated for the database if not provided. You can find this password in the output line:

    ORACLE PASSWORD FOR SYS AND SYSTEM:

**Note**: The `ORACLE_SID` for Express Edition is always `XE` and cannot be changed, hence there is no `ORACLE_SID` parameter provided for the `XE` build.

The **password** for those accounts can be changed via the docker exec command. Note, the container has to be running: `docker exec /opt/oracle/setPassword.sh`
