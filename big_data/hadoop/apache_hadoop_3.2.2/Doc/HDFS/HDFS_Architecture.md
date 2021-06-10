# [HDFS Architecture](https://hadoop.apache.org/docs/r3.2.2/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html)

- [HDFS Architecture](#hdfs-architecture)
	- [Introduction](#introduction)
	- [Assumptions and Goals](#assumptions-and-goals)
		- [Hardware Failure](#hardware-failure)
		- [Streaming Data Access](#streaming-data-access)
		- [Large Data Sets](#large-data-sets)
		- [Simple Coherency Model](#simple-coherency-model)
		- ["Moving Computation is Cheaper than Moving Data"](#moving-computation-is-cheaper-than-moving-data)
		- [Portability Across Heterogeneous Hardware and Software Platforms](#portability-across-heterogeneous-hardware-and-software-platforms)
	- [NameNode and DataNodes](#namenode-and-datanodes)
	- [The File System Namespace](#the-file-system-namespace)
	- [Data Replication](#data-replication)
		- [Replica Placement: The First Baby Steps](#replica-placement-the-first-baby-steps)

## Introduction

- HDFS is highly fault-tolerant and is designed to be deployed on low-cost hardware

- HDFS provides high throughput access to application data and is suitable for applications that have large data sets

## Assumptions and Goals

### Hardware Failure

- Hardware failure is the norm rather than the exception

- Detection of faults and quick, automatic recovery from them is a core architectural goal of HDFS

### Streaming Data Access

- Applications that run on HDFS need streaming access to their data sets

- HDFS is designed more for batch processing rather than interactive use by users

- The emphasis is on high throughput of data access rather than low latency of data access

### Large Data Sets

- Applications that run on HDFS have large data sets. A typical file in HDFS is gigabytes to terabytes in size

### Simple Coherency Model

- HDFS applications need a write-once-read-many access model for files

- A file once created, written, and closed need not be changed except for appends and truncates

- Appending the content to the end of the files is supported but cannot be updated at arbitrary point

### "Moving Computation is Cheaper than Moving Data"

- The assumption is that it is often better to migrate the computation closer to where the data is located rather than moving the data to where the application is running

- HDFS provides interfaces for applications to move themselves closer to where the data is located

### Portability Across Heterogeneous Hardware and Software Platforms

## NameNode and DataNodes

- HDFS has a master/slave architecture

- An HDFS cluster consists of

  - a single **NameNode**

  - a **master server**

    that manages the file system namespace and regulates access to files by clients

  - a number of DataNodes

    usually one per node in the cluster, which manage storage attached to the nodes that they run on

- HDFS exposes a file system namespace and allows user data to be stored in files

  - a file is split into one or more blocks and these blocks are stored in a set of DataNodes

- The NameNode

  - executes file system namespace operations like opening, closing, and renaming files and directories

  - It also determines the mapping of blocks to DataNodes

- The DataNodes

  - are responsible for serving read and write requests from the file system’s clients

  - The DataNodes also perform block creation, deletion, and replication upon instruction from the NameNode

- A typical deployment

  - has a dedicated machine that runs only the NameNode software

  - Each of the other machines in the cluster runs one instance of the DataNode software

    - The architecture does not preclude running multiple DataNodes on the same machine but in a real deployment that is rarely the case.

- The existence of a **single NameNode** in a cluster greatly simplifies the architecture of the system

  - The NameNode is the arbitrator and repository for all HDFS metadata

  - The system is designed in such a way that user data never flows through the NameNode

## The File System Namespace

- The NameNode maintains the file system namespace

  - Any change to the file system **namespace** or its **properties** is recorded by the NameNode

  - An application can specify the number of replicas of a file that should be maintained by HDFS. The number of copies of a file is called the **replication factor** of that file. This information is stored by the NameNode.

## Data Replication

- HDFS is designed to reliably store very large files across machines in a large cluster

  - It stores each file as a sequence of blocks

  - The blocks of a file are replicated for fault tolerance

  - The block size and replication factor are configurable per file

- All blocks in a file except the last block are the same size, while users can start a new block without filling out the last block to the configured block size after the support for variable length block was added to append and hsync.

- An application can specify the number of replicas of a file. The replication factor can be specified at file creation time and can be changed later. Files in HDFS are write-once (except for appends and truncates) and have **strictly one writer** at any time.

- The NameNode makes all decisions regarding replication of blocks. It periodically receives a **Heartbeat** and a **Blockreport** from each of the DataNodes in the cluster. Receipt of a Heartbeat implies that the DataNode is functioning properly. A Blockreport contains a list of all blocks on a DataNode.

### Replica Placement: The First Baby Steps






