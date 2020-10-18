# [Kafka Internals: FAQs](https://dzone.com/articles/kafka-internals-faq)

- [Kafka Internals: FAQs](#kafka-internals-faqs)

- Is there chance that a consumer can read from more than one partition in a topic?

  Yes, of course. If the number of consumers is less than the number of partitions in the topic.

- What is the optimal number of consumers in a group for a topic?

  As many as the number of partitions.

- Is there a chance for a consumer to be idle?

  Yes, if the number of live consumers in a group is larger than the number of partitions. These idle consumers will be leveraged when a consumer crashes.

- Does the Kafka broker retain messages until they are consumed by all subscribers?

  No, it is the consumer's responsibility to consume messages when they are available in a topic.

  It is analogous to subscribing and watching content from satellite channel. The subscriber should tune to the channel while the content is being played to watch.
