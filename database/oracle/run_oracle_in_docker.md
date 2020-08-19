# Run Oracle in Docker

- [Run Oracle in Docker](#run-oracle-in-docker)
  - [Oracle Database XE](#oracle-database-xe)
    - [Oracle Database XE Quick Start](#oracle-database-xe-quick-start)
    - [Oracle Database on Docker](#oracle-database-on-docker)
      - [Building Oracle Database Docker Install Images](#building-oracle-database-docker-install-images)
      - [Running Oracle Database in a Docker container](#running-oracle-database-in-a-docker-container)
        - [Running Oracle Database 18c Express Edition in a Docker container](#running-oracle-database-18c-express-edition-in-a-docker-container)
    - [Practice](#practice)
      - [Build and Run Oracle Database Container in Docker Desktop](#build-and-run-oracle-database-container-in-docker-desktop)
      - [Run Oracle Database Container in CentOS](#run-oracle-database-container-in-centos)
        - [Use Oracle11g Client](#use-oracle11g-client)
          - [cmd with docker](#cmd-with-docker)
        - [Create User](#create-user)
        - [Granting all privileges to an existing user](#granting-all-privileges-to-an-existing-user)
        - [Drop User](#drop-user)
        - [Check characterset](#check-characterset)
        - [Change characterset](#change-characterset)

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

### Practice

#### Build and Run Oracle Database Container in Docker Desktop

    git clone git@github.com:oracle/docker-images.git
    
    cd docker-images/OracleDatabase/SingleInstance/dockerfiles/

    ./buildDockerImage.sh -v 18.4.0 -x

    docker run -d --name oracle18xe -p 1521:1521 -p 5500:5500 -e ORACLE_PWD=abc -e ORACLE_CHARACTERSET=AL32UTF8 --mount type=bind,source="/c/docker/oracle/oradata",target=/opt/oracle/oradata oracle/database:18.4.0-xe

    docker logs -f oracle18xe >startup.log 2>&1 &

#### Run Oracle Database Container in CentOS

    docker volume create vol_oracledb

    docker run -d --name oracle18xe -p 1521:1521 -p 5500:5500 -e ORACLE_PWD=abc -e ORACLE_CHARACTERSET=AL32UTF8 -v vol_oracledb:/opt/oracle/oradata oracle/database:18.4.0-xe

    docker logs -f oracle18xe >startup.log 2>&1 &

##### Use Oracle11g Client

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

###### cmd with docker

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

##### Create User

    docker exec oracle18xe bash -c 'sqlplus -s /nolog << EOF 
    connect system/"123"@//localhost:1521/XE
    alter session set "_ORACLE_SCRIPT"=true;
    create user newuser identified by 123;
    grant create session to newuser;
    exit
    EOF'

##### Granting all privileges to an existing user

    docker exec oracle18xe bash -c 'sqlplus -s /nolog << EOF 
    connect system/"123"@//localhost:1521/XE
    alter session set "_ORACLE_SCRIPT"=true;
    grant all privileges to newuser;
    exit
    EOF'

##### Drop User

    docker exec oracle18xe bash -c 'sqlplus -s /nolog << EOF 
    connect system/"123"@//localhost:1521/XE
    alter session set "_ORACLE_SCRIPT"=true;
    drop user newuser;
    exit
    EOF'

##### Check characterset

    select * from nls_database_parameters where parameter='NLS_CHARACTERSET';

##### Change characterset

    bash-4.2# sqlplus sys/abc@XE as sysdba

    SQL*Plus: Release 18.0.0.0.0 - Production on Mon May 18 09:58:26 2020
    Version 18.4.0.0.0

    Copyright (c) 1982, 2018, Oracle.  All rights reserved.


    Connected to:
    Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
    Version 18.4.0.0.0

    SQL> shutdown immediate;
    Database closed.
    Database dismounted.
    ORACLE instance shut down.

    SQL> exit

    bash-4.2# sqlplus /nolog

    SQL*Plus: Release 18.0.0.0.0 - Production on Mon May 18 10:22:13 2020
    Version 18.4.0.0.0

    Copyright (c) 1982, 2018, Oracle.  All rights reserved.

    SQL> connect sys/abc as sysdba
    Connected to an idle instance.
    SQL> startup mount
    ORACLE instance started.

    Total System Global Area 1610612704 bytes
    Fixed Size                  8896480 bytes
    Variable Size             520093696 bytes
    Database Buffers         1073741824 bytes
    Redo Buffers                7880704 bytes
    Database mounted.
    SQL> ALTER SYSTEM ENABLE RESTRICTED SESSION;

    System altered.

    SQL>  ALTER SYSTEM SET JOB_QUEUE_PROCESSES=0;

    System altered.

    SQL> ALTER SYSTEM SET AQ_TM_PROCESSES=0;

    System altered.

    SQL> alter database open;

    Database altered.

    SQL> ALTER DATABASE character set INTERNAL_USE ZHS16GBK;

    Database altered.

    SQL> shutdown immediate;
    Database closed.
    Database dismounted.
    ORACLE instance shut down.

    SQL> startup
    ORACLE instance started.

    Total System Global Area 1610612704 bytes
    Fixed Size                  8896480 bytes
    Variable Size             520093696 bytes
    Database Buffers         1073741824 bytes
    Redo Buffers                7880704 bytes
    Database mounted.
    Database opened.

    SQL>
