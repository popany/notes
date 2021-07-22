# zookeeper

- [zookeeper](#zookeeper)
  - [ZooKeeper-cli: the ZooKeeper command line interface](#zookeeper-cli-the-zookeeper-command-line-interface)
  - [What does the default zookeeper watcher do?](#what-does-the-default-zookeeper-watcher-do)

## [ZooKeeper-cli: the ZooKeeper command line interface](https://zookeeper.apache.org/doc/r3.6.2/zookeeperCLI.html)

## [What does the default zookeeper watcher do?](https://stackoverflow.com/questions/30432772/what-does-the-default-zookeeper-watcher-do)

If pass true for watch if the data of the znode changes, or the znode is deleted an event will be sent to the client. The client will invoke the default watcher (that you pass to construct the Zookeeper client object) object's process method will be called. process method is passed the WatchedEvent object. We may get eventType, the znode path (if the event is specific to the znode) etc. from the event object. If event type is something like "NodeDataChanged" for example, a call may be be made to Zookeeper to get the modified data and re-establish the watch. Basically, The default watcher implements the "process" method, and the "process" method has the logic about what to do with the event.
