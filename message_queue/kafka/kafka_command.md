# kafka command

- [kafka command](#kafka-command)
  - [创建 topic](#创建-topic)
  - [查看 topic](#查看-topic)
  - [用 console-producer 生产消息](#用-console-producer-生产消息)
  - [用 console-consumer 消费消息](#用-console-consumer-消费消息)

## 创建 topic

    ./kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test1

## 查看 topic

    ./kafka-topics.sh --list --zookeeper localhost:2181

## 用 console-producer 生产消息

    ./kafka-console-producer.sh --broker-list localhost:9092 --topic test1

## 用 console-consumer 消费消息

    ./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test1 --from-beginning
