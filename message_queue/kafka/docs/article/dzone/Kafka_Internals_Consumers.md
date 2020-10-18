# [Kafka Internals: Consumers](https://dzone.com/articles/kafka-internals-consumer)

- [Kafka Internals: Consumers](#kafka-internals-consumers)
  - [Consumption Semantics](#consumption-semantics)
    - [Consume at Least Once](#consume-at-least-once)
    - [Consume at Most Once](#consume-at-most-once)
    - [Consume Almost Once](#consume-almost-once)
    - [Consume Exactly Once](#consume-exactly-once)
    - [Consumer Liveliness](#consumer-liveliness)

Check out my last article, [Kafka Internals: Topics and Partitions](https://dzone.com/articles/kafka-internals-topic-partitions?preview=true) to learn about Kafka storage internals.

In Kafka, each topic is divided into set of partitions. Producers write messages to the tail of the partitions and consumers read them at their own pace. Kafka scales topic consumption by distributing partitions among a consumer group, which is a set of consumers sharing a common group identifier. The following diagram depicts a single topic with three partitions and a consumer group with two members.

![fig1](./fig/Kafka_Internals_Consumers/New_Consumer_figure_1.png)

For each consumer group, a broker is chosen as a group coordinator. The group coordinator is responsible for:

- managing consumer group state.

- assigning a partition to a consumer when:

  - a new consumer is spawned.

  - an old consumer goes down.

  - a topic meta data changes.

The process of **reassigning** partitions to consumers is called **consumer group rebalancing**.

When a group is first connected to a broker:

- consumers start reading from either the **earliest** or **latest** offset in each partition based on the configuration `auto.offset.reset`.

- messages in each partition are then read **sequentially**.

- the **consumer commits the offsets** of messages it has successfully processed.

In the following figure, the consumer’s position is at offset 6 and its last committed offset is at offset 1.

![fig2](./fig/Kafka_Internals_Consumers/New_Consumer_figure_2.png)

When a consumer group is rebalanced, a new consumer is assigned to a partition.

- It starts reading **from the last committed** offset.

- It **reprocesses** some messages if the old consumer has processed some messages but crashed before committing the offset of the processed messages.

In the above diagram, if the current consumer crashes and then the new consumer starts consuming from offset 1 and reprocesses messages until offset 6. Other markings in the above diagram are:

- **Log end offset** is the offset of the last message written to the partition.

- **High watermark** is the offset of the last message that was successfully replicated to all partition replicas.

Kafka ensures that the consumer **can read only up to the high watermark** for obvious reasons.

The consumer reads messages in parallel from different partitions from different topics spread across brokers using the `KafkaConsumer.poll` method in an event loop. The same method is used by Kafka to coordinate and rebalance a consumer group.

Let's discuss how to implement different consumption semantics and then understand how Kafka leverages the poll method to coordinate and rebalance a consumer group.

Here's some sample auto commit consumer code:

    /** 
    this is code for offset auto commit i.e. Kafka Consumer library commits offset till the messages fetched in the poll call automatically after configfured timeout for every poll
    **/
    public class ConsumerLoop implements Runnable {
        private final KafkaConsumer<String, String> consumer;
        private final List<String> topics;
        private final int id;
    ​
        public ConsumerLoop(int id,
            String groupId,
            List<String> topics) {
            this.id = id;
            this.topics = topics;
            Properties props = new Properties();
            props.put("bootstrap.servers", "localhost:9092");
            props.put(“group.id”, groupId);
            props.put(“key.deserializer”, StringDeserializer.class.getName());
            props.put(“value.deserializer”, StringDeserializer.class.getName());
            this.consumer = new KafkaConsumer<>(props);
        }
    ​
        @Override
        public void run() {
            try {
                // 1. Subscribe to topics
                consumer.subscribe(topics);
                // 2. start event loop
                while (true) {
                    // 3. blocking poll call
                    ConsumerRecords<String, String> records = consumer.poll(Long.MAX_VALUE);
                    // 4. Process fetched message records
                    processMessages(records);
                }
            } catch (WakeupException e) {
                // ignore for shutdown 
            } finally {
                // 6. close consumer
                consumer.close();
            }
        }
​
        public void shutdown() {
            consumer.wakeup();
        }
​
        public void processMessages(ConsumerRecords<String, String> records) {
            for (ConsumerRecord<String, String> record: records) {
                Map<String, Object> data = new HashMap<>();
                data.put("partition", record.partition());
                data.put("offset", record.offset());
                data.put("value", record.value());
                System.out.println(this.id + ": " + data);
            }
        }
    }

If a consumer crashes before the commit offsets successfully processed messages, then a new consumer for the partition repeats the processing of the uncommitted messages that were processed. Frequent commits mitigate the number of duplicates after a rebalance/crash. In the above example code, the Kafka consumer library automatically commits based on the configured auto.commit.interval.ms value and reducing the value increases the frequency of commits.

Certain applications may choose to manually commit for better management of message consumption, so let's discuss different strategies for manual commits. For manual commits, we need to set `auto.commit.enable` to false and use `KafkaConsumer.commitSync` appropriately in the event loop.

## Consumption Semantics

### Consume at Least Once

    // 2. start event loop
    while (true) {
        // 3. blocking poll call
        ConsumerRecords<String, String> records = consumer.poll(Long.MAX_VALUE);
        // 4. Process fetched message records
        processMessages(records);
        // 5. Commit after processing messages
        try {
            consumer.commitSync();
        } catch (CommitFailedException e) {
            // application specific failure handling
        }
    }

The following diagram depicts partition traversal by a consumer from the above code:

![fig2](./fig/Kafka_Internals_Consumers/New_Consumer_figure_2.png)

The above code commits an offset after processing the fetched messages, so if the consumer crashes before committing then the newly chosen consumer has to repeat the processing of the messages though they are processed by the old consumer but failed to commit.

Note that auto commit ensures 'at least once consumption' as the commit is automatically done only after messages are fetched by the  poll method.

### Consume at Most Once

    // 2. start event loop
    while (true) {
        // 3. blocking poll call
        ConsumerRecords<String, String> records = consumer.poll(Long.MAX_VALUE);
        // 4. Commit after processing messages
        try {
            consumer.commitSync();
        } catch (CommitFailedException e) {
            // application specific failure handling
        }
        // 5. Process fetched message records
        processMessages(records);
    }

The following diagram depicts the partition traversal by the consumer performed in the above code:

![fig3](./fig/Kafka_Internals_Consumers/New_Consumer_figure_3.png)

The above code commits an offset before processing the fetched messages, so if the consumer crashes before processing any committed messages then all such messages are literally lost as the newly chosen consumer starts from the last committed offset, which is ahead of the last processed message offset.

### Consume Almost Once

    try {
        // 2. start event loop
        while (running) {
        // 3. poll for messages
        ConsumerRecords<String, String> records = consumer.poll(1000);
        ​
            try {
                // 4. iterate each message
                for (ConsumerRecord<String, String> record: records) {
                    System.out.println(record.offset() + ": " + record.value());
                    // 5. commit message that is just processed
                    consumer.commitSync(Collections.singletonMap(record.partition(), new OffsetAndMetadata(record.offset() + 1)));
                }
            } catch (CommitFailedException e) {
                // application specific failure handling
            }
        }
    } finally {
        consumer.close();
    }

The above code iterates over messages and commits each message before immediately processing it. So, if the consumer crashes:

- after committing a message then the new consumer will not repeat the message.

- while processing/committing a message a new consumer has to repeat the only message that was being processed when the consumer crashed as the last commit offset.

`commitSync` is a blocking IO call so a consumption strategy should be based on application use case as it effects throughput of the message processing rate. To avoid blocking a commit, `commitAsync` can be used.

    try {
        // 2. start event loop
        while (running) {
            // 3. poll for messages
            ConsumerRecords<String, String> records = consumer.poll(1000);
            // 4. iterate each message
            for (ConsumerRecord<String, String>; record: records) {
                // process message
                processMessage(record);
                Map<TopicPartition, OffsetAndMetadata> offsets = prepareCommitOffsetFor(record);
                consumer.commitAsync(Map<TopicPartition, OffsetAndMetadata> offsets, new OffsetCommitCallback() {
                    @Override
                    public void onComplete(Map<TopicPartition, OffsetAndMetadata> offsets, Exception exception) {
                        if (exception != null) {
                            // application specific failure handling
                        }
                    }
                });
            }
        }
    } finally {
        consumer.close();
    }

Note that, if the commit of any message fails it will lead to one of the following:

- duplicate consumption - if the consumer crashes before the next successful commit and the new consumer starts processing from the last committed offset.

- no duplication - if the consumer successfully commits subsequent messages and crashes.

So, this approach provides more throughput than commitSync.

### Consume Exactly Once

As discussed above, in any case there is te possibility of reading a message more than once. Thus it is **not possible** to **Consume Exactly Once** with only Kafka APIs. But, it is certainly possible to achieve 'process exactly once,' though the message will be consumed more than once. This is demosntrated in the below code:

    try {
        // 2. start event loop
        while (running) {
            // 3. poll for messages
            ConsumerRecords<String, String> records = consumer.poll(1000);
            // 4. iterate each message
            for (ConsumerRecord<String, String> record: records) {
                // if message is already processed, skip processing
                if (isMessageProcessedAlready(record.offset(), record.partition(), record.topic)) {
                    commitOffsetForRecord(record);
                    continue;
                }
                // process message
                processMessage(record);
                // now persist offset, partition and topic of the message i.e.
                // processd just now
                persistProcessedMessageDetails(record.offset(), record.partition(), record.topic);
                commitOffsetForRecord(record);
            }
        }
    } finally {
        consumer.close();
    }
​
    // commit logic
    private void commitOffsetForRecord(ConsumerRecord record) {
        Map<TopicPartition, OffsetAndMetadata> offsets = prepareCommitOffsetFor(record);
        consumer.commitAsync(Map<TopicPartition, OffsetAndMetadata> offsets, new OffsetCommitCallback() {
            @Override
            public void onComplete(Map<TopicPartition, OffsetAndMetadata> offsets, Exception exception) {
                if (exception != null) {
                    // application specific failure handling
                }
            }
        });
    }

Note that the above code eliminates duplicate processing as:

- Processed message details are persisted (line 17).

- Message is already processed (line 9).

  - Message offset is commited as an old consumer would have failed to commit the message after successfully processing it, so it has reconsumed/commited it (line 10).  

  - Message processing is skipped (line 11).  

### Consumer Liveliness

Let's discuss how a group coordinator coordinates a consumer group.

Each consumer in a group is **assigned to a subset of the partitions** from topics it has subscribed to. This is basically a group lock on the partitions. As long as the lock is held, **no other consumer in the group can read messages from the partitions**. This is the way to avoid duplicate consumption when a consumer assigned to a partition is alive and holding the lock. But if the consumer dies/crashes, the lock needs to be released so that other live consumers can be assigned the partitions. The Kafka group coordination protocol accomplishes this using a **heartbeat mechanism**.

All live consumer group members send periodic heartbeat signals to the group coordinator. As long as the coordinator receives heartbeats, it assumes that members are live. On every received heartbeat, the coordinator starts (or resets) a `timer`. If no heartbeat is received when the timer expires, the coordinator marks the consumer dead and signals other consumers in the group that they should rejoin so that partitions can be reassigned. The duration of the timer can be configured using `session.timeout.ms`.

What if the consumer is still sending heartbeats to the coordinator but the application is not healthy such that it cannot process message it has consumed. Kafka solves the problem with a poll loop design. All network IO is done in the foreground when you call poll or one of the other blocking APIs. The **consumer does not use background threads** so **heartbeats are only sent to the coordinator when the consumer calls poll**. If the application stops polling (whether that's because the processing code has thrown an exception or not), then no heartbeats will be sent, the session timeout will expire, and the group will be rebalanced. The only problem with this is that a **spurious rebalance** might be performed if the consumer takes longer than the session timeout to process messages (such as the `processMessage` method in the above code samples). So, the session timeout should be large enough to mitigate this. The default session timeout is 30 seconds, but it’s not unreasonable to set it as high as several minutes. The only problem of a larger session timeout is that the coordinator takes longer to detect consumer crashes.
