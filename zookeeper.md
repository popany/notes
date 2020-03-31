# zookeeper

- [zookeeper](#zookeeper)
  - [What is ZooKeeper?](#what-is-zookeeper)
    - [ZooKeeper Overview](#zookeeper-overview)
      - [ZooKeeper: A Distributed Coordination Service for Distributed Applications](#zookeeper-a-distributed-coordination-service-for-distributed-applications)
      - [Design Goals](#design-goals)
      - [Data model and the hierarchical namespace](#data-model-and-the-hierarchical-namespace)
      - [Nodes and ephemeral nodes](#nodes-and-ephemeral-nodes)
      - [Conditional updates and watches](#conditional-updates-and-watches)
      - [Guarantees](#guarantees)
      - [Simple API](#simple-api)
      - [Implementation](#implementation)
      - [Uses](#uses)
      - [Performance](#performance)
      - [Reliability](#reliability)
      - [The ZooKeeper Project](#the-zookeeper-project)
    - [ZooKeeper Getting Started Guide](#zookeeper-getting-started-guide)
      - [Getting Started: Coordinating Distributed Applications with ZooKeeper](#getting-started-coordinating-distributed-applications-with-zookeeper)
      - [Pre-requisites](#pre-requisites)
      - [Download](#download)
      - [Standalone Operation](#standalone-operation)
      - [Managing ZooKeeper Storage](#managing-zookeeper-storage)
      - [Connecting to ZooKeeper](#connecting-to-zookeeper)
      - [Programming to ZooKeeper](#programming-to-zookeeper)
      - [Running Replicated ZooKeeper](#running-replicated-zookeeper)
      - [Other Optimizations](#other-optimizations)
  - [zookeeper docker](#zookeeper-docker)
    - [zookeeper docker hub](#zookeeper-docker-hub)

## [What is ZooKeeper?](http://zookeeper.apache.org/)

ZooKeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these kinds of services are used in some form or another by distributed applications. Each time they are implemented there is a lot of work that goes into fixing the bugs and race conditions that are inevitable. Because of the difficulty of implementing these kinds of services, applications initially usually skimp on them, which make them brittle in the presence of change and difficult to manage. Even when done correctly, different implementations of these services lead to management complexity when the applications are deployed.

### [ZooKeeper Overview](http://zookeeper.apache.org/doc/current/index.html)

#### [ZooKeeper: A Distributed Coordination Service for Distributed Applications](http://zookeeper.apache.org/doc/current/zookeeperOver.html)

ZooKeeper is a distributed, open-source **coordination service** for distributed applications. It exposes a simple set of primitives that distributed applications can build upon to implement higher level services for **synchronization**, **configuration maintenance**, and **groups** and **naming**. It is designed to be easy to program to, and uses a **data model** styled after the *amiliar directory **tree structure** of file systems. It runs in Java and has bindings for both Java and C.

Coordination services are notoriously hard to get right. They are especially prone to errors such as race conditions and deadlock. The motivation behind ZooKeeper is to relieve distributed applications the responsibility of implementing coordination services from scratch.

#### Design Goals

- ZooKeeper is simple

    ZooKeeper allows distributed processes to coordinate with each other through a **shared hierarchical namespace** which is organized similarly to a standard file system. The name space consists of **data registers** - called **znodes**, in ZooKeeper parlance - and these are similar to files and directories. Unlike a typical file system, which is designed for storage, ZooKeeper data is kept **in-memory**, which means ZooKeeper can achieve high throughput and low latency numbers.

    The ZooKeeper implementation puts a premium on high performance, highly available, strictly ordered access. The performance aspects of ZooKeeper means it can be used in large, distributed systems. The reliability aspects keep it from being a single point of failure. The **strict ordering** means that sophisticated synchronization primitives can be implemented at the client.

- ZooKeeper is replicated

    Like the distributed processes it coordinates, ZooKeeper itself is intended to be replicated over a sets of hosts called an ensemble.

    The servers that make up the ZooKeeper service must all know about each other. They maintain an **in-memory image of state**, along with a **transaction logs** and **snapshots** in a persistent store. As long as a majority of the servers are available, the ZooKeeper service will be available.

    Clients connect to a single ZooKeeper server. The client maintains a TCP connection through which it **sends requests**, **gets responses**, **gets watch events**, and **sends heart beats**. If the TCP connection to the server breaks, the client will connect to a different server.

- ZooKeeper is ordered

    ZooKeeper stamps each update with a **number** that reflects the **order of all ZooKeeper transactions**. Subsequent operations can use the order to implement higher-level abstractions, such as synchronization primitives.

- ZooKeeper is fast

    It is especially fast in "read-dominant" workloads. ZooKeeper applications run on thousands of machines, and it performs best where reads are more common than writes, at ratios of around 10:1.

#### Data model and the hierarchical namespace

The name space provided by ZooKeeper is much like that of a standard file system. A name is a sequence of path elements separated by a slash (/). Every node in ZooKeeper's name space is identified by a path.

#### Nodes and ephemeral nodes

Unlike standard file systems, each node in a ZooKeeper namespace can have data associated with it as well as children. It is like having a file-system that allows a file to also be a directory. (ZooKeeper was designed to store **coordination data**: status information, configuration, location information, etc., so the data stored at each node is usually small, in the **byte to kilobyte range**.) We use the term **znode** to make it clear that we are talking about ZooKeeper data nodes.

Znodes maintain a stat structure that includes **version numbers** for **data changes**, **ACL changes**, and **timestamps**, to allow cache validations and coordinated updates. Each time a znode's data changes, the version number increases. For instance, whenever a client retrieves data it also receives the version of the data.

The data stored at each znode in a namespace is read and written **atomically**. Reads get all the data bytes associated with a znode and a write replaces all the data. Each node has an **Access Control List (ACL)** that restricts who can do what.

ZooKeeper also has the notion of **ephemeral nodes**. These znodes exists as long as the session that created the znode is active. When the session ends the znode is deleted. Ephemeral nodes are useful when you want to implement [tbd].

#### Conditional updates and watches

ZooKeeper supports the concept of watches. Clients can set a **watch** on a znode. A watch will be triggered and removed when the znode changes. When a watch is triggered, the client receives a packet saying that the znode has changed. If the connection between the client and one of the ZooKeeper servers is broken, the client will receive a local notification. These can be used to [tbd].

#### Guarantees

ZooKeeper is very fast and very simple. Since its goal, though, is to be a basis for the construction of more complicated services, such as synchronization, it provides a set of guarantees. These are:

- **Sequential Consistency** - Updates from a client will be applied in the order that they were sent.

- **Atomicity** - Updates either succeed or fail. No partial results.

- **Single System Image** - A client will see the same view of the service regardless of the server that it connects to.

- **Reliability** - Once an update has been applied, it will persist from that time forward until a client overwrites the update.

- **Timeliness** - The clients view of the system is guaranteed to be up-to-date within a certain time bound.

For more information on these, and how they can be used, see [tbd]

#### Simple API

One of the design goals of ZooKeeper is providing a very simple programming interface. As a result, it supports only these operations:

- **create** : creates a node at a location in the tree

- **delete** : deletes a node

- **exists** : tests if a node exists at a location

- **get data** : reads the data from a node

- **set data** : writes data to a node

- **get children** : retrieves a list of children of a node

- **sync** : waits for data to be propagated

For a more in-depth discussion on these, and how they can be used to implement higher level operations, please refer to [tbd]

#### Implementation

ZooKeeper Components shows the high-level components of the ZooKeeper service. With the exception of the request processor, each of the servers that make up the ZooKeeper service replicates its own copy of each of the components.

The replicated database is an **in-memory database containing the entire data tree**. **Updates are logged to disk** for recoverability, and **writes are serialized to disk** before they are applied to the in-memory database.

Every ZooKeeper server services clients. Clients connect to exactly one server to submit requests. Read requests are serviced from the local replica of each server database. Requests that change the state of the service, write requests, are processed by an **agreement protocol**.

As part of the **agreement protocol** all **write requests** from clients are forwarded to a single server, called the **leader**. The rest of the ZooKeeper servers, called **followers**, receive message proposals from the leader and agree upon message delivery. The **messaging layer** takes care of replacing leaders on failures and syncing followers with leaders.

ZooKeeper uses a custom **atomic messaging protocol**. Since the messaging layer is **atomic**, ZooKeeper can guarantee that the **local replicas never diverge**. When the leader receives a write request, it calculates what the state of the system is when the write is to be applied and transforms this into a transaction that captures this new state.

#### Uses

The programming interface to ZooKeeper is deliberately simple. With it, however, you can implement higher order operations, such as **synchronizations primitives**, **group membership**, **ownership**, etc. Some distributed applications have used it to: [tbd: add uses from white paper and video presentation.] For more information, see [tbd]

#### Performance

ZooKeeper is designed to be highly performance. But is it? The results of the ZooKeeper's development team at Yahoo! Research indicate that it is. (See [ZooKeeper Throughput as the Read-Write Ratio Varies](http://zookeeper.apache.org/doc/current/zookeeperOver.html#zkPerfRW).) It is especially high performance in applications where reads outnumber writes, since writes involve synchronizing the state of all servers. (**Reads outnumbering writes** is typically the case for a coordination service.)

#### Reliability

To show the behavior of the system over time as failures are injected we ran a ZooKeeper service made up of 7 machines. We ran the same saturation benchmark as before, but this time we kept the write percentage at a constant 30%, which is a conservative ratio of our expected workloads.

#### The ZooKeeper Project

ZooKeeper has been [successfully used](https://cwiki.apache.org/confluence/display/ZOOKEEPER/PoweredBy) in many industrial applications. It is used at Yahoo! as the coordination and failure recovery service for Yahoo! Message Broker, which is a highly scalable publish-subscribe system managing thousands of topics for replication and data delivery. It is used by the Fetching Service for Yahoo! crawler, where it also manages failure recovery. A number of Yahoo! advertising systems also use ZooKeeper to implement reliable services.
All users and developers are encouraged to join the community and contribute their expertise. See the [Zookeeper Project on Apache](http://zookeeper.apache.org/) for more information.

### [ZooKeeper Getting Started Guide](http://zookeeper.apache.org/doc/current/zookeeperStarted.html)

#### Getting Started: Coordinating Distributed Applications with ZooKeeper

This document contains information to get you started quickly with ZooKeeper. It is aimed primarily at developers hoping to try it out, and contains **simple installation instructions** for a **single ZooKeeper server**, a few commands to **verify that it is running**, and a **simple programming example**. Finally, as a convenience, there are a few sections regarding more complicated installations, for example **running replicated deployments**, and **optimizing the transaction log**. However for the complete instructions for commercial deployments, please refer to the [ZooKeeper Administrator's Guide](http://zookeeper.apache.org/doc/current/zookeeperAdmin.html).

#### Pre-requisites

See [System Requirements](http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_systemReq) in the Admin guide.

#### Download

To get a ZooKeeper distribution, download a recent [stable](http://zookeeper.apache.org/releases.html) release from one of the Apache Download Mirrors.

#### Standalone Operation

Setting up a ZooKeeper server in standalone mode is straightforward. The server is contained in a single JAR file, so installation consists of **creating a configuration**.

Once you've downloaded a stable ZooKeeper release unpack it and cd to the root

To start ZooKeeper you need a **configuration file**. Here is a sample, create it in `conf/zoo.cfg`:

    tickTime=2000
    dataDir=/var/lib/zookeeper
    clientPort=2181

**This file can be called anything**, but for the sake of this discussion call it `conf/zoo.cfg`. Change the value of `dataDir` to specify an existing (empty to start with) directory. Here are the meanings for each of the fields:

- **tickTime** : the basic **time unit** in milliseconds used by ZooKeeper. It is used to do **heartbeats** and the **minimum session timeout** will be twice the tickTime.

- **dataDir** : the location to store the **in-memory database snapshots** and, unless specified otherwise, the **transaction log** of updates to the database.

- **clientPort** : the port to listen for client connections

Now that you created the configuration file, you can start ZooKeeper:

    bin/zkServer.sh start

ZooKeeper logs messages using log4j -- more detail available in the [Logging](http://zookeeper.apache.org/doc/current/zookeeperProgrammers.html#Logging) section of the Programmer's Guide. You will see log messages coming to the console (default) and/or a log file depending on the log4j configuration.

The steps outlined here run ZooKeeper in standalone mode. There is no replication, so if ZooKeeper process fails, the service will go down. This is fine for most development situations, but to run ZooKeeper in replicated mode, please see [Running Replicated ZooKeeper](http://zookeeper.apache.org/doc/current/zookeeperStarted.html#sc_RunningReplicatedZooKeeper).

#### Managing ZooKeeper Storage

For long running production systems ZooKeeper storage must be managed externally (dataDir and logs). See the section on [maintenance](http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance) for more details.

#### Connecting to ZooKeeper

    bin/zkCli.sh -server 127.0.0.1:2181

This lets you perform simple, file-like operations.
Once you have connected, you should see something like:

    Connecting to localhost:2181
    log4j:WARN No appenders could be found for logger (org.apache.zookeeper.ZooKeeper).
    log4j:WARN Please initialize the log4j system properly.
    Welcome to ZooKeeper!
    JLine support is enabled
    [zkshell: 0]

From the shell, type help to get a listing of commands that can be executed from the client, as in:

    [zkshell: 0] help
    ZooKeeper host:port cmd args
        get path [watch]
        ls path [watch]
        set path data [version]
        delquota [-n|-b] path
        quit
        printwatches on|off
        create path data acl
        stat path [watch]
        listquota path
        history
        setAcl path acl
        getAcl path
        sync path
        redo cmdno
        addauth scheme auth
        delete path [version]
        deleteall path
        setquota -n|-b val path

From here, you can try a few simple commands to get a feel for this simple command line interface. First, start by issuing the list command, as in ls, yielding:

    [zkshell: 8] ls /
    [zookeeper]

Next, create a new znode by running create `/zk_test` `my_data`. This creates a new znode and associates the string "my_data" with the node. You should see:

    [zkshell: 9] create /zk_test my_data
    Created /zk_test

Issue another `ls /` command to see what the directory looks like:

    [zkshell: 11] ls /
    [zookeeper, zk_test]

Notice that the zk_test directory has now been created.
Next, verify that the data was associated with the znode by running the get command, as in:

    [zkshell: 12] get /zk_test
    my_data
    cZxid = 5
    ctime = Fri Jun 05 13:57:06 PDT 2009
    mZxid = 5
    mtime = Fri Jun 05 13:57:06 PDT 2009
    pZxid = 5
    cversion = 0
    dataVersion = 0
    aclVersion = 0
    ephemeralOwner = 0
    dataLength = 7
    numChildren = 0

We can change the data associated with zk_test by issuing the set command, as in:

    [zkshell: 14] set /zk_test junk
    cZxid = 5
    ctime = Fri Jun 05 13:57:06 PDT 2009
    mZxid = 6
    mtime = Fri Jun 05 14:01:52 PDT 2009
    pZxid = 5
    cversion = 0
    dataVersion = 1
    aclVersion = 0
    ephemeralOwner = 0
    dataLength = 4
    numChildren = 0
    [zkshell: 15] get /zk_test
    junk
    cZxid = 5
    ctime = Fri Jun 05 13:57:06 PDT 2009
    mZxid = 6
    mtime = Fri Jun 05 14:01:52 PDT 2009
    pZxid = 5
    cversion = 0
    dataVersion = 1
    aclVersion = 0
    ephemeralOwner = 0
    dataLength = 4
    numChildren = 0

(Notice we did a get after setting the data and it did, indeed, change.
Finally, let's delete the node by issuing:

    [zkshell: 16] delete /zk_test
    [zkshell: 17] ls /
    [zookeeper]
    [zkshell: 18]

That's it for now. To explore more, continue with the rest of this document and see the [Programmer's Guide](http://zookeeper.apache.org/doc/current/zookeeperProgrammers.html).

#### Programming to ZooKeeper

ZooKeeper has a Java bindings and C bindings. They are functionally equivalent. The C bindings exist in two variants: single threaded and multi-threaded. These differ only in how the messaging loop is done. For more information, see the [Programming Examples in the ZooKeeper Programmer's Guide](http://zookeeper.apache.org/doc/current/zookeeperProgrammers.html#ch_programStructureWithExample) for sample code using of the different APIs.

#### Running Replicated ZooKeeper

Running ZooKeeper in standalone mode is convenient for evaluation, some development, and testing. But in production, you should run ZooKeeper in replicated mode. A replicated group of servers in the same application is called a **quorum**, and in replicated mode, all servers in the quorum have copies of the **same configuration file**.

NOTE:  
For replicated mode, a minimum of three servers are required, and it is strongly recommended that you have an odd number of servers. If you only have two servers, then you are in a situation where if one of them fails, there are not enough machines to form a majority quorum. Two servers is inherently less stable than a single server, because there are two single points of failure.

The required `conf/zoo.cfg` file for replicated mode is similar to the one used in standalone mode, but with a few differences. Here is an example:

    tickTime=2000
    dataDir=/var/lib/zookeeper
    clientPort=2181
    initLimit=5
    syncLimit=2
    server.1=zoo1:2888:3888
    server.2=zoo2:2888:3888
    server.3=zoo3:2888:3888

The new entry, **initLimit** is timeouts ZooKeeper uses to limit the length of time the ZooKeeper servers in quorum have to **connect to a leader**. The entry **syncLimit** limits how far out of date a server can be from a leader.

With both of these timeouts, you specify the **unit of time** using **tickTime**. In this example, the timeout for initLimit is 5 ticks at 2000 milleseconds a tick, or 10 seconds.

The entries of the form `server.X` list the servers that make up the ZooKeeper service. When the server starts up, it knows which server it is by looking for the file `myid` in the data directory. That file has the contains the server number, in ASCII.

Finally, note the **two port** numbers after each server name: "2888" and "3888". Peers use the former port to **connect to other peers**. Such a connection is necessary so that peers can communicate, for example, to agree upon the order of updates. More specifically, a ZooKeeper server uses this port to connect followers to the leader. When a new leader arises, a follower opens a TCP connection to the leader using this port. Because the default leader election also uses TCP, we currently require another port for **leader election**. This is the second port in the server entry.

NOTE:  
If you want to test multiple servers on a single machine, specify the servername as localhost with unique quorum & leader election ports (i.e. 2888:3888, 2889:3889, 2890:3890 in the example above) for each server.X in that server's config file. Of course separate _dataDir_s and distinct _clientPort_s are also necessary (in the above replicated example, running on a single localhost, you would still have three config files).  
Please be aware that setting up multiple servers on a single machine will not create any redundancy. If something were to happen which caused the machine to die, all of the zookeeper servers would be offline. Full redundancy requires that each server have its own machine. It must be a completely separate physical server. Multiple virtual machines on the same physical host are still vulnerable to the complete failure of that host.

#### Other Optimizations

There are a couple of other configuration parameters that can greatly increase performance:

To get low latencies on updates it is important to have a dedicated transaction log directory. By default transaction logs are put in the same directory as the data snapshots and myid file. The dataLogDir parameters indicates a different directory to use for the transaction logs.

[tbd: what is the other config param?]

## zookeeper docker

### [zookeeper docker hub](https://hub.docker.com/_/zookeeper/)





























