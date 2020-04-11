# MySQL

## Docker

### [Docker Image](https://hub.docker.com/_/mysql/)

#### How to use this image

##### Start a `mysql` server instance

Starting a MySQL instance is simple:

    docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag

Where `some-mysql` is the name you want to assign to your container, `my-secret-pw` is the password to be set for the MySQL root user and `tag` is the tag specifying the MySQL version you want. See the list above for relevant tags.

### Practice





