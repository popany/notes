# [Kafka Internals: Topics and Partitions](https://dzone.com/articles/kafka-internals-topic-partitions)

- [Kafka Internals: Topics and Partitions](#kafka-internals-topics-and-partitions)
  - [Topic](#topic)
  - [Partition](#partition)
    - [Let’s discuss time complexity of finding a message in a topic given its partition and offset](#lets-discuss-time-complexity-of-finding-a-message-in-a-topic-given-its-partition-and-offset)
  - [Replication](#replication)
  - [Parallelism With Partitions](#parallelism-with-partitions)

## Topic

A topic is a logical grouping of Partitions.

## Partition

A partition is an actual **storage unit** of Kafka messages which can be assumed as a **Kafka message queue**. The number of partitions per topic are configurable while creating it. Messages in a partition are segregated into multiple segments to ease finding a message by its offset. The default size of a segment is very high, i.e. 1GB, which can be configured. Each segment is composed of the following files:

- Log: messages are stored in this file.

- Index: stores message offset and its starting position in the log file.

- Timeindex: not relevant to the discussion.

Let’s imagine there are 6 messages in a partition and that a segment size is configured such that it can contain only three messages (for the sake of explanation). Thus the Partition contains theess segments as follows:

- Segment – 00 contains 00.log, 00.index and 00.timeindex files

- Segment – 03 contains 03.log, 03.index and 03.timeindex files

- Segment – 06 contains 06.log, 06.index and 06.timeindex files

The segment name indicates the offset of the first message in the segment.

Sample log file:

    Starting offset: 0
    ​
    offset: 0 position: 0 CreateTime: 1533443377944 isvalid: true keysize: -1 valuesize: 11 producerId: -1 headerKeys: [] payload: Hello World
    offset: 1 position: 79 CreateTime: 1533462689974 isvalid: true keysize: -1 valuesize: 6 producerId: -1 headerKeys: [] payload: intuit

Sample index file:

    offset: 0 position: 0
    offset: 2 position: 79

### Let’s discuss time complexity of finding a message in a topic given its partition and offset

||||
|-|-|-|
Step|Complexity|How
Find partition|O(1)|The broker knows the partition is located in a given partition name.
Find segment in partition|O(log (SN, 2)) where SN is the number of segments in the partition.|The segment's log file name indicates the first message offset so it can find the right segment using a binary search for a given offset.
Find message in segment|O(log  (MN, 2)) where MN is the number of messages in the log file.|The index file contains the exact position of a message in the log file for all the messages in ascending order of the offsets. So, the offset can be searched using a binary search.
||||

So total complexity is O(1) + O(log (SN, 2)) + O(log  (MN, 2)).

## Replication

A topic replication factor is configurable while creating it. Assume there are two brokers in a broker cluster and a topic, `freblogg`, is created with a replication factor of `2`.

Among the multiple partitions, there is one `leader` and remaining are `replicas/followers` to serve as back up. Kafka always allows consumers to read only from the leader partition. A leader and follower of a partition can never reside on the same broker for obvious reasons. Followers are always sync with a leader. The broker chooses a new leader among the followers when a leader goes down. A topic is distributed across broker clusters as **each partition in the topic resides on different brokers in the cluster**.

## Parallelism With Partitions

Kafka allows only one consumer from a consumer group to consume messages from a partition to guarantee the order of reading messages from a partition. So, it's important point to note that the order of message consumption is not guaranteed at the topic level.To increase consumption, parallelism is required to increase partitions and spawn consumers accordingly.
