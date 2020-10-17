# [An Introduction to Kafka](https://dzone.com/articles/a-begineers-approach-to-quotkafkaquot)

- [An Introduction to Kafka](#an-introduction-to-kafka)
  - [What Is Kafka](#what-is-kafka)
  - [Getting Familiar With Kafka](#getting-familiar-with-kafka)
    - [Why Kafka](#why-kafka)
    - [What Is a Messaging System](#what-is-a-messaging-system)
    - [Benefits of Kafka](#benefits-of-kafka)
  - [Basics of Kafka](#basics-of-kafka)
    - [Topics and Logs](#topics-and-logs)
    - [Partitions](#partitions)
    - [Partition Offset](#partition-offset)
    - [Replicas](#replicas)
    - [Brokers](#brokers)
    - [Zookeeper](#zookeeper)
    - [Cluster](#cluster)
  - [Creating a General Single Broker Cluster](#creating-a-general-single-broker-cluster)

## What Is Kafka

In simple terms, Kafka is a messaging system that is designed to be fast, scalable, and durable. It is an open-source stream processing platform. Apache Kafka originated at LinkedIn and later became an open-source Apache project in 2011, then a first-class Apache project in 2012. Kafka is written in Scala and Java. It aims at providing a high-throughput, low-latency platform for handling real-time data feeds.

## Getting Familiar With Kafka

Apache describes Kafka as a distributed streaming platform that lets us:

1. Publish and subscribe to streams of records.
2. Store streams of records in a fault-tolerant way.
3. Process streams of records as they occur.

### Why Kafka

In Big Data, an enormous volume of data is used. But how are we going to collect this large volume of data and analyze that data? To overcome this, we need a messaging system. That is why we need Kafka. The functionalities that it provides are well-suited for our requirements, and thus we use Kafka for:

1. Building real-time streaming data pipelines that can get data between systems and applications.

2. Building real-time streaming applications to react to the stream of data.

### What Is a Messaging System

A messaging system is a system that is used for transferring data from one application to another so that the applications can focus on data and not on how to share it. Kafka is a distributed publish-subscribe messaging system. In a publish-subscribe system, messages are persisted in a topic. Message producers are called publishers and message consumers are called subscribers. Consumers can subscribe to one or more topic and consume all the messages in that topic (we will discuss these terminologies later in the post).

### Benefits of Kafka

Four main benefits of Kafka are:

1. **Reliability**. Kafka is distributed, partitioned, replicated, and fault tolerant. Kafka replicates data and is able to support multiple subscribers. Additionally, it automatically balances consumers in the event of failure.

2. **Scalability**. Kafka is a distributed system that scales quickly and easily without incurring any downtime.

3. **Durability**. Kafka uses a distributed commit log, which means messages persists on disk as fast as possible providing intra-cluster replication, hence it is durable.

4. **Performance**. Kafka has high throughput for both publishing and subscribing messages. It maintains stable performance even when dealing with many terabytes of stored messages.

Now, we can move on to our next step: Kafka basics.

## Basics of Kafka

Apache.org states that:

1. Kafka runs as a cluster on one or more servers.
2. The Kafka cluster stores a stream of records in categories called topics.
3. Each record consists of a **key**, a **value**, and a **timestamp**.

### Topics and Logs

A topic is a feed name or category to which records are published. Topics in Kafka are always multi-subscriber — that is, a topic can have zero, one, or many consumers that subscribe to the data written to it. For each topic, the Kafka cluster maintains a partition log that looks like this:

![fig1](./fig/An_Introduction_to_Kafka/log_anatomy.png)

### Partitions

A topic may have many partitions so that it can handle an arbitrary amount of data. In the above diagram, the topic is configured into three partitions (partition{0,1,2}). Partition0 has 13 offsets, Partition1 has 10 offsets, and Partition2 has 13 offsets.

### Partition Offset

Each partitioned message has a **unique sequence ID** called an offset. For example, in Partition1, the offset is marked from 0 to 9.

### Replicas

Replicas are nothing but backups of a partition. If the replication factor of the above topic is set to 4, then Kafka will create four identical replicas of each partition and place them in the cluster to make them available for all its operations. Replicas are **never used to read or write data**. They are used to prevent data loss.

### Brokers

Brokers are simple systems responsible for maintaining published data. Kafka brokers are **stateless**, so they use ZooKeeper for maintaining their cluster state. Each broker may have **zero or more** partitions per topic. For example, if there are 10 partitions on a topic and 10 brokers, then each broker will have one partition. But if there are 10 partitions and 15 brokers, then the starting 10 brokers will have one partition each and the remaining five won’t have any partition for that particular topic. However, if partitions are 15 but brokers are 10, then brokers would be sharing one or more partitions among them, leading to unequal load distribution among the brokers. Try to avoid this scenario.

### Zookeeper

ZooKeeper is used for managing and coordinating Kafka brokers. ZooKeeper is mainly used to notify producers and consumers about the **presence of any new broker** in the Kafka system or about the **failure of any broker** in the Kafka system. ZooKeeper notifies the producer and consumer about the presence or failure of a broker based on which producer and consumer makes a decision and starts coordinating their tasks with some other broker.

### Cluster

When Kafka has more than one broker, it is called a Kafka cluster. A Kafka cluster can be **expanded without downtime**. These clusters are used to manage the persistence and replication of message data.

Kafka has four core APIs:

1. The **Producer API** allows an application to publish a stream of records to one or more Kafka topics.

2. The **Consumer API** allows an application to subscribe to one or more topics and process the stream of records produced to them.

3. The **Streams API** allows an application to act as a stream processor, consuming an input stream from one or more topics and producing an output stream to one or more output topics, effectively transforming the input streams to output streams.

4. The **Connector API** allows building and running reusable producers or consumers that connect Kafka topics to existing applications or data systems. For example, a connector to a relational database might capture every change to a table.

Up to now, we've discussed theoretical concepts to get ourselves familiar with Kafka. Now, we will be using some of these concepts in setting up of our single broker cluster.

## Creating a General Single Broker Cluster
