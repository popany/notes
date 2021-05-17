# Run MySQL in Docker

- [Run MySQL in Docker](#run-mysql-in-docker)
  - [Docker](#docker)
    - [Docker Image](#docker-image)
      - [How to use this image](#how-to-use-this-image)
        - [Start a `mysql` server instance](#start-a-mysql-server-instance)
        - [Connect to MySQL from the MySQL command line client](#connect-to-mysql-from-the-mysql-command-line-client)
        - [Using a custom MySQL configuration file](#using-a-custom-mysql-configuration-file)
          - [Configuration without a `cnf` file](#configuration-without-a-cnf-file)
        - [Environment Variables](#environment-variables)
        - [Docker Secrets](#docker-secrets)
      - [Initializing a fresh instance](#initializing-a-fresh-instance)
      - [Caveats](#caveats)
        - [Where to Store Data](#where-to-store-data)
        - [No connections until MySQL init completes](#no-connections-until-mysql-init-completes)
        - [Usage against an existing database](#usage-against-an-existing-database)
        - [Running as an arbitrary user](#running-as-an-arbitrary-user)
        - [Creating database dumps](#creating-database-dumps)
        - [Restoring data from dump files](#restoring-data-from-dump-files)
    - [Practice](#practice)
      - [Run container](#run-container)
      - [Connect to MySQL](#connect-to-mysql)
      - [use docker-compose](#use-docker-compose)
        - [create docker-compose.yml](#create-docker-composeyml)
        - [run it](#run-it)
        - [connect to server](#connect-to-server)
        - [stop server](#stop-server)

## Docker

### [Docker Image](https://hub.docker.com/_/mysql/)

#### How to use this image

##### Start a `mysql` server instance

Starting a MySQL instance is simple:

    docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag

where `some-mysql` is the name you want to assign to your container, `my-secret-pw` is the password to be set for the MySQL root user and `tag` is the tag specifying the MySQL version you want. See the list above for relevant tags.

##### Connect to MySQL from the MySQL command line client

The following command starts another mysql container instance and runs the mysql command line client against your original mysql container, allowing you to execute SQL statements against your database instance:

    docker run -it --network some-network --rm mysql mysql -hsome-mysql -uexample-user -p

where `some-mysql` is the name of your original mysql container (connected to the `some-network` Docker network).

This image can also be used as a client for non-Docker or remote instances:

    docker run -it --rm mysql mysql -hsome.mysql.host -usome-mysql-user -p

More information about the MySQL command line client can be found in the [MySQL documentation](http://dev.mysql.com/doc/en/mysql.html)

##### Using a custom MySQL configuration file

The default configuration for MySQL can be found in `/etc/mysql/my.cnf`, which may `!includedir` additional directories such as `/etc/mysql/conf.d` or `/etc/mysql/mysql.conf.d`. Please inspect the relevant files and directories within the mysql image itself for more details.

If `/my/custom/config-file.cnf` is the path and name of your custom configuration file, you can start your mysql container like this (note that only the directory path of the custom config file is used in this command):

    docker run --name some-mysql -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag

This will start a new container `some-mysql` where the MySQL instance uses the combined startup settings from `/etc/mysql/my.cnf` and `/etc/mysql/conf.d/config-file.cnf`, with settings from the latter taking precedence.

###### Configuration without a `cnf` file

Many configuration options can be passed as flags to    `mysqld`. This will give you the flexibility to customize the container without needing a `cnf` file. For example, if you want to change the default encoding and collation for all tables to use `UTF-8` (`utf8mb4`) just run the following:

    docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

If you would like to see a complete list of available options, just run:

    docker run -it --rm mysql:tag --verbose --help

##### Environment Variables

When you start the `mysql` image, you can adjust the configuration of the MySQL instance by passing one or more environment variables on the `docker run` command line. Do note that none of the variables below will have any effect if you start the container with a data directory that already contains a database: **any pre-existing database will always be left untouched on container startup**.

##### Docker Secrets

As an alternative to passing sensitive information via environment variables, `_FILE` may be appended to the previously listed environment variables, causing the initialization script to load the values for those variables from files present in the container. In particular, this can be used to load passwords from Docker secrets stored in `/run/secrets/<secret_name>` files. For example:

    docker run --name some-mysql -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql-root -d mysql:tag

Currently, this is only supported for `MYSQL_ROOT_PASSWORD`, `MYSQL_ROOT_HOST`, `MYSQL_DATABASE`, `MYSQL_USER`, and `MYSQL_PASSWORD`.

#### Initializing a fresh instance

When a container is started for the first time, a new database with the specified name will be created and initialized with the provided configuration variables. Furthermore, it will execute files with extensions `.sh`, `.sql` and `.sql.gz` that are found in `/docker-entrypoint-initdb.d`. Files will be executed in alphabetical order. You can easily populate your mysql services by [mounting a SQL dump into that directory](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-file-as-a-data-volume) and provide [custom images](https://docs.docker.com/reference/builder/) with contributed data. SQL files will be imported by default to the database specified by the `MYSQL_DATABASE` variable.

#### Caveats

##### Where to Store Data

Important note: There are several ways to store data used by applications that run in Docker containers. We encourage users of the mysql images to familiarize themselves with the options available, including:

- Let Docker manage the storage of your database data [by writing the database files to disk on the host system using its own internal volume management](https://docs.docker.com/engine/tutorials/dockervolumes/#adding-a-data-volume). This is the default and is easy and fairly transparent to the user. The downside is that the files may be hard to locate for tools and applications that run directly on the host system, i.e. outside containers.

- Create a data directory on the host system (outside the container) and [mount this to a directory visible from inside the container](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume). This places the database files in a known location on the host system, and makes it easy for tools and applications on the host system to access the files. The downside is that the user needs to make sure that the directory exists, and that e.g. directory permissions and other security mechanisms on the host system are set up correctly.

The Docker documentation is a good starting point for understanding the different storage options and variations, and there are multiple blogs and forum postings that discuss and give advice in this area. We will simply show the basic procedure here for the latter option above:

1. Create a data directory on a suitable volume on your host system, e.g. `/my/own/datadir`.

2. Start your mysql container like this:

    docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag

The `-v /my/own/datadir:/var/lib/mysql` part of the command mounts the `/my/own/datadir` directory from the underlying host system as `/var/lib/mysql` inside the container, where MySQL by default will write its data files.

##### No connections until MySQL init completes

If there is no database initialized when the container starts, then a default database will be created. While this is the expected behavior, this means that it will not accept incoming connections until such initialization completes. This may cause issues when using automation tools, such as docker-compose, which start several containers simultaneously.

If the application you're trying to connect to MySQL does not handle MySQL downtime or waiting for MySQL to start gracefully, then putting a connect-retry loop before the service starts might be necessary. For an example of such an implementation in the official images, see WordPress or Bonita.

##### Usage against an existing database

If you start your mysql container instance with a data directory that already contains a database (specifically, a mysql subdirectory), the `$MYSQL_ROOT_PASSWORD` variable should be omitted from the run command line; it will in any case be ignored, and the pre-existing database will not be changed in any way.

##### Running as an arbitrary user

If you know the permissions of your directory are already set appropriately (such as running against an existing database, as described above) or you have need of running `mysqld` with a specific UID/GID, it is possible to invoke this image with `--user` set to any value (other than `root/0`) in order to achieve the desired access/configuration:

    mkdir data
    docker run -v "$PWD/data":/var/lib/mysql --user 1000:1000 --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag

##### Creating database dumps

Most of the normal tools will work, although their usage might be a little convoluted in some cases to ensure they have access to the `mysqld` server. A simple way to ensure this is to use `docker exec` and run the tool from the same container, similar to the following:

    docker exec some-mysql sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql

##### Restoring data from dump files

For restoring data. You can use `docker exec` command with `-i` flag, similar to the following:

    docker exec -i some-mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' < /some/path/on/your/host/all-databases.sql

### Practice

#### Run container

    docker run --name mysql -d -v vol_mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=abc -p 3306:3306 mysql

#### Connect to MySQL

    docker run -ti --network bridge --rm mysql mysql -h172.17.0.2 -uroot -pabc

#### use docker-compose

##### create docker-compose.yml

    version: "3"
    services:
      mysql_db:
        restart: always
        image: mysql:latest
        container_name: mysql
        hostname: mysql
        volumes:
          - "./mysql/db-data:/var/lib/mysql"
        ports:
          - 3306:3306
          - 33060:33060
        environment:
          - TZ=Asia/Shanghai
          - MYSQL_ROOT_PASSWORD=abc
        command: [ "--character-set-server=utf8", "--collation-server=utf8_unicode_ci" ]

##### run it

    cd PATH_TO_DOCKER-COMPOSE.YML
    docker-compose up -d

##### connect to server

    mysql -h 127.0.0.1 -u root -P 3306 -p rootpw

##### stop server

    docker-compose stop
