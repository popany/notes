# [ZooKeeper Distributed process coordination]()

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

ZooKeeper has been designed with mostly consistency and availability in mind, although it also provides read-only capability in the presence of network partitions

### ZooKeeper Is a Success, with Caveats

Having pointed out that the perfect solution is impossible, we can repeat that ZooKeeper is not going to solve all the problems that the distributed application developer has to face.

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






TODO zookeeper ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
