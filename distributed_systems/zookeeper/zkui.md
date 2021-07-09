# zkui

- [zkui](#zkui)
  - [github](#github)
  - [Build zkui:2.0 image](#build-zkui20-image)
  - [Run Docker Container](#run-docker-container)
  - [User/Passwd](#userpasswd)

## [github](https://github.com/DeemOpen/zkui)

## Build zkui:2.0 image

copy jar and config into docker directory

    docker build -t zkui:2.0 .

## Run Docker Container

    docker run -tid --name zk -P zookeeper:3.7.0
    docker run -tid --name zkui -P -e ZK_SERVER=zk:2181 zkui:2.0

    docker network create zk-net
    docker network connect zk-net zk
    docker network connect zk-net zkui

## User/Passwd

    admin/manager
