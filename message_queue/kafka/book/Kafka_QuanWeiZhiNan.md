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

  - 



