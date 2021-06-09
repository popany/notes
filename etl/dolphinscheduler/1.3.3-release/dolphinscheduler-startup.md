# Dolphinscheduler Startup

- [Dolphinscheduler Startup](#dolphinscheduler-startup)
  - [参考 `./docker/build/Dockerfile`](#参考-dockerbuilddockerfile)
    - [启动脚本 `./docker/build/startup.sh`](#启动脚本-dockerbuildstartupsh)
      - [初始化配置 `./docker/build/startup-init-conf.sh`](#初始化配置-dockerbuildstartup-init-confsh)
  - [拉起容器](#拉起容器)
    - [参考 `./docker/build/README.md`](#参考-dockerbuildreadmemd)
    - [案例 1](#案例-1)
    - [案例 2](#案例-2)
  - [初始用户名/密码](#初始用户名密码)

## 参考 `./docker/build/Dockerfile`

### 启动脚本 `./docker/build/startup.sh`

#### 初始化配置 `./docker/build/startup-init-conf.sh`

- 配置环境变量

  - Database Source

  - System

    - `./docker/build/conf/dolphinscheduler/env/dolphinscheduler_env.sh`

  - Zookeeper

  - Master Server

  - Worker Server

  - Alert Server

  - Frontend

- generate app config

  - `./docker/build/conf/dolphinscheduler/alert.properties.tpl`
  - `docker/build/conf/dolphinscheduler/application-api.properties.tpl`
  - `docker/build/conf/dolphinscheduler/common.properties.tpl`
  - `docker/build/conf/dolphinscheduler/datasource.properties.tpl`
  - `docker/build/conf/dolphinscheduler/master.properties.tpl`
  - `docker/build/conf/dolphinscheduler/quartz.properties.tpl`
  - `docker/build/conf/dolphinscheduler/worker.properties.tpl`
  - `docker/build/conf/dolphinscheduler/zookeeper.properties.tpl`

- generate nginx config

  - `docker/build/conf/nginx/dolphinscheduler.conf`

## 拉起容器

### 参考 `./docker/build/README.md`

    docker run -dit --name dolphinscheduler -p 8888:8888 apache/dolphinscheduler:1.3.4-SNAPSHOT all

默认环境变量参见 `./docker/build/startup-init-conf.sh`

### 案例 1

    docker network create dolphinscheduler-net

    docker run -d --name zk1 --network dolphinscheduler-net zookeeper

    docker run -d --name postgres --network dolphinscheduler-net -p 5432:5432 -e POSTGRES_USER=dolphinscheduler -e POSTGRES_PASSWORD=123 postgres

    docker run -d --name dolphinscheduler \
    --network dolphinscheduler-net \
    -e ZOOKEEPER_QUORUM="zk1:2181" \
    -e POSTGRESQL_HOST="postgres" -e POSTGRESQL_PORT="5432" -e POSTGRESQL_USERNAME="dolphinscheduler" -e POSTGRESQL_PASSWORD="123" -e POSTGRESQL_DATABASE="dolphinscheduler" \
    -e DOLPHINSCHEDULER_RESOURCE_STORAGE_TYPE="NONE" \
    -p 8888:8888 \
    apache/dolphinscheduler:1.3.4-SNAPSHOT all

### 案例 2

    docker network create dolphinscheduler-net

    docker run -d --name zk1 --network dolphinscheduler-net zookeeper

    docker run -d --name postgres --network dolphinscheduler-net -p 5432:5432 -e POSTGRES_USER=dolphinscheduler -e POSTGRES_PASSWORD=123 postgres

    docker run -d --name dolphinscheduler-master-1 \
    --network dolphinscheduler-net \
    -e ZOOKEEPER_QUORUM="zk1:2181" \
    -e POSTGRESQL_HOST="postgres" -e POSTGRESQL_PORT="5432" -e POSTGRESQL_USERNAME="dolphinscheduler" -e POSTGRESQL_PASSWORD="123" -e POSTGRESQL_DATABASE="dolphinscheduler" \
    apache/dolphinscheduler:1.3.4-SNAPSHOT master-server

    docker run -d --name dolphinscheduler-master-2 \
    --network dolphinscheduler-net \
    -e ZOOKEEPER_QUORUM="zk1:2181" \
    -e POSTGRESQL_HOST="postgres" -e POSTGRESQL_PORT="5432" -e POSTGRESQL_USERNAME="dolphinscheduler" -e POSTGRESQL_PASSWORD="123" -e POSTGRESQL_DATABASE="dolphinscheduler" \
    apache/dolphinscheduler:1.3.4-SNAPSHOT master-server

    docker run -d --name dolphinscheduler-worker-1 \
    --network dolphinscheduler-net \
    -e ZOOKEEPER_QUORUM="zk1:2181" \
    -e POSTGRESQL_HOST="postgres" -e POSTGRESQL_PORT="5432" -e POSTGRESQL_USERNAME="dolphinscheduler" -e POSTGRESQL_PASSWORD="123" -e POSTGRESQL_DATABASE="dolphinscheduler" \
    -e DOLPHINSCHEDULER_RESOURCE_STORAGE_TYPE="HDFS" \
    apache/dolphinscheduler:1.3.4-SNAPSHOT worker-server

    docker run -d --name dolphinscheduler-worker-2 \
    --network dolphinscheduler-net \
    -e ZOOKEEPER_QUORUM="zk1:2181" \
    -e POSTGRESQL_HOST="postgres" -e POSTGRESQL_PORT="5432" -e POSTGRESQL_USERNAME="dolphinscheduler" -e POSTGRESQL_PASSWORD="123" -e POSTGRESQL_DATABASE="dolphinscheduler" \
    -e DOLPHINSCHEDULER_RESOURCE_STORAGE_TYPE="HDFS" \
    apache/dolphinscheduler:1.3.4-SNAPSHOT worker-server

    docker run -d --name dolphinscheduler-api \
    --network dolphinscheduler-net \
    -e ZOOKEEPER_QUORUM="zk1:2181" \
    -e POSTGRESQL_HOST="postgres" -e POSTGRESQL_PORT="5432" -e POSTGRESQL_USERNAME="dolphinscheduler" -e POSTGRESQL_PASSWORD="123" -e POSTGRESQL_DATABASE="dolphinscheduler" \
    -e DOLPHINSCHEDULER_RESOURCE_STORAGE_TYPE="HDFS" \
    apache/dolphinscheduler:1.3.4-SNAPSHOT api-server

    docker run -d --name dolphinscheduler-alert \
    --network dolphinscheduler-net \
    -e POSTGRESQL_HOST="postgres" -e POSTGRESQL_PORT="5432" -e POSTGRESQL_USERNAME="dolphinscheduler" -e POSTGRESQL_PASSWORD="123" -e POSTGRESQL_DATABASE="dolphinscheduler" \
    apache/dolphinscheduler:1.3.4-SNAPSHOT alert-server

    docker run -d --name dolphinscheduler-frontend \
    --network dolphinscheduler-net \
    -e FRONTEND_API_SERVER_HOST="dolphinscheduler-api" -e FRONTEND_API_SERVER_PORT=12345 \
    -p 8888:8888 \
    apache/dolphinscheduler:1.3.4-SNAPSHOT frontend

## 初始用户名/密码

参考 `sql/dolphinscheduler-postgre.sql`

    -- Records of t_ds_user?user : admin , password : dolphinscheduler123
