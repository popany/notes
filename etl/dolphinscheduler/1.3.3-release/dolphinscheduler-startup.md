# Dolphinscheduler Startup

- [Dolphinscheduler Startup](#dolphinscheduler-startup)
  - [参考 `./docker/build/Dockerfile`](#参考-dockerbuilddockerfile)
    - [启动脚本 `./docker/build/startup.sh`](#启动脚本-dockerbuildstartupsh)
      - [初始化配置 `./docker/build/startup-init-conf.sh`](#初始化配置-dockerbuildstartup-init-confsh)
  - [拉起容器](#拉起容器)
    - [参考 `./docker/build/README.md`](#参考-dockerbuildreadmemd)
    - [案例](#案例)
      - [Docker 环境](#docker-环境)
      - [创建数据库 `dolphinscheduler`](#创建数据库-dolphinscheduler)
      - [启动容器](#启动容器)
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

### 案例

#### Docker 环境

    # docker network inspect dolphinscheduler-net
    [
        {
            "Name": "dolphinscheduler-net",
            "Id": "8fb96beacde2e97bcfe1f94eccd30155f6478bd016448f2f7d7f5f02635ed628",
            "Created": "2021-03-02T03:07:10.4534567Z",
            "Scope": "local",
            "Driver": "bridge",
            "EnableIPv6": false,
            "IPAM": {
                "Driver": "default",
                "Options": {},
                "Config": [
                    {
                        "Subnet": "172.20.0.0/16",
                        "Gateway": "172.20.0.1"
                    }
                ]
            },
            "Internal": false,
            "Attachable": false,
            "Ingress": false,
            "ConfigFrom": {
                "Network": ""
            },
            "ConfigOnly": false,
            "Containers": {
                "0afd2e4c08c32c0bd6527a3ecc53ca3dc6a5f9a59d0ff2e033eb5dd4fb14e5a5": {
                    "Name": "zk2",
                    "EndpointID": "59bc9fdd99170d3f5cb90dbd4bc2ef5cb1e5c77fc75f4d0717186b76e63c8d59",
                    "MacAddress": "02:42:ac:14:00:03",
                    "IPv4Address": "172.20.0.3/16",
                    "IPv6Address": ""
                },
                "b711839f36e89c56d57a9a38054eb0d7feef8338044168ea8d54bbebb5c6af1b": {
                    "Name": "zk1",
                    "EndpointID": "ede6b05e14d5c9da333b0db5e925fbab0adf5efa858453ee1d0797d120427c72",
                    "MacAddress": "02:42:ac:14:00:02",
                    "IPv4Address": "172.20.0.2/16",
                    "IPv6Address": ""
                },
                "ca06bbcd815357af78842f85bb178fe93b0ffe5900ab55a2f1e3daa0dc5ba334": {
                    "Name": "zk3",
                    "EndpointID": "6a5d93322cfe5a919112c35628d3ff91bace01ff8111eb9f5e0fd14198690250",
                    "MacAddress": "02:42:ac:14:00:04",
                    "IPv4Address": "172.20.0.4/16",
                    "IPv6Address": ""
                },
                "f10aac196d649a110eec29eb627c078c8415693647e70c3120a7d9213e296299": {
                    "Name": "postgres",
                    "EndpointID": "bdb95090dc302d1afa0396be648f6be2fdf5933f11faf87d9eede3dda476f351",
                    "MacAddress": "02:42:ac:14:00:05",
                    "IPv4Address": "172.20.0.5/16",
                    "IPv6Address": ""
                }
            },
            "Options": {},
            "Labels": {}
        }
    ]

#### 创建数据库 `dolphinscheduler`

#### 启动容器

    docker run -dit --name dolphinscheduler \
    --network dolphinscheduler-net \
    -e ZOOKEEPER_QUORUM="zk1:2181,zk2:2181,zk3:2181" \
    -e POSTGRESQL_HOST="postgres" -e POSTGRESQL_PORT="5432" -e POSTGRESQL_USERNAME="postgres" -e POSTGRESQL_PASSWORD="123" -e POSTGRESQL_DATABASE="dolphinscheduler" -e DOLPHINSCHEDULER_RESOURCE_STORAGE_TYPE="NONE"\
    -p 8888:8888 \
    apache/dolphinscheduler:1.3.4-SNAPSHOT all

## 初始用户名/密码

参考 `sql/dolphinscheduler-postgre.sql`

    -- Records of t_ds_user?user : admin , password : dolphinscheduler123
