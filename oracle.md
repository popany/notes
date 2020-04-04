# Oracle

- [Oracle](#oracle)
  - [Oracle Database XE](#oracle-database-xe)
    - [Oracle Database XE Quick Start](#oracle-database-xe-quick-start)
    - [Oracle Database on Docker](#oracle-database-on-docker)
      - [Building Oracle Database Docker Install Images](#building-oracle-database-docker-install-images)
      - [Running Oracle Database in a Docker container](#running-oracle-database-in-a-docker-container)
        - [Running Oracle Database 18c Express Edition in a Docker container](#running-oracle-database-18c-express-edition-in-a-docker-container)
    - [Build and Run Oracle Database Container in Docker Desktop](#build-and-run-oracle-database-container-in-docker-desktop)
    - [Run Oracle Database Container in CentOS](#run-oracle-database-container-in-centos)
      - [Use Oracle11g Client](#use-oracle11g-client)
        - [cmd with docker](#cmd-with-docker)
  - [Oracle Network Configuration (listener.ora, tnsnames.ora, sqlnet.ora)](#oracle-network-configuration-listenerora-tnsnamesora-sqlnetora)
    - [Assumptions](#assumptions)
    - [listener.ora](#listenerora)
    - [tnsnames.ora](#tnsnamesora)
    - [sqlnet.ora](#sqlnetora)
    - [Testing](#testing)
  - [Troubleshooting](#troubleshooting)
    - [ORA-28040: No matching authentication protocol](#ora-28040-no-matching-authentication-protocol)
  - [Oracle SQL Glossary of Terms](#oracle-sql-glossary-of-terms)

## Oracle Database XE

### [Oracle Database XE Quick Start](https://www.oracle.com/database/technologies/appdev/xe/quickstart.html)

### [Oracle Database on Docker](https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance)

#### Building Oracle Database Docker Install Images

You will have to provide the installation binaries of Oracle Database (except for Oracle Database 18c XE) and put them into the dockerfiles/\<version\> folder.

Before you build the image make sure that you have provided the installation binaries and put them into the right folder. Once you have chosen which edition and version you want to build an image of, go into the dockerfiles folder and run the buildDockerImage.sh script:

#### Running Oracle Database in a Docker container

##### Running Oracle Database 18c Express Edition in a Docker container

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

### Build and Run Oracle Database Container in Docker Desktop

    git clone git@github.com:oracle/docker-images.git
    
    cd docker-images/OracleDatabase/SingleInstance/dockerfiles/

    ./buildDockerImage.sh -v 18.4.0 -x

    docker run -d --name oracle18xe -p 1521:1521 -p 5500:5500 -e ORACLE_PWD=abc -e ORACLE_CHARACTERSET=AL32UTF8 --mount type=bind,source="/c/docker/oracle/oradata",target=/opt/oracle/oradata oracle/database:18.4.0-xe

    docker logs -f oracle18xe >startup.log 2>&1 &

### Run Oracle Database Container in CentOS

    docker volume create vol_oracledb

    docker run -d --name oracle18xe -p 1521:1521 -p 5500:5500 -e ORACLE_PWD=abc -e ORACLE_CHARACTERSET=AL32UTF8 -v vol_oracledb:/opt/oracle/oradata oracle/database:18.4.0-xe

    docker logs -f oracle18xe >startup.log 2>&1 &

#### Use Oracle11g Client

- Set the values of the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` and `SQLNET.ALLOWED_LOGON_VERSION_CLIENT` parameters int `sqlnet.ora`, on **both the client and on the server**

        SQLNET.ALLOWED_LOGON_VERSION_CLIENT=11
        SQLNET.ALLOWED_LOGON_VERSION_SERVER=11

- Change password

    Login by SQL*Plus on the server side

        sqlplus system/abc@//localhost:1521/XE

        SQL> password
        Changing password for MY_USER
        Old password: ********
        New password: ********
        Retype new password: ********
        Password changed
        SQL>

- Appent to client's `tnsnames.ora` file

        XE =
          (DESCRIPTION =
            (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
            (CONNECT_DATA =
              (SERVER = DEDICATED)
              (SERVICE_NAME = XE)
            )
          )

##### cmd with docker

- Edit sqlnet.ora

      docker exec -ti oracle18xe bash -c 'cat >> $ORACLE_HOME/network/admin/sqlnet.ora << EOF
      SQLNET.ALLOWED_LOGON_VERSION_CLIENT=11
      SQLNET.ALLOWED_LOGON_VERSION_SERVER=11
      EOF'

- Change the password

      docker exec -ti oracle18xe bash -c 'sqlplus -s /nolog << EOF 
      connect system/"abc"@//localhost:1521/XE
      alter user system identified by "123" replace "abc";
      /
      exit
      EOF'

## [Oracle Network Configuration (listener.ora, tnsnames.ora, sqlnet.ora)](https://oracle-base.com/articles/misc/oracle-network-configuration)

### Assumptions

The example files below are relevant for an Oracle installation and instance with the following values.

- HOST : myserver.example.com
- ORACLE_HOME : /u01/app/oracle/product/11.2.0.4/db_1
- ORACLE_SID : orcl
- Service : orcl
- DOMAIN : example.com

### listener.ora

The "listerner.ora" file contains server side network configuration parameters. It can be found in the "$ORACLE_HOME/network/admin" directory on the server. Here is an example of a basic "listener.ora" file from Linux. We can see the listener has the default name of "LISTENER" and is listening for TCP connections on port 1521. Notice the reference to the hostname "myserver.example.com". If this is incorrect, the listener will not function correctly.

    LISTENER =
      (DESCRIPTION_LIST =
        (DESCRIPTION =
          (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1)) 
          (ADDRESS = (PROTOCOL = TCP)(HOST = myserver.example.com)(PORT = 1521))
        )
      )

After the "listener.ora" file is amended the listener should be restarted or reloaded to allow the new configuration to take effect.

Restart:

    lsnrctl stop
    lsnrctl start

Or Reload:

    lsnrctl reload

The listener defined above doesn't have any services defined. These are created when database instances **auto-register** with it. In some cases you may want to manually configure services, so they are still visible even when the database instance is down. If this is the case, you may use a "listener.ora" file like the following.

    LISTENER =
      (DESCRIPTION_LIST =
        (DESCRIPTION =
          (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1)) 
          (ADDRESS = (PROTOCOL = TCP)(HOST = myserver.example.com)(PORT = 1521))
        )
      )

    SID_LIST_LISTENER =
      (SID_LIST =
        (SID_DESC =
          (GLOBAL_DBNAME = orcl.example.com)
          (ORACLE_HOME = /u01/app/oracle/product/11.2.0.4/db_1)
          (SID_NAME = orcl)
        )
      )

If there are multiple database instances on the server, you can added multiple `SID_DESC` entries inside the    `SID_LIST` section.

### tnsnames.ora

The "tnsnames.ora" file contains client side network configuration parameters. It can be found in the "$ORACLE_HOME/network/admin" directory on the client. This file will also be present on the server if client style connections are used on the server itself. Here is an example of a "tnsnames.ora" file.

    LISTENER = (ADDRESS = (PROTOCOL = TCP)(HOST = myserver.example.com)(PORT = 1521))

    orcl.example.com =
      (DESCRIPTION =
        (ADDRESS_LIST =
          (ADDRESS = (PROTOCOL = TCP)(HOST = myserver.example.com)(PORT = 1521))
        )
        (CONNECT_DATA =
          (SERVICE_NAME = orcl)
        )
      )

The alias used at the start of the entry can be whatever you want. It doesn't have to match the name of the instance or service. Notice the `PROTOCOL`, `HOST` and `PORT` match that of the listener. The `SERVICE_NAME` can be any valid service presented by the listener. You can check the available services by issuing the `lsnrctl status` or `lsnrctl service` commands **on the database server**. Typically there is at least one service matching the ORACLE_SID of the instance, but you can create more.

### sqlnet.ora

The "sqlnet.ora" file contains client side network configuration parameters. It can be found in the "$ORACLE_HOME/network/admin" directory on the client. This file will also be present on the server if client style connections are used on the server itself, or if some additional server connection configuration is required. Here is an example of an "sqlnet.ora" file.

    NAMES.DIRECTORY_PATH= (TNSNAMES, ONAMES, HOSTNAME)
    NAMES.DEFAULT_DOMAIN = example.com

    # The following entry is necessary on Windows if OS authentication is required.
    SQLNET.AUTHENTICATION_SERVICES= (NTS)

There are lots of parameters that can be added to control tracing, encryption, wallet locations etc. These are out of the scope of this article.

### Testing

Once the files are present in the correct location and amended as necessary the configuration can be tested using SQL*Plus by attempting to connect to the database using the appropriate username (SCOTT), password (TIGER) and service (orcl.example.com).

    sqlplus scott/tiger@orcl.example.com

## Troubleshooting

### [ORA-28040: No matching authentication protocol](https://logic.edchen.org/how-to-resolve-ora-28040-no-matching-authentication-protocol/)

> - Description
>
>   ORA-28040: No matching authentication protocol
>
> - Cause
>
>   There was no acceptable authentication protocol for either client or server.
>
> - Action
>
>   The administrator should set the values of the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` and `SQLNET.ALLOWED_LOGON_VERSION_CLIENT` parameters, on **both the client and on the server**, to values that match the minimum version software supported in the system. This error `ORA-28040` is also raised when the client is authenticating to a user account which was created without a verifier suitable for the client software version. In this situation, that **account's password must be reset**, in order for the required verifier to be generated and allow authentication to proceed successfully.

## [Oracle SQL Glossary of Terms](https://www.databasestar.com/oracle-sql-glossary/)

- SID
  
    SID stands for System Identifier, and it uniquely identifies an Oracle database instance on a system.
    It can also identify a unique session in the session database views.

- TNS

    TNS stands for Transparent Network Substrate, and is a technology for connecting to Oracle databases.
    There are many error messages that relate to TNS errors.
    There’s also a TNSNAMES.ORA file that contains connection data.

- TNSNAMES.ora

    A file that contains network service names and how they map to connection descriptors or connection strings.