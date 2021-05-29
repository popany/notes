# ZooKeeper Distributed process coordination

- [ZooKeeper Distributed process coordination](#zookeeper-distributed-process-coordination)
  - [CHAPTER 1 Introduction](#chapter-1-introduction)
    - [The ZooKeeper Mission](#the-zookeeper-mission)
      - [How the World Survived without ZooKeeper](#how-the-world-survived-without-zookeeper)
      - [What ZooKeeper Doesn't Do](#what-zookeeper-doesnt-do)
      - [The Apache Project](#the-apache-project)
      - [Building Distributed Systems with ZooKeeper](#building-distributed-systems-with-zookeeper)
    - [Example: Master-Worker Application](#example-master-worker-application)
      - [Master Failures](#master-failures)
      - [Worker Failures](#worker-failures)
      - [Communication Failures](#communication-failures)
      - [Summary of Tasks](#summary-of-tasks)
    - [Why Is Distributed Coordination Hard?](#why-is-distributed-coordination-hard)
    - [ZooKeeper Is a Success, with Caveats](#zookeeper-is-a-success-with-caveats)
  - [CHAPTER 2 Getting to Grips with ZooKeeper](#chapter-2-getting-to-grips-with-zookeeper)
    - [ZooKeeper Basics](#zookeeper-basics)
      - [API Overview](#api-overview)
      - [Different Modes for Znodes](#different-modes-for-znodes)
        - [Persistent and ephemeral znodes](#persistent-and-ephemeral-znodes)
        - [Sequential znodes](#sequential-znodes)
      - [Watches and Notifications](#watches-and-notifications)
      - [Versions](#versions)
    - [ZooKeeper Architecture](#zookeeper-architecture)
      - [ZooKeeper Quorums](#zookeeper-quorums)
      - [Sessions](#sessions)
    - [Getting Started with ZooKeeper](#getting-started-with-zookeeper)
      - [First ZooKeeper Session](#first-zookeeper-session)
      - [States and the Lifetime of a Session](#states-and-the-lifetime-of-a-session)
      - [ZooKeeper with Quorums](#zookeeper-with-quorums)
      - [Implementing a Primitive: Locks with ZooKeeper](#implementing-a-primitive-locks-with-zookeeper)
    - [Implementation of a Master-Worker Example](#implementation-of-a-master-worker-example)
      - [The Master Role](#the-master-role)
      - [Workers, Tasks, and Assignments](#workers-tasks-and-assignments)
      - [The Worker Role](#the-worker-role)
      - [The Client Role](#the-client-role)
    - [Takeaway Messages](#takeaway-messages)
  - [CHAPTER 3 Getting Started with the ZooKeeper API](#chapter-3-getting-started-with-the-zookeeper-api)

## CHAPTER 1 Introduction

### The ZooKeeper Mission

- What zookeeper can do

  It enables coordination tasks for distributed systems

- Coordination task

  - A coordination task is a task involving multiple processes

  - Cooperation means that

    - processes need to do something together,

    - and processes take action to enable other processes to make progress

- What ZooKeeper API provides

  - Strong consistency, ordering, and durability guarantees

  - The ability to implement typical synchronization primitives

  - A simpler way to deal with many aspects of concurrency that often lead to incorrect behavior in real distributed systems

#### How the World Survived without ZooKeeper

Programming distributed systems without ZooKeeper is possible, but more difficult

#### What ZooKeeper Doesn't Do

- ZooKeeper is not for bulk storage

#### The Apache Project

#### Building Distributed Systems with ZooKeeper

- Distributed system

  A system comprised of multiple software components running independently and concurrently across multiple physical machines

- Real system issues

  - Message delays

    Messages can get arbitrarily delayed

  - Processor speed

    Operating system scheduling and overload might induce arbitrary delays in message processing

  - Clock drif

    Processor clocks are not reliable and can arbitrarily drift away from each other. Consequently, relying upon processor clocks might lead to incorrect decisions

  One important consequence of these issues is that it is very hard in practice to tell if a process has crashed or if any of these factors is introducing some arbitrary delay

  Not receiving a message from a process could mean
  
  - that it has crashed
  - that the network is delaying its latest message arbitrarily
  - that there is something delaying the process
  - or that the process clock is drifting away

### Example: Master-Worker Application

- master-worker architecture

  - master

    - keeping track of the workers and tasks available

    - assigning tasks to workers

  - ZooKeeper

    - electing a master

    - keeping track of available workers

    - maintaining application metadata

- Three key problems

  - Master crashes

    If the master is faulty and becomes unavailable, the system cannot allocate new tasks or reallocate tasks from workers that have also failed.

  - Worker crashes

    If a worker crashes, the tasks assigned to it will not be completed

  - Communication failures

    If the master and a worker cannot exchange messages, the worker might not learn of new tasks assigned to it

  To deal with these problems, the system must be able to
  
  - reliably elect a new master if the previous one is faulty

  - determine which workers are available

  - and decide when the state of a worker is stale with respect to the rest of the system

#### Master Failures

- Use a backup master

  When the primary master crashes, the backup master takes over the role of primary master

- Failing over

  - Not as simple as starting to process requests that come in to the master

  - The new primary master must be able to recover the **state** of the system at the time the old primary master crashed

Other Issues

- The primary master is up, but the backup master suspects that the primary master has crashed

  - Could happen because, for example:

    The primary master is heavily loaded and its messages are being delayed arbitrarily

  - The backup master will execute all necessary procedures to take over the role of primary master and may eventually start executing the role of primary master, becoming a second primary master

  - Even worse

    If some workers can’t communicate with the primary master, say because of a network partition, they may end up following the second primary master

    - This scenario leads to a problem commonly called split-brain

- Split-brain

  Two or more parts of the system make progress independently, leading to inconsistent behavior

#### Worker Failures

If a worker crashes, all tasks that were assigned to it and not completed must be reassigned

- The master must be able to

  - detect when a worker crashes

  - and must be able to determine what other workers are available to execute its tasks

- A crashed worker may end up

  - partially executing tasks

  - or even fully executing tasks but not reporting the results

  If the computation has side effects

  - some recovery procedure might be necessary to clean up the state

#### Communication Failures

If a worker becomes disconnected from the master, say due to a network partition,
reassigning a task could lead to two workers executing the same task

- If executing a task more than once is acceptable

  we can reassign without verifying whether the first worker has executed the task
  
- If it is not acceptable

  then the application must be able to **accommodate the possibility** that multiple workers may end up trying to execute the task

Exactly-Once and At-Most-Once Semantics

- Using locks for tasks is not sufficient to avoid having tasks executed multiple times because we can have, for example, the following succession of events:

  1. Master M1 assigns Task T1 to Worker W1.
  2. W1 acquires the lock for T1, executes it, and releases the lock.
  3. Master M1 suspects that W1 has crashed and reassigns Task T1 to worker W2.
  4. W2 acquires the lock for T1, executes it, and releases the lock

  To deal with cases in which exactly-once or at-most-once semantics are required, an application relies on mechanisms that are **specific to its nature**

Another important issue with communication failures is the impact they have on synchronization primitives like locks

- If a node (owns the lock) crashes or gets partitioned away, the lock can prevent others from making progress

  ZooKeeper deals with such scenarios

  1. it enables clients to say that some data in the ZooKeeper state is ephemeral

  2. the ZooKeeper ensemble requires that clients periodically notify that they are alive

  If a client fails to notify the ensemble in a timely manner, then all ephemeral state belonging to this client is deleted

It is not possible to tell if a client has crashed or if it is just slow.  

- Consequently, when we suspect that a client has crashed

  - we actually need to react by assuming that it could just be slow
  - and that it may execute some other actions in the future.

#### Summary of Tasks

From the preceding descriptions, we can extract the following requirements for our
master-worker architecture:

- Master election

  It is critical for progress to have a master available to assign tasks to workers

- Crash detection

  The master must be able to detect when workers crash or disconnect

- Group membership management

  The master must be able to figure out which workers are available to execute tasks

- Metadata management

  The master and the workers must be able to store assignments and execution statuses in a reliable manner

### Why Is Distributed Coordination Hard?

Failures can crop up at any point, and it may be impossible to enumerate all the different corner cases that need to be handled

ZooKeeper has been designed with mostly consistency and availability in mind, although it also provides **read-only capability** in the presence of network partitions

### ZooKeeper Is a Success, with Caveats

Having pointed out that the **perfect solution is impossible**, we can repeat that ZooKeeper is not going to solve all the problems that the distributed application developer has to face.

## CHAPTER 2 Getting to Grips with ZooKeeper

### ZooKeeper Basics

ZooKeeper does not expose primitives directly. Instead, it exposes a file system-like API comprised of a small set of calls that enables applications to implement their own primitives.

We typically use **recipes** to denote these implementations of primitives.

#### API Overview

- znode

  - may or may not contain data

  - the data is stored as a byte array

    - The exact format of the byte array

      - is specific to each application
      - and ZooKeeper does not directly provide support to parse it

ZooKeeper API exposes the following operations:

- `create /path data`

  Creates a znode named with `/path` and containing data

- `delete /path`

  Deletes the znode `/path`

- `exists /path`

  Checks whether `/path` exists

- `setData /path data`

  Sets the data of znode `/path` to data

- `getData /path`

  Returns the data in `/path`

- `getChildren /path`

  Returns the list of children under `/path`

ZooKeeper does not allow partial **writes** or **reads** of the znode data

#### Different Modes for Znodes

##### Persistent and ephemeral znodes

- persistent znode

  - can be deleted only through a call to `delete`

- ephemeral znode

  - can be deleted in two situations

    - When the session of the client creator ends, either by expiration or because it explicitly closed.

    - When a client, **not necessarily the creator**, deletes it.

##### Sequential znodes

- A sequential znode is assigned a unique, monotonically increasing integer.

  - This sequence number is appended to the path used to create the znode

- Sequential znodes provide an easy way to create znodes with unique names

- They also provide a way to easily see the creation order of znodes

four options for the mode of a znode:

- persistent
- ephemeral
- persistent_sequential
- ephemeral_sequential

#### Watches and Notifications

- A watch is a one-shot operation, which means that it triggers
one notification

  - To receive multiple notifications over time, the client must set a new watch upon receiving each notification

  - you won’t miss changes to the state

    - because we set watches with operations that read the state of ZooKeeper

- notifications is that they are delivered to a client before any other change is made to the same znode

  - The key property we satisfy is the one that notifications preserve the order of updates the client observes

  - we guarantee that clients observe changes to the ZooKeeper state according to a global order

- ZooKeeper produces different types of notifications, depending on how the watch corresponding to the notification was set

  A client can set a watch for
  
  - changes to the data of a znode

  - changes to the children of a znode

  - or a znode being created or deleted

To set a watch

- we can use any of the calls in the API that read the state of ZooKeeper

- These API calls give the option of passing a Watcher object or using the default watcher

#### Versions

- Each znode has a version number

  - incremented every time when the znode's data changed

- `setData` and `delete` take a version as an input parameter
  
  - operation succeeds only if the version passed by the client matches the current version on the server.

### ZooKeeper Architecture

ZooKeeper ensemble:

- contain a single server and operate in standalone mode

- contain a group of servers and operate in quorum mode

#### ZooKeeper Quorums

- ZooKeeper replicates its data tree across all servers in the ensemble

- quorum

  - is the minimum number of servers that have to be running and available in order for ZooKeeper to work

  - is also the minimum number of servers that have to store a client's data before telling the client it is safely stored

    - Client does't wait for every server to store its data

  - is the majority of servers

- majority scheme

  - able to tolerate the crash of `f` servers, where `f` is less than half of the servers in the ensemble

    - For example, if we have five servers, we can tolerate up to `f = 2` crashes

  - The number of servers in the ensemble is not mandatorily
odd, but an even number actually makes the system more fragile

#### Sessions

- Session

  - All operations a client submits to ZooKeeper are associated
to a session

  - When a session ends for any reason, the ephemeral nodes created during that session disappear

- Connection

  - The client initially connects to any server in the en‐
semble, and only to a single server.

  - The client uses a TCP connection to communicate with the server, but the session may be moved to a different server if the client has not heard from its current server for some time.

    - Moving a session to a different server is handled transparently by the ZooKeeper client library.

- order guarantees

  - requests in a session are executed in FIFO order

  - If a client has multiple concurrent sessions, FIFO ordering is not necessarily preserved across the sessions

  - Consecutive sessions of the same client, even if they don’t overlap in time, also do not necessarily preserve FIFO order

### Getting Started with ZooKeeper

#### First ZooKeeper Session

run `bin/zkCli.sh`

- `create /workers ""`

- `delete /workers`

- `quit`

#### States and the Lifetime of a Session

session states

- `CONNECTING`
- `CONNEC`
- `TED`
- `CLOSED`
- `NOT_CONNECTED`

The ZooKeeper ensemble is the one responsible for declaring a session expired, not the client

- Until the client hears that a ZooKeeper session has expired, the client cannot declare the session expired

- The client may choose to close the session, however

session timeout

- is the amount of time the ZooKeeper service allows a session before declaring it expired

  - If the service does not see messages associated to a given session during time `t`, it declares the session expired

- On the client side

  - if it has heard nothing from the server at 1/3 of `t`, it sends a heartbeat message to the server

  - At 2/3 of `t`, the ZooKeeper client starts looking for a different server

  - and it has another 1/3 of `t` to find one

totally ordered

- A client cannot connect to a server that has not seen an update that the client might have seen. ZooKeeper determines freshness by ordering updates in the service.

- Every change to the state of a ZooKeeper deployment is totally ordered with respect to all other executed updates.

#### ZooKeeper with Quorums

run multiple servers on a single machine, configuration file:

    tickTime=2000
    initLimit=10
    syncLimit=5
    dataDir=./data
    clientPort=2181
    server.1=127.0.0.1:2222:2223
    server.2=127.0.0.1:3333:3334
    server.3=127.0.0.1:4444:4445

`server.n` entry

- The first field is the hostname or IP address of server n
- The second and third fields are TCP port numbers used for quorum communication and leader election

set up data directories

    mkdir z1
    mkdir z1/data
    mkdir z2
    mkdir z2/data
    mkdir z3
    mkdir z3/data

    echo 1 > z1/data/myid
    echo 2 > z2/data/myid
    echo 3 > z3/data/myid

create `z1/z1.cfg`, create configurations `z2/z2.cfg` and `z3/z3.cfg` by changing client Port to be 2182 and 2183, respectively

start z1

    cd z1
    {PATH_TO_ZK}/bin/zkServer.sh start ./z1.cfg

start z2

    cd z2
    {PATH_TO_ZK}/bin/zkServer.sh start ./z2.cfg

We now have a quorum of servers (two out of three) available

use `zkCli.sh` to access the cluster

    {PATH_TO_ZK}/bin/zkCli.sh -server 127.0.0.1:2181,127.0.0.1:2182,127.0.0.1:2183

NOTE: One of the nice things about ZooKeeper is that, apart from the connect string, it doesn't matter to the clients how many servers make up the ZooKeeper service

#### Implementing a Primitive: Locks with ZooKeeper

There are multiple flavors of locks (e.g., read/write locks, global locks) and several ways to implement locks with ZooKeeper

Say that we have an application with `n` processes trying to acquire a lock

- To acquire a lock, each process `p` tries to create a ephemeral znode, say `/lock`

- If `p` succeeds in creating the znode, it has the lock and can proceed to execute its critical section

- Other processes that try to create `/lock` fail so long as the znode exists. So, they watch for changes to `/lock` and try to acquire the lock again once they detect that `/lock` has been deleted

- Upon receiving a notification that `/lock` has been deleted, if a process `pʹ` is still interested in acquiring the lock, it repeats the steps of attempting to create `/lock` and, if another process has created the znode already, watching it

### Implementation of a Master-Worker Example

The master-worker model involves three roles:

- Master

  The master watches for new workers and tasks, assigning tasks to available workers

- Worker

  Workers register themselves with the system, to make sure that the master sees they are available to execute tasks, and then watch for new tasks

- Client

  Clients create new tasks and wait for responses from the system

#### The Master Role

Because only one process should be a master, a process must lock mastership in ZooKeeper to become the master. To do this, the process creates an ephemeral znode called `/master`

    [zk: localhost:2181(CONNECTED) 0] create -e /master "master1.example.com:2223"
    Created /master

`-e`

    create an ephemeral znode

the other process, unaware that a master has been elected already, also tries to create a `/master` znode. Let’s see what happens:

    [zk: localhost:2181(CONNECTED) 0] create -e /master "master2.example.com:2223"
    Node already exists: /master

The backup master need to take over the role of active master when active master crash. To detect this, we need to set a watch on the `/master` node as follows:

    [zk: localhost:2181(CONNECTED) 1] stat /master true
    cZxid = 0x67
    ctime = Tue Dec 11 10:06:19 CET 2012
    mZxid = 0x67
    mtime = Tue Dec 11 10:06:19 CET 2012
    pZxid = 0x67
    cversion = 0
    dataVersion = 0
    aclVersion = 0
    ephemeralOwner = 0x13b891d4c9e0005
    dataLength = 26
    numChildren = 0

The stat command gets the attributes of a znode and allows us to set a watch on the existence of the znode. Having the parameter true after the path sets the watch.

    [zk: localhost:2181(CONNECTED) 0] create -e /master "master2.example.com:2223"
    Node already exists: /master
    [zk: localhost:2181(CONNECTED) 1] stat /master true
    cZxid = 0x67
    ctime = Tue Dec 11 10:06:19 CET 2012
    mZxid = 0x67
    mtime = Tue Dec 11 10:06:19 CET 2012
    pZxid = 0x67
    cversion = 0
    dataVersion = 0
    aclVersion = 0
    ephemeralOwner = 0x13b891d4c9e0005
    dataLength = 26
    numChildren = 0
    [zk: localhost:2181(CONNECTED) 2]
    WATCHER::
    WatchedEvent state:SyncConnected type:NodeDeleted path:/master
    [zk: localhost:2181(CONNECTED) 2] ls /
    [zookeeper]
    [zk: localhost:2181(CONNECTED) 3]

The `NodeDeleted` event at the end of the output indicates that the active primary has had its session closed, or it has expired.

The backup primary should now try to become the active primary
by trying to create the `/master` znode again.

#### Workers, Tasks, and Assignments

Create three important parent znodes, `/workers`, `/tasks`, and `/assign`

    [zk: localhost:2181(CONNECTED) 0] create /workers ""
    Created /workers
    [zk: localhost:2181(CONNECTED) 1] create /tasks ""
    Created /tasks
    [zk: localhost:2181(CONNECTED) 2] create /assign ""
    Created /assign
    [zk: localhost:2181(CONNECTED) 3] ls /
    [assign, tasks, workers, master, zookeeper]
    [zk: localhost:2181(CONNECTED) 4]

- The three new znodes are persistent znodes and contain no data

- In a real application, these znodes need to be created either by a primary process before it starts assigning tasks or by some bootstrap procedure.

- once they exist, the master needs to watch for changes in the children of `/workers` and `/tasks`

      [zk: localhost:2181(CONNECTED) 4] ls /workers true
      []
      [zk: localhost:2181(CONNECTED) 5] ls /tasks true
      []

  Note that we have used the optional `true` parameter with `ls`. The true parameter, in this case, creates a watch for changes to the set of children of the corresponding znode.

#### The Worker Role

The first step by a worker is to notify the master that it is available to execute tasks. It does so by creating an ephemeral znode representing it under `/workers`. Workers use their hostnames to identify themselves:

    [zk: localhost:2181(CONNECTED) 0] create -e /workers/worker1.example.com "worker1.example.com:2224"
    Created /workers/worker1.example.com
    [zk: localhost:2181(CONNECTED) 1]

Once the worker creates a znode under `/workers`, the master observes the following notification:

    WATCHER::
    WatchedEvent state:SyncConnected type:NodeChildrenChanged path:/workers

Next, the worker needs to create a parent znode, `/assign/worker1.example.com`, to receive assignments, and watch it for new tasks by executing ls with the second parameter set to `true`:

    [zk: localhost:2181(CONNECTED) 1] create /assign/worker1.example.com ""
    Created /assign/worker1.example.com
    [zk: localhost:2181(CONNECTED) 2] ls /assign/worker1.example.com true
    []
    [zk: localhost:2181(CONNECTED) 3]

#### The Client Role

Clients add tasks to the system. For the purposes of this example, it doesn't matter what the task really consists of. Here we assume that the client asks the master-worker system to run a command `cmd`. To add a task to the system, a client executes the following:

    [zk: localhost:2181(CONNECTED) 0] create -s /tasks/task- "cmd"
    Created /tasks/task-0000000000

We make the task znode sequential to create an order for the tasks added, essentially providing a queue. The client now has to wait until the task is executed. The worker that executes the task creates a status znode for the task once the task completes. The client determines that the task has been executed when it sees that a status znode for the task has been created; the client consequently must watch for the creation of the status znode:

    [zk: localhost:2181(CONNECTED) 1] ls /tasks/task-0000000000 true
    []

The worker that executes the task creates a status znode as a child of `/tasks/task-0000000000`

Once the task znode is created, the master observes the following event:

    [zk: localhost:2181(CONNECTED) 6]
    WATCHER::
    WatchedEvent state:SyncConnected type:NodeChildrenChanged path:/tasks

The master next checks the new task, gets the list of available workers, and assigns it to `worker1.example.com`:

    [zk: 6] ls /tasks
    [task-0000000000]
    [zk: 7] ls /workers
    [worker1.example.com]
    [zk: 8] create /assign/worker1.example.com/task-0000000000 ""
    Created /assign/worker1.example.com/task-0000000000
    [zk: 9]

The worker receives a notification that a new task has been assigned:

    [zk: localhost:2181(CONNECTED) 3]
    WATCHER::
    WatchedEvent state:SyncConnected type:NodeChildrenChanged
    path:/assign/worker1.example.com

The worker then checks the new task and sees that the task has been assigned to it:

    [zk: localhost:2181(CONNECTED) 3] ls /assign/worker1.example.com
    [task-0000000000]
    [zk: localhost:2181(CONNECTED) 4]

Once the worker finishes executing the task, it adds a status znode to /tasks:

    [zk: localhost:2181(CONNECTED) 4] create /tasks/task-0000000000/status "done"
    Created /tasks/task-0000000000/status
    [zk: localhost:2181(CONNECTED) 5]

and the client receives a notification and checks the result:

    WATCHER::
    WatchedEvent state:SyncConnected type:NodeChildrenChanged
    path:/tasks/task-0000000000
    [zk: localhost:2181(CONNECTED) 2] get /tasks/task-0000000000
    "cmd"
    cZxid = 0x7c
    ctime = Tue Dec 11 10:30:18 CET 2012
    mZxid = 0x7c
    mtime = Tue Dec 11 10:30:18 CET 2012
    pZxid = 0x7e
    cversion = 1
    dataVersion = 0
    aclVersion = 0
    ephemeralOwner = 0x0
    dataLength = 5
    numChildren = 1
    [zk: localhost:2181(CONNECTED) 3] get /tasks/task-0000000000/status
    "done"
    cZxid = 0x7e
    ctime = Tue Dec 11 10:42:41 CET 2012
    mZxid = 0x7e
    mtime = Tue Dec 11 10:42:41 CET 2012
    pZxid = 0x7e
    cversion = 0
    dataVersion = 0
    aclVersion = 0
    ephemeralOwner = 0x0
    dataLength = 8
    numChildren = 0
    [zk: localhost:2181(CONNECTED) 4]

The client checks the content of the status znode to determine what has happened to the task.

### Takeaway Messages

## CHAPTER 3 Getting Started with the ZooKeeper API
















TODO zookeeper ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
