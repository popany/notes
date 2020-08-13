# kafka

- [kafka](#kafka)
  - [docker](#docker)
    - [kafka-docker](#kafka-docker)
    - [Kafka Docker 部署](#kafka-docker-部署)
      - [单机部署](#单机部署)
        - [创建网络](#创建网络)
        - [创建 zookeeper 容器](#创建-zookeeper-容器)
        - [创建 kafka 容器](#创建-kafka-容器)
        - [生产消息](#生产消息)
        - [消费消息](#消费消息)
  - [Command](#command)
    - [创建 topic](#创建-topic)
    - [查看 topic](#查看-topic)
    - [用 console-producer 生产消息](#用-console-producer-生产消息)
    - [用 console-consumer 消费消息](#用-console-consumer-消费消息)

## docker

### [kafka-docker](https://github.com/wurstmeister/kafka-docker)


### [Kafka Docker 部署](https://www.jianshu.com/p/bacc8eb03c4b)

#### 单机部署

##### 创建网络

    docker network create kafka

##### 创建 zookeeper 容器

    docker run --network kafka --name zookeeper -p 2181:2181 -d zookeeper 

##### 创建 kafka 容器

    $ docker inspect zookeeper|jq '.[].NetworkSettings.Networks.kafka.IPAddress'
    "172.20.0.2"

    $ docker run --network kafka --name kafka -p 9092:9092 \
    --link zookeeper \
    -e KAFKA_BROKER_ID=1 \
    -e KAFKA_ZOOKEEPER_CONNECT=172.20.0.2:2181 \
    -e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
    -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://10.254.2.16:9092 \
    -d wurstmeister/kafka

注 10.254.2.16 为 windows host ip

##### 生产消息

进入 kafka 容器

    /opt/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test1

##### 消费消息

进入 kafka 容器

/opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test1 --from-beginning

## Command

### 创建 topic

    ./kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test1

### 查看 topic

    ./kafka-topics.sh --list --zookeeper localhost:2181

### 用 console-producer 生产消息

    ./kafka-console-producer.sh --broker-list localhost:9092 --topic test1

### 用 console-consumer 消费消息

    ./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test1 --from-beginning
