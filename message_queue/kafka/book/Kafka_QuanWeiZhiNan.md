# Kafka权威指南

- [Kafka权威指南](#kafka权威指南)
  - [第 1 章 初识Kafka](#第-1-章-初识kafka)
    - [1.1 发布与订阅消息系统](#11-发布与订阅消息系统)
    - [1.2 Kafka登场](#12-kafka登场)
      - [1.2.1　消息和批次](#121消息和批次)
      - [1.2.2　模式](#122模式)
      - [1.2.3　主题和分区](#123主题和分区)
      - [1.2.4　生产者和消费者](#124生产者和消费者)
      - [1.2.5 broker和集群](#125-broker和集群)
      - [1.2.6 多集群](#126-多集群)
    - [1.3 为什么选择 Kafka](#13-为什么选择-kafka)
      - [1.3.1 多个生产者](#131-多个生产者)
      - [1.3.2 多个消费者](#132-多个消费者)
      - [1.3.3 基于磁盘的数据存储](#133-基于磁盘的数据存储)
      - [1.3.4 伸缩性](#134-伸缩性)
      - [1.3.5 高性能](#135-高性能)
    - [1.4 数据生态系统](#14-数据生态系统)
  - [第 2 章 安装Kafka](#第-2-章-安装kafka)
    - [2.1 要事先行](#21-要事先行)
      - [2.1.1 选择操作系统](#211-选择操作系统)
      - [2.1.2 安装Java](#212-安装java)
      - [2.1.3 安装Zookeeper](#213-安装zookeeper)
    - [2.2　安装Kafka Broker](#22安装kafka-broker)
    - [2.3 broker配置](#23-broker配置)
      - [2.3.1 常规配置](#231-常规配置)
      - [2.3.2 主题的默认配置](#232-主题的默认配置)
    - [2.4 硬件的选择](#24-硬件的选择)
      - [2.4.1 磁盘吞吐量](#241-磁盘吞吐量)
      - [2.4.2 磁盘容量](#242-磁盘容量)
      - [2.4.3 内存](#243-内存)
      - [2.4.4 网络](#244-网络)
      - [2.4.5 CPU](#245-cpu)
    - [2.5 云端的Kafka](#25-云端的kafka)
    - [2.6 Kafka集群](#26-kafka集群)
      - [2.6.1 需要多少个broker](#261-需要多少个broker)
      - [2.6.2 broker配置](#262-broker配置)
      - [2.6.3 操作系统调优](#263-操作系统调优)
    - [2.7 生产环境的注意事项](#27-生产环境的注意事项)
      - [2.7.1 垃圾回收器选项](#271-垃圾回收器选项)
      - [2.7.2 数据中心布局](#272-数据中心布局)
      - [2.7.3 共享Zookeeper](#273-共享zookeeper)
    - [2.8 总结](#28-总结)
  - [第 3 章 Kafka生产者——向Kafka写入数据](#第-3-章-kafka生产者向kafka写入数据)
    - [3.1 生产者概览](#31-生产者概览)
    - [3.2 创建Kafka生产者](#32-创建kafka生产者)
    - [3.3 发送消息到Kafka](#33-发送消息到kafka)
      - [3.3.1 同步发送消息](#331-同步发送消息)
      - [3.3.2 异步发送消息](#332-异步发送消息)

## 第 1 章 初识Kafka

### 1.1 发布与订阅消息系统

- 发布者

  - 消息发送者

- 订阅者

  - 消息接收者

- 消息

  - 数据

- 消息分类

  - 发布者对消息进行分类

  - 订阅者订阅并接收特定类型的消息

- broker
  
  - 发布消息的中心点

  - 发布者不会直接把消息发送给接收者

### 1.2 Kafka登场

- Kafka

  - 基于发布与订阅的消息系统

  - 一般被称为“分布式提交日志”或者“分布式流平台”

#### 1.2.1　消息和批次

- 消息

  - Kafka 的数据单元

  - 由字节数组组成

    - 对于 Kafka 来说，消息里的数据没有特别的格式或含义

  - 键

    - 消息的可选的元数据

    - 键也是一个字节数组

    - 与消息一样，对于 Kafka 来说也没有特殊的含义

    - 当消息以一种可控的方式写入不同的分区时，会用到键

- 批次

  - 为了提高效率，消息被分批次写入 Kafka

  - 批次就是一组消息
  
    - 这些消息属于同一个主题和分区

  - 批次大小

    - 要在时间延迟和吞吐量之间作出权衡

#### 1.2.2　模式

- 消息模式（schema）

  - 定义消息内容

  - 举例

    - JSON/XML

      - 易用、可读性好

      - 缺乏强类型处理能力

      - 不同版本间兼容性不好

    - Apache Avro

      - 是一种序列化框架

      - 消息和消息体是分开的

        - 当模式发生变化时，不需要重新生成代码

      - 支持强类型

      - 支持模式进化

        - 其版本既向前兼容，也向后兼容

#### 1.2.3　主题和分区

- 主题

  - 消息通过主题进行分类

  - 类比

    - 数据库里的表

    - 文件系统里的文件夹

- 分区

  - 主题可分为若干分区

  - 一个分区就是一个提交日志

  - 消息以追加的方式写入分区，后以先入先出顺序读取

- 消息顺序

  - 对于一个主题包含多个分区的情况，无法在整个主题范围内保证消息的顺序

  - 可以保证消息在单个分区内的顺序

#### 1.2.4　生产者和消费者

- Kafka 客户端

  - 生产者

  - 消费者

  - 高级客户端 API

    - Kafka Connect API

      用于数据集成

    - Kafka Streams

      用于流式处理

- 生产者

  - 创建消息

    - 消息会被发布到一个特定主题上

    - 通过消息键和分区器控制消息写入的分区

  - 在其他发布与订阅系统中也成为发布者或写入者

- 消费者

  - 读取消息

    - 订阅一个或多个主题

    - 按照消息的生成顺序读取

    - 通过检查消息的偏移量来区分已经读取过的消息

  - 在其他发布与订阅系统中也成为订阅者或读者

- 偏移量

  - 一种元数据

  - 是一个不断递增的整数值

  - 在给定的分区里，每个消息的偏移量是唯一的

  - 保存

    - 消费者把每个分区最后读取的消息偏移量保存在 Zookeeper 或 Kafka 上

    - 如果消费者关闭或重启，它的读取状态不会丢失

- 消费者群组

  - 一个或多个消费者共同读取一个主题
  
  - 群组保证每个分区只能被一个消费者使用

    - 消费者对分区的所有权关系

      消费者与分区之间的映射

#### 1.2.5 broker和集群

- broker

  - 一个独立的 Kafka 服务器

  - 功能

    - 接收来自生产者的消息

      - 消息设置偏移量

      - 提交消息到磁盘保存

    - 为消费者提供服务

      - 对读取分区的请求作出响应

      - 返回已经提交到磁盘上的消息

  - 性能

    - 单个 broker 可以轻松处理数千个分区以及每秒百万级的消息量

- 集群

  - 集群控制器

    - 每个集群都有一个 broker 同时充当了集群控制器的角色

      - 自动从集群的活跃成员中选举出来

    - 负责管理工作

      - 将分区分配给 broker

      - 监控 broker

- 分区的首领

  - 该分区所从属于的 broker

- 分区复制

  - 分区被分配给多个 broker 时发生

- 保留消息

  - 默认的策略

    - 要么保留一段时间

    - 要么保留到消息达到一定大小

  - 主题可以配置自己的保留策略

    - 紧凑型日志

      - 只有最后一个带有特定键的消息会被保留下来

#### 1.2.6 多集群

- 使用多集群的原因

  - 数据类型分离

  - 安全需求隔离

  - 多数据中心(灾难恢复)

- kafka 的消息复制机制

  只能在单个集群里进行, 不能在多个集群之间进行

- MirrorMaker 工具

  - 可实现集群间的消息复制

  - 核心组件

    - 一个消费者

      从一个集群读取消息

    - 一个生产者

      把消息发送到另一个集群上

    - 生产者与消费者间的队列

### 1.3 为什么选择 Kafka

#### 1.3.1 多个生产者

#### 1.3.2 多个消费者

#### 1.3.3 基于磁盘的数据存储

#### 1.3.4 伸缩性

#### 1.3.5 高性能

### 1.4 数据生态系统

- 大数据生态系统

      在线应用程序         流处理               离线处理
      Apache Solr,        Samza, Spark,        Hadoop
      OpenTSDB            Storm, Flink
           ^                  ^                   ^
           |                  |                   |
           |                  |                   |
      |----v------------------v-------------------v----|
      |                     Kafka                      |
      |--^------------^-------------^---------------^--|
         |            |             |               |
         |            |             |               |
        指标         日志         交易数据       物联网数据

- 使用场景

  - 活动跟踪

  - 传递消息

  - 度量指标和日志记录

  - 提交日志

  - 流处理

## 第 2 章 安装Kafka

### 2.1 要事先行

#### 2.1.1 选择操作系统

#### 2.1.2 安装Java

推荐安装 Java 8

#### 2.1.3 安装Zookeeper

1. 单机服务

   - 安装目录

     `/usr/local/zookeeper`

   - 数据目录

     `/var/lib/zookeeper`

   配置安装 Zookeeper

       # tar -zxf zookeeper-3.4.6.tar.gz
       # mv zookeeper-3.4.6 /usr/local/zookeeper
       # mkdir -p /var/lib/zookeeper
       # cat > /usr/local/zookeeper/conf/zoo.cfg << EOF
       > tickTime=2000
       > dataDir=/var/lib/zookeeper
       > clientPort=2181
       > EOF
       # export JAVA_HOME=/usr/java/jdk1.8.0_51
       # /usr/local/zookeeper/bin/zkServer.sh start
       JMX enabled by default
       Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
       Starting zookeeper ... STARTED
       #

   验证 Zookeeper 是否安装正确

       # telnet localhost 2181
       Trying ::1...
       Connected to localhost.
       Escape character is '^]'.
       srvr
       Zookeeper version: 3.4.6-1569965, built on 02/20/2014 09:09 GMT
       Latency min/avg/max: 0/0/0
       Received: 1
       Sent: 0
       Connections: 1
       Outstanding: 0
       Zxid: 0x0
       Mode: standalone
       Node count: 4
       Connection closed by foreign host.
       #

2. Zookeeper 群组(Ensemble)

   - Zookeeper 集群被称为群组

   - Zookeeper 使用一致性协议

     - 建议每个群组里应该包含奇数个节点(比如 3 个、5 个等)

     - 只有当群组里的大多数节点(也就是法定人数)处于可用状态, Zookeeper 才能处理外部的请求

       - 如果你有一个包含 3 个节点的群组, 那么它允许一个节点失效

       - 如果群组包含 5 个节点, 那么它允许 2 个节点失效

   群组些公共配置文件举例

       tickTime=2000
       dataDir=/var/lib/zookeeper
       clientPort=2181
       initLimit=20
       syncLimit=5
       server.1=zoo1.example.com:2888:3888
       server.2=zoo2.example.com:2888:3888
       server.3=zoo3.example.com:2888:3888

   - 假定集群中服务器机器名为  `zoo1.example.com`, `zoo2.example.com`, `zoo3.example.com`

   - 每个服务器要在数据目录中创建一个 myid 文件, 指明自己的 ID, 该 ID 要与配置文件一致

   - `tickTime`

     单位 ms

   - `initLimit`

     - 从节点与主节点建立初始化连接的时间上限

     - 单位 `tickTime`

   - `syncLimit`

     - 从节点与主节点处于不同步状态的时间上限

     - 单位 `tickTime`

   - 服务器地址格式

     `server.X=hostname:peerPort:leaderPort`

     - `X`

       - 服务器的 ID

       - 必须是一个整数

       - 不一定要从 0 开始, 也不要求是连续的

     - `hostname`

       服务器的机器名或 IP 地址

     - `peerPort`

       用于节点间通信的 TCP 端口

     - `leaderPort`

       用于首领选举的 TCP 端口

   - 端口说明

     - 客户端只需要通过 clientPort 就能连接到群组

     - 而群组节点间的通信则需要同时用到这 3 个端口(peerPort, leaderPort, clientPort)

### 2.2　安装Kafka Broker

- Kafka 安装在 `/usr/local/kafka` 目录下

- 把消息日志保存在 `/tmp/kafka-logs` 目录下

安装:

    # tar -zxf kafka_2.11-0.9.0.1.tgz
    # mv kafka_2.11-0.9.0.1 /usr/local/kafka
    # mkdir /tmp/kafka-logs
    # export JAVA_HOME=/usr/java/jdk1.8.0_51
    # /usr/local/kafka/bin/kafka-server-start.sh -daemon
    /usr/local/kafka/config/server.properties
    #

验证安装正确:

- 创建并验证测试主题

      # /usr/local/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181
      --replication-factor 1 --partitions 1 --topic test
      Created topic "test".
      # /usr/local/kafka/bin/kafka-topics.sh --zookeeper localhost:2181
      --describe --topic test
      Topic:test PartitionCount:1 ReplicationFactor:1 Configs:
      Topic: test Partition: 0 Leader: 0 Replicas: 0 Isr: 0
      #

- 往测试主题上发布消息

      # /usr/local/kafka/bin/kafka-console-producer.sh --broker-list
      localhost:9092 --topic test
      Test Message 1
      Test Message 2
      ^D
      #

- 从测试主题上读取消息

      # /usr/local/kafka/bin/kafka-console-consumer.sh --zookeeper
      localhost:2181 --topic test --from-beginning
      Test Message 1
      Test Message 2
      ^C
      Consumed 2 messages
      #

### 2.3 broker配置

#### 2.3.1 常规配置

1. `broker.id`

   - broker 的标识符

   - 可设置为任意整数

     - 默认值 0

     - 在 Kafka 集群里必须是唯一的

2. `port`

   - 默认 9092

3. `zookeeper.connect`

   格式 `hostname:port/path`

   - `hostname`

     Zookeeper 服务器的机器名或 IP 地址

   - `port`

     Zookeeper 的客户端连接端口

   - `/path`

     - Zookeeper 路径, 作为 Kafka 集群的 chroot 环境

     - 可选. 如果不指定, 默认使用根路径

     - 如果路径不存在, broker 会在启动的时候创建

   - 可以指定一组 Zookeeper 服务器, 用分号把它们隔开

4. `log.dirs`

   - 一组用逗号分隔的本地文件系统路径

   - 指定存储日志片段文件的目录

   - "最少使用" 原则

     - 把同一分区的日志片段保存在同一目录

     - 往拥有最少数目分区的目录新增分区

5. `num.recovery.threads.per.data.dir`

   处理每个日志目录中的日志片段的线程池大小

   - 默认值 1

   - 若该值设置为 8, `log.dirs` 设置为 3, 则共需要 24 个线程

   处理日志片段的线程池的使用场景:

   - 服务器正常启动, 用于打开每个分区的日志片段
   - 服务器崩溃后重启, 用于检查和截短每个分区的日志片段
   - 服务器正常关闭, 用于关闭日志片段

6. `auto.create.topics.enable`

   - 默认值 `true`

   - 若为 `true`, Kafka 在如下情况自动创建主题

     - 当一个生产者开始往主题写入消息时
     - 当一个消费者开始从主题读取消息时
     - 当任意一个客户端向主题发送元数据请求时

#### 2.3.2 主题的默认配置

可以通过管理工具单独配置每个主题

1. `num.partitions`

   - 指定新创建的主题包含的分区个数

   - 默认值 1

   - 可通过手动创建主题指定分区数

2. `log.retention.ms` / `log.retention.hours` / `log.retention.minutes`

   - 数据保存时间

   - 三个参数作用相同, 值最小的参数起作用

   - 默认情况下数据保留一周

   - 保留数据时间检查

     - 通过检查日志片段文件的最后修改时间实现

3. `log.retention.bytes`

   单个分区可保留的数据大小

4. `log.segment.bytes`

   - 日志片段大小上限

     超过该值后, 日志片段文件被关闭, 关闭后才开始等待过期

5. `log.segment.ms`

   - 控制日志片段的关闭时间

6. `message.max.bytes`

   - 压缩后的单个消息大小上限

   - 默认值 `1000 000`

   - 若超过该大小, 生产者会收到 broker 返回的错误

   - 要与消费者客户端设置的 `fetch.message.max.bytes` 相协调

     - 否则会出现消费者被阻塞的情况

   - 要与集群中的 broker 配置的 `replica.fetch.max.bytes` 相协调

### 2.4 硬件的选择

#### 2.4.1 磁盘吞吐量

#### 2.4.2 磁盘容量

#### 2.4.3 内存

#### 2.4.4 网络

#### 2.4.5 CPU

### 2.5 云端的Kafka

### 2.6 Kafka集群

#### 2.6.1 需要多少个broker

决定因素:

- 需要多少磁盘空间来保留数据, 以及单个 broker 有多少空间可用

- 集群处理请求的能力

#### 2.6.2 broker配置

#### 2.6.3 操作系统调优

1. 虚拟内存

   对于大多数依赖吞吐量的应用程序来说, 要尽量避免内存交换

2. 磁盘

   最后访问时间(atime)

   - 更新 atime 导致大量的磁盘写操作

   - Kafka 用不到该属性

   - 为挂载点设置 noatime 参数可以防止更新 atime

3. 网络

### 2.7 生产环境的注意事项

#### 2.7.1 垃圾回收器选项

#### 2.7.2 数据中心布局

#### 2.7.3 共享Zookeeper

- Kafka 使用 Zookeeper 来保存 broker、主题和分区的元数据信息

- 在很多部署环境里, 会让多个 Kafka 集群共享一个 Zookeeper 群
组(每个集群使用一个 chroot 路径)

- 虽然多个 Kafka 集群可以共享一个 Zookeeper 群组, 但如果有可能的话, 不建议把 Zookeeper 共享给其他应用程序

- Kafka 消费者和 Zookeeper

  - 在 Kafka 0.9.0.0 版本之前

    除了 broker 之外, 消费者也会使用 Zookeeper 来保存一些信息, 比如消费者群组的信息、主题信息、消费分区的偏移量（在消费者群组里发生失效转移时会用到）

  - 到了 0.9.0.0 版本

    Kafka 引入了一个新的消费者接口, 允许 broker 直接维护这些信息

  - 建议使用最新版本的 Kafka

    让消费者把偏移量提交到 Kafka 服务器上，消除对 Zookeeper 的依赖

### 2.8 总结

## 第 3 章 Kafka生产者——向Kafka写入数据

### 3.1 生产者概览

- 使用场景

  - 记录用户的活动(用于审计和分析)
  - 记录度量指标
  - 保存日志消息
  - 记录智能家电的信息
  - 与其他应用程序进行异步通信
  - 缓冲即将写入到数据库的数据, 等等

- 需求

  - 是否每个消息都很重要
  - 是否允许丢失一小部分消息
  - 偶尔出现重复消息是否可以接受
  - 是否有严格的延迟和吞吐量要求

发送消息的主要步骤:

                                              +----------------+
                                              | ProducerRecord |
                                              | +------------+ |
                                              | |   Topic    | |
                                              | |------------| |
                                              | |[Partition] | |
                    +------+----------------->| |------------| |
                    |      |                  | |   [key]    | |
                    |      |                  | |------------| |
                    |      |                  | |   Value    | |
                    |      |                  | +------------+ |
                    |      |                  +-------+--------+ 
                    |      |                          |
    When successful |      | If can't retry,          | send()
    return Metadata |      | throw exception          |
                    |      |                     +----v-----+
                    |      |                     |Serializer|
                    |      |                     +----+-----+
                    |      |                          |
                    |      |                     +----v------+
                    |      |                     |Partitioner|
                    |      |                     +----+------+
                    |      |                          |
                    |      |                +---------+---------+
                    |      |                |                   |
                    |      |         +------v------+     +------v------+
                    |      |         |   Topic A   |     |   Topic A   |
                    |      /\   yes  | Partition 0 |     | Partition 0 |
                    |    Retry?----->| +---------+ |     | +---------+ |
                    |      \/        | | Batch 0 | |     | | Batch 0 | |
                    |      ^         | |---------| |     | |---------| |
                    |      | yes     | | Batch 1 | |     | | Batch 1 | |
                    |      |         | |---------| |     | |---------| |
                    |      /\        | | Batch 2 | |     | | Batch 2 | |
                    +---- Fail?      | +---------+ |     | +---------+ |
                           \/        +-------------+     +-------------+
                           ^                |                   |
                           |                +---------+---------+
                           |                          |
                           |                   +------v------+
                           +-------------------|Kafka Brocker|
                                               +-------------+
                
    









### 3.2 创建Kafka生产者

- 生产者的 3 个必选属性

  - `bootstrap.servers`

    - 指定 broker 的地址清单

      - 地址的格式为 `host:port`  

    - 清单里不需要包含所有的 broker 地址

      - 生产者会从给定的 broker 里查找到其他 broker 的信息

      - 建议至少要提供两个 broker 的信息

        - 一旦其中一个宕机, 生产者仍然能够连接到集群上

  - `key.serializer`

    - 必须被设置为一个实现了 `org.apache.kafka.common.serialization.Serializer` 接口的类

    - Kafka 客户端默认提供了

      - `ByteArraySerializer`
      - `StringSerializer`
      - `IntegerSerializer`

  - `value.serializer`

代码示例, 创建一个生产者, 只指定必选属性:

    private Properties kafkaProps = new Properties();
    kafkaProps.put("bootstrap.servers", "broker1:9092,broker2:9092");
    kafkaProps.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
    kafkaProps.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
    producer = new KafkaProducer<String, String>(kafkaProps);

- 发送消息的三种方式

  - 发送并忘记（fire-and-forget）

    - 不关心消息是否正常到达

    - 大多数情况下，消息会正常到达

      - 因为 Kafka 是高可用的
      - 而且生产者会自动尝试重发

    - 不过，使用这种方式有时候也会丢失一些消息

- 同步发送

  - 使用 `send()` 方法发送消息

    - 它会返回一个 `Future` 对象
    - 调用 `get()` 方法进行等待, 就可以知道消息是否发送成功

- 异步发送

  - 调用 `send()` 方法, 并指定一个回调函数

    - 服务器在返回响应时调用该函数

### 3.3 发送消息到Kafka

最简单的消息发送方式:

    ProducerRecord<String, String> record = new ProducerRecord<>("CustomerCountry", "Precision Products", "France");
    try {
        producer.send(record);
    } catch (Exception e) {
        e.printStackTrace();
    }

- 键和值对象的类型必须与序列化器和生产者对象相匹配

- 消息先是被放进缓冲区, 然后使用单独的线程发送到服务器端

- 忽略 `send()` 返回值, 不关心消息是否发送成功

- 发送消息前生产者可能发生其他异常

  - `SerializationException`

    说明序列化消息失败

  - `BufferExhaustedException` 或 `TimeoutException`

    说明缓冲区已满

  - `InterruptException`

    说明发送线程被中断

#### 3.3.1 同步发送消息

最简单的同步发送消息方式:

    ProducerRecord<String, String> record = new ProducerRecord<>("CustomerCountry", "Precision Products", "France");
    try {
        producer.send(record).get();
    } catch (Exception e) {
        e.printStackTrace();
    }

- `producer.send()` 方法返回一个 `Future` 对象

- 调用 `Future` 对象的 `get()` 方法等待 Kafka 响应

  - 如果服务器返回错误, `get()` 方法会抛出异常

  - 如果没有发生错误, 返回 `RecordMetadata` 对象

    - 可以用它获取消息的偏移量

KafkaProducer 一般会发生两类错误:

- 可重试错误

  - 可以通过重发消息解决

    比如:

    - 对于连接错误

      可以通过再次建立连接来解决

    - "无主(no leader)"错误

      可以通过重新为分区选举首领来解决

  - `KafkaProducer` 可以被配置成自动重试

    如果在多次重试后仍无法解决问题, 应用程序会收到一个重试异常

- 无法通过重试解决的错误

  比如:

  - "消息太大"异常

    对于这类错误, `KafkaProducer` 不会进行任何重试, 直接抛出异常

#### 3.3.2 异步发送消息




