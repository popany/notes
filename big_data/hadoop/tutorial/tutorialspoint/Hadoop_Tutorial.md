# [Hadoop Tutorial](https://www.tutorialspoint.com/hadoop/index.htm)

- [Hadoop Tutorial](#hadoop-tutorial)
  - [Big Data Overview](#big-data-overview)
    - [What is Big Data?](#what-is-big-data)
    - [What Comes Under Big Data?](#what-comes-under-big-data)
    - [Benefits of Big Data](#benefits-of-big-data)
    - [Big Data Technologies](#big-data-technologies)
      - [Operational Big Data](#operational-big-data)
      - [Analytical Big Data](#analytical-big-data)
    - [Operational vs. Analytical Systems](#operational-vs-analytical-systems)
    - [Big Data Challenges](#big-data-challenges)
  - [Big Data Solutions](#big-data-solutions)
    - [Traditional Approach](#traditional-approach)
      - [Limitation](#limitation)
    - [Google’s Solution](#googles-solution)
    - [Hadoop](#hadoop)
  - [Introduction](#introduction)
    - [Hadoop Architecture](#hadoop-architecture)
    - [MapReduce](#mapreduce)
    - [Hadoop Distributed File System](#hadoop-distributed-file-system)
    - [How Does Hadoop Work?](#how-does-hadoop-work)
    - [Advantages of Hadoop](#advantages-of-hadoop)
  - [Enviornment Setup](#enviornment-setup)
    - [Pre-installation Setup](#pre-installation-setup)
      - [Creating a User](#creating-a-user)
    - [SSH Setup and Key Generation](#ssh-setup-and-key-generation)
    - [Installing Java](#installing-java)
    - [Downloading Hadoop](#downloading-hadoop)
    - [Hadoop Operation Modes](#hadoop-operation-modes)
    - [Installing Hadoop in Standalone Mode](#installing-hadoop-in-standalone-mode)
      - [Setting Up Hadoop](#setting-up-hadoop)
      - [Example](#example)
        - [Step 1](#step-1)
        - [Step 2](#step-2)
        - [Step 3](#step-3)
    - [Installing Hadoop in Pseudo Distributed Mode](#installing-hadoop-in-pseudo-distributed-mode)
      - [Step 1 − Setting Up Hadoop](#step-1--setting-up-hadoop)
      - [Step 2 − Hadoop Configuration](#step-2--hadoop-configuration)
        - [core-site.xml](#core-sitexml)
        - [hdfs-site.xml](#hdfs-sitexml)
        - [yarn-site.xml](#yarn-sitexml)
        - [mapred-site.xml](#mapred-sitexml)
    - [Verifying Hadoop Installation](#verifying-hadoop-installation)
      - [Step 1 − Name Node Setup](#step-1--name-node-setup)
      - [Step 2 − Verifying Hadoop dfs](#step-2--verifying-hadoop-dfs)
      - [Step 3 − Verifying Yarn Script](#step-3--verifying-yarn-script)
      - [Step 4 − Accessing Hadoop on Browser](#step-4--accessing-hadoop-on-browser)
      - [Step 5 − Verify All Applications for Cluster](#step-5--verify-all-applications-for-cluster)
  - [HDFS Overview](#hdfs-overview)
    - [Features of HDFS](#features-of-hdfs)
    - [HDFS Architecture](#hdfs-architecture)
      - [Namenode](#namenode)
      - [Datanode](#datanode)
      - [Block](#block)
    - [Goals of HDFS](#goals-of-hdfs)
  - [HDFS Operations](#hdfs-operations)
    - [Starting HDFS](#starting-hdfs)
    - [Listing Files in HDFS](#listing-files-in-hdfs)
    - [Inserting Data into HDFS](#inserting-data-into-hdfs)
      - [Step 1](#step-1-1)
      - [Step 2](#step-2-1)
      - [Step 3](#step-3-1)
    - [Retrieving Data from HDFS](#retrieving-data-from-hdfs)
      - [Step 1](#step-1-2)
      - [Step 2](#step-2-2)
    - [Shutting Down the HDFS](#shutting-down-the-hdfs)
  - [Command Reference](#command-reference)
  - [MapReduce](#mapreduce-1)
  - [Streaming](#streaming)
  - [Multi-Node Cluster](#multi-node-cluster)
    - [Installing Java](#installing-java-1)
    - [Creating User Account](#creating-user-account)
    - [Mapping the nodes](#mapping-the-nodes)
    - [Configuring Key Based Login](#configuring-key-based-login)
    - [Installing Hadoop](#installing-hadoop)
    - [Configuring Hadoop](#configuring-hadoop)
      - [core-site.xml](#core-sitexml-1)
      - [hdfs-site.xml](#hdfs-sitexml-1)
      - [mapred-site.xml](#mapred-sitexml-1)
      - [hadoop-env.sh](#hadoop-envsh)
    - [Installing Hadoop on Slave Servers](#installing-hadoop-on-slave-servers)
    - [Configuring Hadoop on Master Server](#configuring-hadoop-on-master-server)
      - [Configuring Master Node](#configuring-master-node)
      - [Configuring Slave Node](#configuring-slave-node)
      - [Format Name Node on Hadoop Master](#format-name-node-on-hadoop-master)
    - [Starting Hadoop Services](#starting-hadoop-services)
    - [Adding a New DataNode in the Hadoop Cluster](#adding-a-new-datanode-in-the-hadoop-cluster)
      - [Networking](#networking)
      - [Adding User and SSH Access](#adding-user-and-ssh-access)
        - [Add a User](#add-a-user)
        - [Execute the following on the master](#execute-the-following-on-the-master)
        - [Execute the following on the slaves](#execute-the-following-on-the-slaves)
      - [Set Hostname of New Node](#set-hostname-of-new-node)
      - [Start the DataNode on New Node](#start-the-datanode-on-new-node)
        - [Login to new node](#login-to-new-node)
        - [Start HDFS on a newly added slave node by using the following command](#start-hdfs-on-a-newly-added-slave-node-by-using-the-following-command)
        - [Check the output of jps command on a new node. It looks as follows.](#check-the-output-of-jps-command-on-a-new-node-it-looks-as-follows)
    - [Removing a DataNode from the Hadoop Cluster](#removing-a-datanode-from-the-hadoop-cluster)
      - [Step 1 − Login to master](#step-1--login-to-master)
      - [Step 2 − Change cluster configuration](#step-2--change-cluster-configuration)
      - [Step 3 − Determine hosts to decommission](#step-3--determine-hosts-to-decommission)
      - [Step 4 − Force configuration reload](#step-4--force-configuration-reload)
      - [Step 5 − Shutdown nodes](#step-5--shutdown-nodes)
      - [Step 6 − Edit excludes file again](#step-6--edit-excludes-file-again)

Hadoop is an open-source framework that allows to store and process big data in a distributed environment across clusters of computers using simple programming models. It is designed to scale up from single servers to thousands of machines, each offering local computation and storage.

This brief tutorial provides a quick introduction to Big Data, MapReduce algorithm, and Hadoop Distributed File System.

## [Big Data Overview](https://www.tutorialspoint.com/hadoop/hadoop_big_data_overview.htm)

### What is Big Data?

Big data is a collection of large datasets that cannot be processed using traditional computing techniques. It is not a single technique or a tool, rather it has become a complete subject, which involves various tools, technqiues and frameworks.

### What Comes Under Big Data?

Big data involves the data produced by different devices and applications. Given below are some of the fields that come under the umbrella of Big Data.

- Black Box Data − It is a component of helicopter, airplanes, and jets, etc. It captures voices of the flight crew, recordings of microphones and earphones, and the performance information of the aircraft.

- Social Media Data − Social media such as Facebook and Twitter hold information and the views posted by millions of people across the globe.

- Stock Exchange Data − The stock exchange data holds information about the ‘buy’ and ‘sell’ decisions made on a share of different companies made by the customers.

- Power Grid Data − The power grid data holds information consumed by a particular node with respect to a base station.

- Transport Data − Transport data includes model, capacity, distance and availability of a vehicle.

- Search Engine Data − Search engines retrieve lots of data from different databases.

Thus Big Data includes huge volume, high velocity, and extensible variety of data. The data in it will be of three types.

- Structured data − Relational data.

- Semi Structured data − XML data.

- Unstructured data − Word, PDF, Text, Media Logs.

### Benefits of Big Data

- Using the information kept in the social network like Facebook, the marketing agencies are learning about the response for their campaigns, promotions, and other advertising mediums.

- Using the information in the social media like preferences and product perception of their consumers, product companies and retail organizations are planning their production.

- Using the data regarding the previous medical history of patients, hospitals are providing better and quick service.

### Big Data Technologies

Big data technologies are important in providing more accurate analysis, which may lead to more concrete decision-making resulting in greater operational efficiencies, cost reductions, and reduced risks for the business.

To harness the power of big data, you would require an infrastructure that can manage and process huge volumes of structured and unstructured data in realtime and can protect data privacy and security.

There are various technologies in the market from different vendors including Amazon, IBM, Microsoft, etc., to handle big data. While looking into the technologies that handle big data, we examine the following two classes of technology −

#### Operational Big Data

This include systems like MongoDB that provide operational capabilities for real-time, interactive workloads where data is primarily captured and stored.

NoSQL Big Data systems are designed to take advantage of new cloud computing architectures that have emerged over the past decade to allow massive computations to be run inexpensively and efficiently. This makes operational big data workloads much easier to manage, cheaper, and faster to implement.

Some NoSQL systems can provide insights into patterns and trends based on real-time data with minimal coding and without the need for data scientists and additional infrastructure.

#### Analytical Big Data

These includes systems like Massively Parallel Processing (MPP) database systems and MapReduce that provide analytical capabilities for retrospective and complex analysis that may touch most or all of the data.

MapReduce provides a new method of analyzing data that is **complementary to the capabilities provided by SQL**, and a system based on MapReduce that can be scaled up from single servers to thousands of high and low end machines.

These two classes of technology are complementary and frequently deployed together.

### Operational vs. Analytical Systems

### Big Data Challenges

## [Big Data Solutions](https://www.tutorialspoint.com/hadoop/hadoop_big_data_solutions.htm)

### Traditional Approach

In this approach, an enterprise will have a computer to store and process big data. For storage purpose, the programmers will take the help of their choice of database vendors such as Oracle, IBM, etc. In this approach, the user interacts with the application, which in turn handles the part of data storage and analysis.

#### Limitation

This approach works fine with those applications that process less voluminous data that can be accommodated by standard database servers, or up to the limit of the processor that is processing the data. But when it comes to dealing with huge amounts of scalable data, it is a hectic task to process such data through a single database bottleneck.

### Google’s Solution

Google solved this problem using an algorithm called **MapReduce**. This algorithm divides the task into small parts and assigns them to many computers, and collects the results from them which when integrated, form the result dataset.

### Hadoop

Using the solution provided by Google, Doug Cutting and his team developed an Open Source Project called HADOOP.

Hadoop runs applications using the MapReduce algorithm, where the data is processed in parallel with others. In short, Hadoop is used to develop applications that could perform complete statistical analysis on huge amounts of data.

## [Introduction](https://www.tutorialspoint.com/hadoop/hadoop_introduction.htm)

Hadoop is an Apache open source framework written in java that allows distributed processing of large datasets across clusters of computers using simple programming models. The Hadoop framework application works in an environment that provides distributed storage and computation across clusters of computers. Hadoop is designed to scale up from single server to thousands of machines, each offering local computation and storage.

### Hadoop Architecture

At its core, Hadoop has two major layers namely −

- Processing/Computation layer (MapReduce), and
- Storage layer (Hadoop Distributed File System).

### MapReduce

MapReduce is a **parallel programming model** for writing distributed applications devised at Google for efficient processing of large amounts of data (multi-terabyte data-sets), on large clusters (thousands of nodes) of commodity hardware in a reliable, fault-tolerant manner. The MapReduce program runs on Hadoop which is an Apache open-source framework.

### Hadoop Distributed File System

The Hadoop Distributed File System (HDFS) is based on the Google File System (GFS) and provides a distributed file system that is designed to run on commodity hardware. It has many similarities with existing distributed file systems. However, the differences from other distributed file systems are significant. It is highly **fault-tolerant** and is designed to be deployed on **low-cost hardware**. It provides high throughput access to application data and is suitable for applications having large datasets.

Apart from the above-mentioned two core components, Hadoop framework also includes the following two modules −

- Hadoop Common − These are Java **libraries and utilities** required by other Hadoop modules.

- Hadoop YARN − This is a framework for **job scheduling and cluster resource management**.

### How Does Hadoop Work?

It is quite expensive to build bigger servers with heavy configurations that handle large scale processing, but as an alternative, you can tie together many commodity computers with single-CPU, as a single functional distributed system and practically, the clustered machines can read the dataset in parallel and provide a much higher throughput. Moreover, it is cheaper than one high-end server. So this is the first motivational factor behind using Hadoop that it runs across clustered and low-cost machines.

Hadoop runs code across a cluster of computers. This process includes the following core tasks that Hadoop performs −

- Data is initially divided into **directories** and **files**. Files are divided into **uniform sized** blocks of 128M and 64M (preferably 128M).

- These files are then distributed across various cluster nodes for further processing.

- HDFS, being on top of the local file system, supervises the processing.

- **Blocks are replicated** for handling hardware failure.

- Checking that the code was executed successfully.

- Performing the sort that takes place between the map and reduce stages.

- Sending the sorted data to a certain computer.

- Writing the debugging logs for each job.

### Advantages of Hadoop

- Hadoop framework allows the user to quickly write and test distributed systems. It is efficient, and it automatic distributes the data and work across the machines and in turn, utilizes the underlying parallelism of the CPU cores.

- Hadoop does not rely on hardware to provide fault-tolerance and high availability (FTHA), rather Hadoop library itself has been designed to detect and handle failures **at the application layer**.

- Servers can be added or removed from the cluster **dynamically** and Hadoop continues to operate without interruption.

- Another big advantage of Hadoop is that apart from being open source, it is **compatible** on all the platforms since it is Java based.

## [Enviornment Setup](https://www.tutorialspoint.com/hadoop/hadoop_enviornment_setup.htm)

Hadoop is supported by GNU/Linux platform and its flavors. Therefore, we have to install a Linux operating system for setting up Hadoop environment. In case you have an OS other than Linux, you can install a Virtualbox software in it and have Linux inside the Virtualbox.

### Pre-installation Setup

Before installing Hadoop into the Linux environment, we need to set up Linux using ssh (Secure Shell). Follow the steps given below for setting up the Linux environment.

#### Creating a User

At the beginning, it is recommended to create a separate user for Hadoop to isolate Hadoop file system from Unix file system. Follow the steps given below to create a user −

- Open the root using the command “su”.

- Create a user from the root account using the command “useradd username”.

- Now you can open an existing user account using the command “su username”.

Open the Linux terminal and type the following commands to create a user.

    $ su 
        password: 
    # useradd hadoop 
    # passwd hadoop 
        New passwd: 
        Retype new passwd

### SSH Setup and Key Generation

SSH setup is required to do different operations on a cluster such as starting, stopping, distributed daemon shell operations. To authenticate different users of Hadoop, it is required to provide public/private key pair for a Hadoop user and share it with different users.

The following commands are used for generating a key value pair using SSH. Copy the public keys form id_rsa.pub to authorized_keys, and provide the owner with read and write permissions to authorized_keys file respectively.

    $ ssh-keygen -t rsa 
    $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys 
    $ chmod 0600 ~/.ssh/authorized_keys 

### Installing Java

### Downloading Hadoop

Download and extract Hadoop 2.4.1 from Apache software foundation using the following commands.

    $ su 
    password: 
    # cd /usr/local 
    # wget http://apache.claz.org/hadoop/common/hadoop-2.4.1/ 
    hadoop-2.4.1.tar.gz 
    # tar xzf hadoop-2.4.1.tar.gz 
    # mv hadoop-2.4.1/* to hadoop/ 
    # exit 

### Hadoop Operation Modes

Once you have downloaded Hadoop, you can operate your Hadoop cluster in one of the three supported modes −

- Local/Standalone Mode − After downloading Hadoop in your system, by default, it is configured in a standalone mode and can be run as a single java process.

- Pseudo Distributed Mode − It is a distributed simulation on single machine. Each Hadoop daemon such as hdfs, yarn, MapReduce etc., will run as a separate java process. This mode is useful for development.

- Fully Distributed Mode − This mode is fully distributed with minimum two or more machines as a cluster. We will come across this mode in detail in the coming chapters.

### Installing Hadoop in Standalone Mode

Here we will discuss the installation of Hadoop 2.4.1 in standalone mode.

There are no daemons running and everything runs in a single JVM. Standalone mode is suitable for running MapReduce programs during development, since it is easy to test and debug them.

#### Setting Up Hadoop

You can set Hadoop environment variables by appending the following commands to `~/.bashrc` file.

export HADOOP_HOME=/usr/local/hadoop 

Before proceeding further, you need to make sure that Hadoop is working fine. Just issue the following command −

    $ hadoop version 

If everything is fine with your setup, then you should see the following result −

    Hadoop 2.4.1 
    Subversion https://svn.apache.org/repos/asf/hadoop/common -r 1529768 
    Compiled by hortonmu on 2013-10-07T06:28Z 
    Compiled with protoc 2.5.0
    From source with checksum 79e53ce7994d1628b240f09af91e1af4 

It means your Hadoop's standalone mode setup is working fine. By default, Hadoop is configured to run in a non-distributed mode on a single machine.

#### Example

Let's check a simple example of Hadoop. Hadoop installation delivers the following example MapReduce jar file, which provides basic functionality of MapReduce and can be used for calculating, like Pi value, word counts in a given list of files, etc.

    $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.2.0.jar 

Let's have an input directory where we will push a few files and our requirement is to count the total number of words in those files. To calculate the total number of words, we do not need to write our MapReduce, provided the .jar file contains the implementation for word count. You can try other examples using the same .jar file; just issue the following commands to check supported MapReduce functional programs by hadoop-mapreduce-examples-2.2.0.jar file.

    $ hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.2.0.jar 

##### Step 1

Create temporary content files in the input directory. You can create this input directory anywhere you would like to work.

    $ mkdir input 
    $ cp $HADOOP_HOME/*.txt input 
    $ ls -l input 

It will give the following files in your input directory −

    total 24 
    -rw-r--r-- 1 root root 15164 Feb 21 10:14 LICENSE.txt 
    -rw-r--r-- 1 root root   101 Feb 21 10:14 NOTICE.txt
    -rw-r--r-- 1 root root  1366 Feb 21 10:14 README.txt 

These files have been copied from the Hadoop installation home directory. For your experiment, you can have different and large sets of files.

##### Step 2

Let's start the Hadoop process to count the total number of words in all the files available in the input directory, as follows −

    $ hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.2.0.jar  wordcount input output 

##### Step 3

Step-2 will do the required processing and save the output in output/part-r00000 file, which you can check by using −

    $cat output/* 

It will list down all the words along with their total counts available in all the files available in the input directory.

### Installing Hadoop in Pseudo Distributed Mode

Follow the steps given below to install Hadoop 2.4.1 in pseudo distributed mode.

#### Step 1 − Setting Up Hadoop

You can set Hadoop environment variables by appending the following commands to `~/.bashrc` file.

    export HADOOP_HOME=/usr/local/hadoop 
    export HADOOP_MAPRED_HOME=$HADOOP_HOME 
    export HADOOP_COMMON_HOME=$HADOOP_HOME 

    export HADOOP_HDFS_HOME=$HADOOP_HOME 
    export YARN_HOME=$HADOOP_HOME 
    export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native 
    export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin 
    export HADOOP_INSTALL=$HADOOP_HOME 

Now apply all the changes into the current running system.

    $ source ~/.bashrc 

#### Step 2 − Hadoop Configuration

You can find all the Hadoop configuration files in the location “$HADOOP_HOME/etc/hadoop”. It is required to make changes in those configuration files according to your Hadoop infrastructure.

    $ cd $HADOOP_HOME/etc/hadoop

In order to develop Hadoop programs in java, you have to reset the java environment variables in `hadoop-env.sh` file by replacing `JAVA_HOME` value with the location of java in your system.

    export JAVA_HOME=/usr/local/jdk1.7.0_71

The following are the list of files that you have to edit to configure Hadoop.

##### core-site.xml

The core-site.xml file contains information such as the port number used for Hadoop instance, memory allocated for the file system, memory limit for storing the data, and size of Read/Write buffers.

Open the core-site.xml and add the following properties in between `<configuration>`, `</configuration>` tags.

    <configuration>
        <property>
            <name>fs.default.name</name>
            <value>hdfs://localhost:9000</value> 
        </property>
    </configuration>

##### hdfs-site.xml

The hdfs-site.xml file contains information such as the value of replication data, namenode path, and datanode paths of your local file systems. It means the place where you want to store the Hadoop infrastructure.

Let us assume the following data.

    dfs.replication (data replication value) = 1 

    (In the below given path /hadoop/ is the user name. 
    hadoopinfra/hdfs/namenode is the directory created by hdfs file system.) 
    namenode path = //home/hadoop/hadoopinfra/hdfs/namenode 

    (hadoopinfra/hdfs/datanode is the directory created by hdfs file system.) 
    datanode path = //home/hadoop/hadoopinfra/hdfs/datanode 

Open this file and add the following properties in between the `<configuration> </configuration>` tags in this file.

    <configuration>
        <property>
            <name>dfs.replication</name>
            <value>1</value>
        </property>
        
        <property>
            <name>dfs.name.dir</name>
            <value>file:///home/hadoop/hadoopinfra/hdfs/namenode </value>
        </property>
        
        <property>
            <name>dfs.data.dir</name> 
            <value>file:///home/hadoop/hadoopinfra/hdfs/datanode </value> 
        </property>
    </configuration>

Note − In the above file, all the property values are user-defined and you can make changes according to your Hadoop infrastructure.

##### yarn-site.xml

This file is used to configure yarn into Hadoop. Open the yarn-site.xml file and add the following properties in between the `<configuration>, </configuration>` tags in this file.

    <configuration>
        <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value> 
        </property>
    </configuration>

##### mapred-site.xml

This file is used to specify which MapReduce framework we are using. By default, Hadoop contains a template of yarn-site.xml. First of all, it is required to copy the file from mapred-site.xml.template to mapred-site.xml file using the following command.

    $ cp mapred-site.xml.template mapred-site.xml 

Open mapred-site.xml file and add the following properties in between the `<configuration>`, `</configuration>` tags in this file.

    <configuration>
        <property> 
            <name>mapreduce.framework.name</name>
            <value>yarn</value>
        </property>
    </configuration>

### Verifying Hadoop Installation
The following steps are used to verify the Hadoop installation.

#### Step 1 − Name Node Setup

Set up the namenode using the command “hdfs namenode -format” as follows.

    $ cd ~ 
    $ hdfs namenode -format 

#### Step 2 − Verifying Hadoop dfs

The following command is used to start dfs. Executing this command will start your Hadoop file system.

    $ start-dfs.sh 

#### Step 3 − Verifying Yarn Script

The following command is used to start the yarn script. Executing this command will start your yarn daemons.

    $ start-yarn.sh 

#### Step 4 − Accessing Hadoop on Browser

The default port number to access Hadoop is 50070. Use the following url to get Hadoop services on browser.

    http://localhost:50070/

#### Step 5 − Verify All Applications for Cluster

The default port number to access all applications of cluster is 8088. Use the following url to visit this service.

    http://localhost:8088/

## [HDFS Overview](https://www.tutorialspoint.com/hadoop/hadoop_hdfs_overview.htm)

Hadoop File System was developed using **distributed file system** design. It is run on commodity hardware. Unlike other distributed systems, HDFS is highly faulttolerant and designed using low-cost hardware.

HDFS holds very large amount of data and provides easier access. To store such huge data, the **files are stored across multiple machines**. These files are stored in redundant fashion to rescue the system from possible data losses in case of failure. HDFS also **makes applications available to parallel processing**.

### Features of HDFS

- It is suitable for the distributed storage and processing.
- Hadoop provides a command interface to interact with HDFS.
- The built-in servers of **namenode** and **datanode** help users to easily check the status of cluster.
- Streaming access to file system data.
- HDFS provides file permissions and authentication.

### HDFS Architecture

HDFS follows the master-slave architecture and it has the following elements.

#### Namenode

The namenode is the commodity hardware that contains the GNU/Linux operating system and the namenode software. It is a software that can be run on commodity hardware. The system having the namenode acts as the **master server** and it does the following tasks −

- Manages the file system namespace.

- Regulates client’s access to files.

- It also executes file system operations such as **renaming**, **closing**, and **opening** files and directories.

#### Datanode

The datanode is a commodity hardware having the GNU/Linux operating system and datanode software. For every node (Commodity hardware/System) in a cluster, there will be a datanode. These nodes manage the data storage of their system.

- Datanodes perform **read-write** operations on the file systems, as per client request.

- They also perform operations such as **block creation**, **deletion**, and **replication** according to the instructions of the namenode.

#### Block

Generally the user data is stored in the files of HDFS. The file in a file system will be divided into one or more segments and/or stored in individual data nodes. These file segments are called as blocks. In other words, the **minimum amount of data** that HDFS can read or write is called a Block. The default block size is 64MB, but it can be increased as per the need to change in HDFS configuration.

### Goals of HDFS

- Fault detection and recovery − Since HDFS includes a large number of commodity hardware, failure of components is frequent. Therefore HDFS should have mechanisms for quick and automatic fault detection and recovery.

- Huge datasets − HDFS should have hundreds of nodes per cluster to manage the applications having huge datasets.

- Hardware at data − A requested task can be done efficiently, when the computation takes place near the data. Especially where huge datasets are involved, it reduces the network traffic and increases the throughput.

## [HDFS Operations](https://www.tutorialspoint.com/hadoop/hadoop_hdfs_operations.htm)

### Starting HDFS

Initially you have to format the configured HDFS file system, open namenode (HDFS server), and execute the following command.

    $ hadoop namenode -format 

After formatting the HDFS, start the distributed file system. The following command will start the namenode as well as the data nodes as cluster.

    $ start-dfs.sh 

### Listing Files in HDFS

After loading the information in the server, we can find the list of files in a directory, status of a file, using ‘ls’. Given below is the syntax of ls that you can pass to a directory or a filename as an argument.

    $ $HADOOP_HOME/bin/hadoop fs -ls <args>

### Inserting Data into HDFS

Assume we have data in the file called file.txt in the local system which is ought to be saved in the hdfs file system. Follow the steps given below to insert the required file in the Hadoop file system.

#### Step 1

You have to create an input directory.

    $ $HADOOP_HOME/bin/hadoop fs -mkdir /user/input 

#### Step 2

Transfer and store a data file from local systems to the Hadoop file system using the put command.

    $ $HADOOP_HOME/bin/hadoop fs -put /home/file.txt /user/input 

#### Step 3

You can verify the file using ls command.

    $ $HADOOP_HOME/bin/hadoop fs -ls /user/input 

### Retrieving Data from HDFS

Assume we have a file in HDFS called outfile. Given below is a simple demonstration for retrieving the required file from the Hadoop file system.

#### Step 1

Initially, view the data from HDFS using cat command.

    $ $HADOOP_HOME/bin/hadoop fs -cat /user/output/outfile 

#### Step 2

Get the file from HDFS to the local file system using get command.

    $ $HADOOP_HOME/bin/hadoop fs -get /user/output/ /home/hadoop_tp/ 

### Shutting Down the HDFS

You can shut down the HDFS by using the following command.

    $ stop-dfs.sh 

## [Command Reference](https://www.tutorialspoint.com/hadoop/hadoop_command_reference.htm)

There are many more commands in "$HADOOP_HOME/bin/hadoop fs" than are demonstrated here, although these basic operations will get you started. Running ./bin/hadoop dfs with no additional arguments will list all the commands that can be run with the FsShell system. Furthermore, $HADOOP_HOME/bin/hadoop fs -help commandName will display a short usage summary for the operation in question, if you are stuck.

## [MapReduce](https://www.tutorialspoint.com/hadoop/hadoop_mapreduce.htm)

## [Streaming](https://www.tutorialspoint.com/hadoop/hadoop_streaming.htm)

## [Multi-Node Cluster](https://www.tutorialspoint.com/hadoop/hadoop_multi_node_cluster.htm)

This chapter explains the setup of the Hadoop Multi-Node cluster on a distributed environment.

As the whole cluster cannot be demonstrated, we are explaining the Hadoop cluster environment using three systems (one master and two slaves); given below are their IP addresses.

- Hadoop Master: 192.168.1.15 (hadoop-master)
- Hadoop Slave: 192.168.1.16 (hadoop-slave-1)
- Hadoop Slave: 192.168.1.17 (hadoop-slave-2)

Follow the steps given below to have Hadoop Multi-Node cluster setup.

### Installing Java

### Creating User Account

Create a system user account on both master and slave systems to use the Hadoop installation.

    # useradd hadoop 
    # passwd hadoop

### Mapping the nodes

You have to edit hosts file in /etc/ folder on all nodes, specify the IP address of each system followed by their host names.

    # vi /etc/hosts
    enter the following lines in the /etc/hosts file.

    192.168.1.109 hadoop-master 
    192.168.1.145 hadoop-slave-1 
    192.168.56.1 hadoop-slave-2

### Configuring Key Based Login

Setup ssh in every node such that they can communicate with one another without any prompt for password.

    # su hadoop 
    $ ssh-keygen -t rsa 
    $ ssh-copy-id -i ~/.ssh/id_rsa.pub tutorialspoint@hadoop-master 
    $ ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop_tp1@hadoop-slave-1 
    $ ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop_tp2@hadoop-slave-2 
    $ chmod 0600 ~/.ssh/authorized_keys 
    $ exit

### Installing Hadoop

In the Master server, download and install Hadoop using the following commands.

    # mkdir /opt/hadoop 
    # cd /opt/hadoop/ 
    # wget http://apache.mesi.com.ar/hadoop/common/hadoop-1.2.1/hadoop-1.2.0.tar.gz 
    # tar -xzf hadoop-1.2.0.tar.gz 
    # mv hadoop-1.2.0 hadoop
    # chown -R hadoop /opt/hadoop 
    # cd /opt/hadoop/hadoop/

### Configuring Hadoop

You have to configure Hadoop server by making the following changes as given below.

#### core-site.xml

Open the core-site.xml file and edit it as shown below.

    <configuration>
        <property> 
            <name>fs.default.name</name> 
            <value>hdfs://hadoop-master:9000/</value> 
        </property> 
        <property> 
            <name>dfs.permissions</name> 
            <value>false</value> 
        </property> 
    </configuration>

#### hdfs-site.xml

Open the hdfs-site.xml file and edit it as shown below.

    <configuration>
        <property> 
            <name>dfs.data.dir</name> 
            <value>/opt/hadoop/hadoop/dfs/name/data</value> 
            <final>true</final> 
        </property> 

        <property> 
            <name>dfs.name.dir</name> 
            <value>/opt/hadoop/hadoop/dfs/name</value> 
            <final>true</final> 
        </property> 

        <property> 
            <name>dfs.replication</name> 
            <value>1</value> 
        </property> 
    </configuration>

#### mapred-site.xml

Open the mapred-site.xml file and edit it as shown below.

    <configuration>
        <property> 
            <name>mapred.job.tracker</name> 
            <value>hadoop-master:9001</value> 
        </property> 
    </configuration>

#### hadoop-env.sh

Open the hadoop-env.sh file and edit `JAVA_HOME`, `HADOOP_CONF_DIR`, and `HADOOP_OPTS` as shown below.

Note − Set the `JAVA_HOME` as per your system configuration.

    export JAVA_HOME=/opt/jdk1.7.0_17
    export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true
    export HADOOP_CONF_DIR=/opt/hadoop/hadoop/conf

### Installing Hadoop on Slave Servers

Install Hadoop on all the slave servers by following the given commands.

    # su hadoop 
    $ cd /opt/hadoop 
    $ scp -r hadoop hadoop-slave-1:/opt/hadoop 
    $ scp -r hadoop hadoop-slave-2:/opt/hadoop

### Configuring Hadoop on Master Server

Open the master server and configure it by following the given commands.

    # su hadoop 
    $ cd /opt/hadoop/hadoop

#### Configuring Master Node

    $ vi etc/hadoop/masters

    hadoop-master

#### Configuring Slave Node

    $ vi etc/hadoop/slaves

    hadoop-slave-1 
    hadoop-slave-2

#### Format Name Node on Hadoop Master

    # su hadoop 
    $ cd /opt/hadoop/hadoop 
    $ bin/hadoop namenode –format
    11/10/14 10:58:07 INFO namenode.NameNode: STARTUP_MSG:
    /************************************************************ 
    STARTUP_MSG: Starting NameNode 
    STARTUP_MSG: host = hadoop-master/192.168.1.109 
    STARTUP_MSG: args = [-format] 
    STARTUP_MSG: version = 1.2.0 
    STARTUP_MSG: build = https://svn.apache.org/repos/asf/hadoop/common/branches/branch-1.2 -r 1479473;
    compiled by 'hortonfo' on Mon May 6 06:59:37 UTC 2013 
    STARTUP_MSG: java = 1.7.0_71 

    ************************************************************/
    11/10/14 10:58:08 INFO util.GSet: Computing capacity for map BlocksMap
    editlog=/opt/hadoop/hadoop/dfs/name/current/edits
    ………………………………………………….
    ………………………………………………….
    …………………………………………………. 
    11/10/14 10:58:08 INFO common.Storage: Storage directory 
    /opt/hadoop/hadoop/dfs/name has been successfully formatted.
    11/10/14 10:58:08 INFO namenode.NameNode: 
    SHUTDOWN_MSG:
    /************************************************************
    SHUTDOWN_MSG: Shutting down NameNode at hadoop-master/192.168.1.15
    ************************************************************/

### Starting Hadoop Services

The following command is to start all the Hadoop services on the Hadoop-Master.

    $ cd $HADOOP_HOME/sbin
    $ start-all.sh

### Adding a New DataNode in the Hadoop Cluster

Given below are the steps to be followed for adding new nodes to a Hadoop cluster.

#### Networking

Add new nodes to an existing Hadoop cluster with some appropriate network configuration. Assume the following network configuration.

For New node Configuration −

    IP address : 192.168.1.103 
    netmask : 255.255.255.0
    hostname : slave3.in

#### Adding User and SSH Access

##### Add a User

On a new node, add "hadoop" user and set password of Hadoop user to "hadoop123" or anything you want by using the following commands.

    useradd hadoop
    passwd hadoop

Setup Password less connectivity from master to new slave.

##### Execute the following on the master

    mkdir -p $HOME/.ssh 
    chmod 700 $HOME/.ssh 
    ssh-keygen -t rsa -P '' -f $HOME/.ssh/id_rsa 
    cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys 
    chmod 644 $HOME/.ssh/authorized_keys
    Copy the public key to new slave node in hadoop user $HOME directory
    scp $HOME/.ssh/id_rsa.pub hadoop@192.168.1.103:/home/hadoop/

##### Execute the following on the slaves

Login to hadoop. If not, login to hadoop user.

    su hadoop ssh -X hadoop@192.168.1.103

Copy the content of public key into file "$HOME/.ssh/authorized_keys" and then change the permission for the same by executing the following commands.

    cd $HOME
    mkdir -p $HOME/.ssh 
    chmod 700 $HOME/.ssh
    cat id_rsa.pub >>$HOME/.ssh/authorized_keys 
    chmod 644 $HOME/.ssh/authorized_keys

Check ssh login from the master machine. Now check if you can ssh to the new node without a password from the master.

    ssh hadoop@192.168.1.103 or hadoop@slave3

#### Set Hostname of New Node

You can set hostname in file /etc/sysconfig/network

    On new slave3 machine

    NETWORKING = yes 
    HOSTNAME = slave3.in

To make the changes effective, either restart the machine or run hostname command to a new machine with the respective hostname (restart is a good option).

On slave3 node machine −

hostname slave3.in

Update /etc/hosts on all machines of the cluster with the following lines −

    192.168.1.102 slave3.in slave3

Now try to ping the machine with hostnames to check whether it is resolving to IP or not.

On new node machine −

    ping master.in

#### Start the DataNode on New Node

Start the datanode daemon manually using $HADOOP_HOME/bin/hadoop-daemon.sh script. It will automatically contact the master (NameNode) and join the cluster. We should also add the new node to the conf/slaves file in the master server. The script-based commands will recognize the new node.

##### Login to new node

    su hadoop or ssh -X hadoop@192.168.1.103

##### Start HDFS on a newly added slave node by using the following command

    ./bin/hadoop-daemon.sh start datanode

##### Check the output of jps command on a new node. It looks as follows.

    $ jps
    7141 DataNode
    10312 Jps

### Removing a DataNode from the Hadoop Cluster

We can remove a node from a cluster on the fly, while it is running, without any data loss. HDFS provides a decommissioning feature, which ensures that removing a node is performed safely. To use it, follow the steps as given below −

#### Step 1 − Login to master

Login to master machine user where Hadoop is installed.

    $ su hadoop

#### Step 2 − Change cluster configuration

An exclude file must be configured before starting the cluster. Add a key named dfs.hosts.exclude to our $HADOOP_HOME/etc/hadoop/hdfs-site.xml file. The value associated with this key provides the full path to a file on the NameNode's local file system which contains a list of machines which are not permitted to connect to HDFS.

For example, add these lines to etc/hadoop/hdfs-site.xml file.

    <property> 
        <name>dfs.hosts.exclude</name> 
        <value>/home/hadoop/hadoop-1.2.1/hdfs_exclude.txt</value> 
        <description>DFS exclude</description> 
    </property>

#### Step 3 − Determine hosts to decommission

Each machine to be decommissioned should be added to the file identified by the hdfs_exclude.txt, one domain name per line. This will prevent them from connecting to the NameNode. Content of the "/home/hadoop/hadoop-1.2.1/hdfs_exclude.txt" file is shown below, if you want to remove DataNode2.

    slave2.in

#### Step 4 − Force configuration reload

Run the command "$HADOOP_HOME/bin/hadoop dfsadmin -refreshNodes" without the quotes.

    $ $HADOOP_HOME/bin/hadoop dfsadmin -refreshNodes

This will force the NameNode to re-read its configuration, including the newly updated ‘excludes’ file. It will decommission the nodes over a period of time, allowing time for each node's blocks to be replicated onto machines which are scheduled to remain active.

On slave2.in, check the jps command output. After some time, you will see the DataNode process is shutdown automatically.

#### Step 5 − Shutdown nodes

After the decommission process has been completed, the decommissioned hardware can be safely shut down for maintenance. Run the report command to dfsadmin to check the status of decommission. The following command will describe the status of the decommission node and the connected nodes to the cluster.

    $ $HADOOP_HOME/bin/hadoop dfsadmin -report

#### Step 6 − Edit excludes file again

Once the machines have been decommissioned, they can be removed from the ‘excludes’ file. Running "$HADOOP_HOME/bin/hadoop dfsadmin -refreshNodes" again will read the excludes file back into the NameNode; allowing the DataNodes to rejoin the cluster after the maintenance has been completed, or additional capacity is needed in the cluster again, etc.

**Special Note** − If the above process is followed and the tasktracker process is still running on the node, it needs to be shut down. One way is to disconnect the machine as we did in the above steps. The Master will recognize the process automatically and will declare as dead. There is no need to follow the same process for removing the tasktracker because it is NOT much crucial as compared to the DataNode. DataNode contains the data that you want to remove safely without any loss of data.

The tasktracker can be run/shutdown on the fly by the following command at any point of time.

    $ $HADOOP_HOME/bin/hadoop-daemon.sh stop tasktracker
    $HADOOP_HOME/bin/hadoop-daemon.sh start tasktracker
