# [Apache Curator](https://curator.apache.org/)

- [Apache Curator](#apache-curator)
  - [What is Curator?](#what-is-curator)
  - [Maven / Artifacts](#maven--artifacts)
  - [Getting Started](#getting-started)
    - [Using Curator](#using-curator)
    - [Getting a Connection](#getting-a-connection)
    - [Calling ZooKeeper Directly](#calling-zookeeper-directly)
    - [Recipes](#recipes)
      - [Distributed Lock](#distributed-lock)
      - [Leader Election](#leader-election)
  - [Examples](#examples)
  - [Recipes](#recipes-1)
    - [Elections](#elections)
    - [Locks](#locks)
    - [Barriers](#barriers)
    - [Counters](#counters)
    - [Caches](#caches)
    - [Nodes/Watches](#nodeswatches)
    - [Queues](#queues)

## What is Curator?

Apache Curator is a Java/JVM client library for Apache ZooKeeper, a distributed coordination service. It includes a highlevel API framework and utilities to make using Apache ZooKeeper much easier and more reliable. It also includes recipes for common use cases and extensions such as service discovery and a Java 8 asynchronous DSL.

## Maven / Artifacts

|GroupID/Org|ArtifactID/Name|Description|
|-|-|-|
org.apache.curator|curator-recipes|All of the recipes. Note: this artifact has dependencies on client and framework and, so, Maven (or whatever tool you're using) should pull those in automatically.
org.apache.curator|curator-async|Asynchronous DSL with O/R modeling, migrations and many other features.
org.apache.curator|curator-framework|The Curator Framework high level API. This is built on top of the client and should pull it in automatically.
org.apache.curator|curator-client|The Curator Client - replacement for the ZooKeeper class in the ZK distribution.
org.apache.curator|curator-test|Contains the TestingServer, the TestingCluster and a few other tools useful for testing.
org.apache.curator|curator-examples|Example usages of various Curator features.
org.apache.curator|curator-x-discovery|A Service Discovery implementation built on the Curator Framework.
org.apache.curator|curator-x-discovery-server|A RESTful server that can be used with Curator Discovery.
||||

## [Getting Started](https://curator.apache.org/getting-started.html)

### Using Curator

The Curator JARs are available from Maven Central. The various artifacts are listed on the [main page](https://curator.apache.org/index.html). Users of Maven, Gradle, Ant, etc. can easily include Curator into their build script.

Most users will want to use one of Curator's pre-built recipes. So, the curator-recipes is the correct artifact to use. If you only want a wrapper around ZooKeeper that adds **connection management** and **retry policies**, use **curator-framework**.

### Getting a Connection

Curator uses [Fluent Style](https://en.wikipedia.org/wiki/Fluent_interface).

Curator connection instances (`CuratorFramework`) are allocated from the `CuratorFrameworkFactory`. You only need **one** `CuratorFramework` object for each ZooKeeper cluster you are connecting to:

    CuratorFrameworkFactory.newClient(zookeeperConnectionString, retryPolicy)

This will create a connection to a ZooKeeper cluster using default values. The only thing that you need to specify is the **retry policy**. For most cases, you should use:

    RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 3)
    CuratorFramework client = CuratorFrameworkFactory.newClient(zookeeperConnectionString, retryPolicy);
    client.start();

The client must be started (and closed when no longer needed).

### Calling ZooKeeper Directly

Once you have a CuratorFramework instance, you can make direct calls to ZooKeeper in a similar way to using the raw `ZooKeeper` object provided in the ZooKeeper distribution. E.g.:

    client.create().forPath("/my/path", myData)

The benefit here is that Curator manages the ZooKeeper connection and will retry operations if there are connection problems.

### Recipes

#### Distributed Lock

    InterProcessMutex lock = new InterProcessMutex(client, lockPath);
    if ( lock.acquire(maxWait, waitUnit) ) 
    {
        try 
        {
            // do some work inside of the critical section here
        }
        finally
        {
            lock.release();
        }
    }

#### Leader Election

    LeaderSelectorListener listener = new LeaderSelectorListenerAdapter()
    {
        public void takeLeadership(CuratorFramework client) throws Exception
        {
            // this callback will get called when you are the leader
            // do whatever leader work you need to and only exit
            // this method when you want to relinquish leadership
        }
    }

    LeaderSelector selector = new LeaderSelector(client, path, listener);
    selector.autoRequeue();  // not required, but this is behavior that you will probably expect
    selector.start();

## [Examples](https://curator.apache.org/curator-examples/index.html)

This module contains example usages of various Curator features. Each directory in the module is a separate example.

|||
|-|-|
/leader|Example leader selector code
/cache|Example CuratorCache usage
/locking|Example of using InterProcessMutex
/discovery|Example usage of the Curator's ServiceDiscovery
/framework|A few examples of how to use the CuratorFramework class
/async|Example AsyncCuratorFramework code
/modeled|ModeledFramework and Modeled Cache examples
|||

See the [examples source repo](https://github.com/apache/curator/tree/master/curator-examples/src/main/java) for each example.

## [Recipes](https://curator.apache.org/curator-recipes/index.html)

Curator implements all of the recipes listed on the ZooKeeper recipes doc (except two phase commit). Click on the recipe name below for detailed documentation. NOTE: Most Curator recipes will autocreate parent nodes of paths given to the recipe as CreateMode.CONTAINER. Also, see [Tech Note 7](https://cwiki.apache.org/confluence/display/CURATOR/TN7) regarding "Curator Recipes Own Their ZNode/Paths".

### Elections

[Leader Latch](https://curator.apache.org/curator-recipes/leader-latch.html) - In distributed computing, leader election is the process of designating a single process as the organizer of some task distributed among several computers (nodes). Before the task is begun, all network nodes are unaware which node will serve as the "leader," or coordinator, of the task. After a leader election algorithm has been run, however, each node throughout the network recognizes a particular, unique node as the task leader.

[Leader Election](https://curator.apache.org/curator-recipes/leader-election.html) - Initial Curator leader election recipe.

### Locks

[Shared Reentrant Lock](https://curator.apache.org/curator-recipes/shared-reentrant-lock.html) - Fully distributed locks that are globally synchronous, meaning at any snapshot in time no two clients think they hold the same lock.

[Shared Lock](https://curator.apache.org/curator-recipes/shared-lock.html) - Similar to Shared Reentrant Lock but not reentrant.

[Shared Reentrant Read Write Lock](https://curator.apache.org/curator-recipes/shared-reentrant-read-write-lock.html) - A re-entrant read/write mutex that works across JVMs. A read write lock maintains a pair of associated locks, one for read-only operations and one for writing. The read lock may be held simultaneously by multiple reader processes, so long as there are no writers. The write lock is exclusive.

[Shared Semaphore](https://curator.apache.org/curator-recipes/shared-semaphore.html) - A counting semaphore that works across JVMs. All processes in all JVMs that use the same lock path will achieve an inter-process limited set of leases. Further, this semaphore is mostly "fair" - each user will get a lease in the order requested (from ZK's point of view).

[Multi Shared](https://curator.apache.org/curator-recipes/multi-shared-lock.html) Lock - A container that manages multiple locks as a single entity. When acquire() is called, all the locks are acquired. If that fails, any paths that were acquired are released. Similarly, when release() is called, all locks are released (failures are ignored).

### Barriers

[Barrier](https://curator.apache.org/curator-recipes/barrier.html) - Distributed systems use barriers to block processing of a set of nodes until a condition is met at which time all the nodes are allowed to proceed.

[Double Barrier](https://curator.apache.org/curator-recipes/double-barrier.html) - Double barriers enable clients to synchronize the beginning and the end of a computation. When enough processes have joined the barrier, processes start their computation and leave the barrier once they have finished.

### Counters

[Shared Counter](https://curator.apache.org/curator-recipes/shared-counter.html) - Manages a shared integer. All clients watching the same path will have the up-to-date value of the shared integer (considering ZK's normal consistency guarantees).

[Distributed Atomic Long](https://curator.apache.org/curator-recipes/distributed-atomic-long.html) - A counter that attempts atomic increments. It first tries using optimistic locking. If that fails, an optional InterProcessMutex is taken. For both optimistic and mutex, a retry policy is used to retry the increment.

### Caches

[Curator Cache](https://curator.apache.org/curator-recipes/curator-cache.html) - A utility that attempts to keep the data from a node locally cached. Optionally the entire tree of children below the node can also be cached. Will respond to update/create/delete events, pull down the data, etc. You can **register listeners** that will get notified when changes occur.

[Path Cache](https://curator.apache.org/curator-recipes/path-cache.html) - (For preZooKeeper 3.6.x) A Path Cache is used to watch a ZNode. Whenever a child is added, updated or removed, the Path Cache will change its state to contain the current set of children, the children's data and the children's state. Path caches in the Curator Framework are provided by the PathChildrenCache class. Changes to the path are passed to registered PathChildrenCacheListener instances.

[Node Cache](https://curator.apache.org/curator-recipes/node-cache.html) - (For preZooKeeper 3.6.x) A utility that attempts to keep the data from a node locally cached. This class will watch the node, respond to update/create/delete events, pull down the data, etc. You can register a listener that will get notified when changes occur.

[Tree Cache](https://curator.apache.org/curator-recipes/tree-cache.html) - (For preZooKeeper 3.6.x) A utility that attempts to keep all data from all children of a ZK path locally cached. This class will watch the ZK path, respond to update/create/delete events, pull down the data, etc. You can register a listener that will get notified when changes occur.

### Nodes/Watches

[Persistent Recursive Watcher](https://curator.apache.org/curator-recipes/persistent-watcher.html) - A managed persistent recursive watcher. The watch will be managed such that it stays set through connection lapses, etc.

[Persistent Node](https://curator.apache.org/curator-recipes/persistent-node.html) - A node that attempts to stay present in ZooKeeper, even through connection and session interruptions.

[Persistent TTL Node](https://curator.apache.org/curator-recipes/persistent-ttl-node.html) - Useful when you need to create a TTL node but don't want to keep it alive manually by periodically setting data.

[Group Member](https://curator.apache.org/curator-recipes/group-member.html) - Group membership management. Adds this instance into a group and keeps a cache of members in the group.

### Queues

[Distributed Queue](https://curator.apache.org/curator-recipes/distributed-queue.html) - An implementation of the Distributed Queue ZK recipe. Items put into the queue are guaranteed to be ordered (by means of ZK's PERSISTENTSEQUENTIAL node). If a single consumer takes items out of the queue, they will be ordered FIFO. If ordering is important, use a LeaderSelector to nominate a single consumer.

[Distributed Id Queue](https://curator.apache.org/curator-recipes/distributed-id-queue.html) - A version of DistributedQueue that allows IDs to be associated with queue items. Items can then be removed from the queue if needed.

[Distributed Priority Queue](https://curator.apache.org/curator-recipes/distributed-priority-queue.html) - An implementation of the Distributed Priority Queue ZK recipe.

[Distributed Delay Queue](https://curator.apache.org/curator-recipes/distributed-delay-queue.html) - An implementation of a Distributed Delay Queue.

[Simple Distributed Queue](https://curator.apache.org/curator-recipes/simple-distributed-queue.html) - A drop-in replacement for the DistributedQueue that comes with the ZK distribution.
