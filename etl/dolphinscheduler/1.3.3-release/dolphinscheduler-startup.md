# Dolphinscheduler Startup

- [Dolphinscheduler Startup](#dolphinscheduler-startup)
  - [参考 `./docker/build/Dockerfile`](#参考-dockerbuilddockerfile)
    - [启动脚本 `./docker/build/startup.sh`](#启动脚本-dockerbuildstartupsh)
      - [初始化配置 `./docker/build/startup-init-conf.sh`](#初始化配置-dockerbuildstartup-init-confsh)
  - [拉起容器](#拉起容器)
    - [参考 `./docker/build/README.md`](#参考-dockerbuildreadmemd)

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
