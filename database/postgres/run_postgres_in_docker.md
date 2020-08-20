# Run postgres in docker

- [Run postgres in docker](#run-postgres-in-docker)
  - [docker hub](#docker-hub)
    - [How to use this image](#how-to-use-this-image)
      - [start a postgres instance](#start-a-postgres-instance)
    - [How to extend this image](#how-to-extend-this-image)
      - [Environment Variables](#environment-variables)
        - [`POSTGRES_PASSWORD`](#postgres_password)
        - [`POSTGRES_USER`](#postgres_user)
        - [`POSTGRES_DB`](#postgres_db)
      - [Docker Secrets](#docker-secrets)
      - [Initialization scripts](#initialization-scripts)
      - [Database Configuration](#database-configuration)
      - [Locale Customization](#locale-customization)
      - [Additional Extensions](#additional-extensions)
    - [Arbitrary --user Notes](#arbitrary---user-notes)
    - [Caveats](#caveats)
      - [Where to Store Data](#where-to-store-data)
  - [Practice](#practice)

## [docker hub](https://hub.docker.com/_/postgres/)

### How to use this image

#### start a postgres instance

    docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres

### How to extend this image

#### Environment Variables

Warning: the Docker specific variables will only have an effect if you start the container with a data directory that is empty; any pre-existing database will be left untouched on container startup.

##### `POSTGRES_PASSWORD`

This environment variable is required for you to use the PostgreSQL image. It must not be empty or undefined.

##### `POSTGRES_USER`

This optional environment variable is used in conjunction with POSTGRES_PASSWORD to set a user and its password.

If it is not specified, then the default user of `postgres` will be used.

##### `POSTGRES_DB`

This optional environment variable can be used to define a different name for the default database that is created when the image is first started. If it is not specified, then the value of `POSTGRES_USER` will be used.

#### Docker Secrets

#### Initialization scripts

#### Database Configuration

#### Locale Customization

#### Additional Extensions

### Arbitrary --user Notes

### Caveats

If there is no database when `postgres` starts in a container, then `postgres` will create the default database for you. While this is the expected behavior of `postgres`, this means that it will not accept incoming connections during that time. This may cause issues when using automation tools, such as `docker-compose`, that start several containers simultaneously.

#### Where to Store Data

Important note: There are several ways to store data used by applications that run in Docker containers. We encourage users of the postgres images to familiarize themselves with the options available, including:

- Let Docker manage the storage of your database data by writing the database files to disk on the host system using its own internal volume management. This is the default and is easy and fairly transparent to the user. The downside is that the files may be hard to locate for tools and applications that run directly on the host system, i.e. outside containers.

- Create a data directory on the host system (outside the container) and mount this to a directory visible from inside the container. This places the database files in a known location on the host system, and makes it easy for tools and applications on the host system to access the files. The downside is that the user needs to make sure that the directory exists, and that e.g. directory permissions and other security mechanisms on the host system are set up correctly.

## Practice

docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=123 -d postgres
