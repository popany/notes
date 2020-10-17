# [How to Set Up Kafka](https://dzone.com/articles/kafka-setup)

- [How to Set Up Kafka](#how-to-set-up-kafka)
  - [Installation](#installation)
  - [ZooKeeper Setup](#zookeeper-setup)
  - [Kafka Setup](#kafka-setup)
  - [Kafka Broker Properties](#kafka-broker-properties)
  - [Socket Server Properties](#socket-server-properties)
  - [Flush Properties](#flush-properties)
  - [Log Retention](#log-retention)
  - [Conclusion](#conclusion)

Kafka is one of the most popular publisher-subscriber models written in Java and Scala. It was originally developed by LinkedIn and later open-sourced. Kafka is known for handling heavy loads, i.e. I/O operations. You can find out more about Kafka [here](http://kafka.apache.org/).

## Installation

In this article, I am going to explain how to install Kafka on Ubuntu. To install Kafka, Java must be installed on your system. It is a must to set up ZooKeeper for Kafka. ZooKeeper performs many tasks for Kafka but in short, we can say that ZooKeeper manages the Kafka cluster state.

## ZooKeeper Setup

- Download ZooKeeper from [here](https://www.apache.org/dyn/closer.cgi/zookeeper/).

- Unzip the file. Inside the conf directory, rename the file zoo_sample.cfgas **zoo.cfg**.

- The zoo.cfg file keeps configuration for ZooKeeper, i.e. on which port the ZooKeeper instance will listen, data directory, etc.

- The default listen port is `2181`. You can change this port by changing clientPort.

- The default data directory is `/tmp/data`. Change this, as you will not want ZooKeeper's data to be deleted after some random timeframe. Create a folder with the name data in the ZooKeeper directory and change the dataDir in zoo.cfg.

- Go to the `bin` directory.

- Start ZooKeeper by executing the command `./zkServer.sh` start.

- Stop ZooKeeper by stopping the command `./zkServer.sh` stop.

## Kafka Setup

- Download the latest stable version of Kafka from [here](https://kafka.apache.org/downloads).

- Unzip this file. The Kafka instance (Broker) configurations are kept in the config directory.

- Go to the config directory. Open the file `server.properties`.

- Remove the comment from listeners property, i.e. `listeners=PLAINTEXT://:9092`. The Kafka broker will listen on port `9092`.

- Change `log.dirs` to `/kafka_home_directory/kafka-logs`.

- Check the `zookeeper.connect` property and change it as per your needs. The Kafka broker will connect to this ZooKeeper instance.

- Go to the Kafka home directory and execute the command `./bin/kafka-server-start.sh config/server.properties`.

- Stop the Kafka broker through the command `./bin/kafka-server-stop.sh`.

## Kafka Broker Properties

For beginners, the default configurations of the Kafka broker are good enough, but for production-level setup, one must understand each configuration. I am going to explain some of these configurations.

- `broker.id`: The ID of the broker instance in a cluster.

- `zookeeper.connect`: The ZooKeeper address (can list multiple addresses comma-separated for the ZooKeeper cluster). Example: `localhost:2181,localhost:2182`.

- `zookeeper.connection.timeout.ms`: Time to wait before going down if, for some reason, the broker is not able to connect.

## Socket Server Properties

- `socket.send.buffer.bytes`: The send buffer used by the socket server.

- `socket.receive.buffer.bytes`: The socket server receives a buffer for network requests.

- `socket.request.max.bytes`: The maximum request size the server will allow. This prevents the server from running out of memory.

## Flush Properties

Each arriving message at the Kafka broker is written into a segment file. The catch here is that this data is not written to the disk directly. It is buffered first. The below two properties define when data will be flushed to disk. Very large flush intervals may lead to latency spikes when the flush happens and a very small flush interval may lead to excessive seeks.

- `log.flush.interval.messages`: Threshold for message count that is once reached all messages are flushed to the disk.

- `log.flush.interval.ms`: Periodic time interval after which all messages will be flushed into the disk.

## Log Retention

As discussed above, messages are written into a segment file. The following policies define when these files will be removed.

- `log.retention.hours`: The minimum age of the segment file to be eligible for deletion due to age.

- `log.retention.bytes`: A size-based retention policy for logs. Segments are pruned from the log unless the remaining segments drop below `log.retention.bytes`.

- `log.segment.bytes`: Size of the segment after which a new segment will be created.

- `log.retention.check.interval.ms`: Periodic time interval after which log segments are checked for deletion as per the retention policy. If both retention policies are set, then segments are deleted when either criterion is met.

## Conclusion

Thanks for reading my article. [Here](https://dzone.com/articles/kafka-producer-and-consumer-example) you can find how to create producer and consumer in java. [Kafka Monitoring](https://dzone.com/articles/kafka-monitoring-with-burrow) In this article i have explained how to monitor kafka cluster.
