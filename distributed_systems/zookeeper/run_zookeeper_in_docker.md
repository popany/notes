# Run Zookeeper in Docker

- [Run Zookeeper in Docker](#run-zookeeper-in-docker)
  - [zookeeper docker hub](#zookeeper-docker-hub)
    - [How to use this image](#how-to-use-this-image)
      - [Start a Zookeeper server instance](#start-a-zookeeper-server-instance)
      - [Connect to Zookeeper from an application in another Docker container](#connect-to-zookeeper-from-an-application-in-another-docker-container)
      - [Connect to Zookeeper from the Zookeeper command line client](#connect-to-zookeeper-from-the-zookeeper-command-line-client)
      - [Configuration](#configuration)
      - [Replicated mode](#replicated-mode)
  - [Practice](#practice)
    - [Run zookeeper in Replicated mode with 3 nodes](#run-zookeeper-in-replicated-mode-with-3-nodes)
      - [client](#client)

## [zookeeper docker hub](https://hub.docker.com/_/zookeeper/)

### How to use this image

#### Start a Zookeeper server instance

    docker run --name some-zookeeper --restart always -d zookeeper

This image includes EXPOSE 2181 2888 3888 8080 (the zookeeper client port, follower port, election port, AdminServer port respectively), so standard container linking will make it automatically available to the linked containers. Since the Zookeeper "fails fast" it's better to always restart it.

#### Connect to Zookeeper from an application in another Docker container

    docker run --name some-app --link some-zookeeper:zookeeper -d application-that-uses-zookeeper

#### Connect to Zookeeper from the Zookeeper command line client

    docker run -it --rm --link some-zookeeper:zookeeper zookeeper zkCli.sh -server zookeeper

#### Configuration

Zookeeper configuration is located in `/conf`. One way to change it is mounting your config file as a volume:

    docker run --name some-zookeeper --restart always -d -v $(pwd)/zoo.cfg:/conf/zoo.cfg zookeeper

#### Replicated mode

- `ZOO_MY_ID`

  The id must be unique within the ensemble and should have a value between 1 and 255. Do note that this variable will not have any effect if you start the container with a /data directory that already contains the myid file.

## Practice

### Run zookeeper in Replicated mode with 3 nodes

    mkdir -p zookeeper/conf
    cd zookeeper/conf

    echo "tickTime=2000" >> zoo.cfg
    echo "dataDir=/data" >> zoo.cfg
    echo "clientPort=2181" >> zoo.cfg
    echo "initLimit=5" >> zoo.cfg
    echo "syncLimit=2" >> zoo.cfg
    echo "server.1=zk1:2888:3888" >> zoo.cfg
    echo "server.2=zk2:2888:3888" >> zoo.cfg
    echo "server.3=zk3:2888:3888" >> zoo.cfg

    docker network create zookeeper

    docker run --name zk1 --hostname zk1 --network zookeeper -e "ZOO_MY_ID=1" -d -v $(pwd)/zoo.cfg:/conf/zoo.cfg zookeeper

    docker run --name zk2 --hostname zk2 --network zookeeper -e "ZOO_MY_ID=2" -d -v $(pwd)/zoo.cfg:/conf/zoo.cfg zookeeper

    docker run --name zk3 --hostname zk3 --network zookeeper -e "ZOO_MY_ID=3" -d -v $(pwd)/zoo.cfg:/conf/zoo.cfg zookeeper

#### client

    docker run -it --rm --network zookeeper zkCli.sh -server zk1
