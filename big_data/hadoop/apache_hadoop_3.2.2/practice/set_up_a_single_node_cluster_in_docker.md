# Setting up a Single Node Cluster in Docker

- [Setting up a Single Node Cluster in Docker](#setting-up-a-single-node-cluster-in-docker)
  - [Reference](#reference)
  - [Download & Config](#download--config)
  - [`Dockerfile`](#dockerfile)
  - [build image](#build-image)
  - [run container](#run-container)

## Reference

[Hadoop: Setting up a Single Node Cluster](https://hadoop.apache.org/docs/r3.2.2/hadoop-project-dist/hadoop-common/SingleCluster.html)

## Download & Config

    curl -o hadoop-3.2.2.tar.gz https://ftp.yz.yamagata-u.ac.jp/pub/network/apache/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz
    
    tar zxf hadoop-3.2.2.tar.gz

    # config hdfs
    ## edit etc/hadoop/hadoop-env.sh
    sed -i 's:# export JAVA_HOME=:export JAVA_HOME=/usr/lib/jvm/java-openjdk:' hadoop-3.2.2/etc/hadoop/hadoop-env.sh

    ## edit etc/hadoop/core-site.xml
    sed -i '/<configuration>/,/<\/configuration>/c\
    <configuration>\
        <property>\
            <name>fs.defaultFS<\/name>\
            <value>hdfs://localhost:9000<\/value>\
        <\/property>\
    <\/configuration>' hadoop-3.2.2/etc/hadoop/core-site.xml

    ## edit etc/hadoop/hdfs-site.xml:
    sed -i '/<configuration>/,/<\/configuration>/c\
    <configuration>\
        <property>\
            <name>dfs.replication<\/name>\
            <value>1<\/value>\
        <\/property>\
    <\/configuration>' hadoop-3.2.2/etc/hadoop/hdfs-site.xml

    # config yarn
    ## edit etc/hadoop/mapred-site.xml:
    sed -i '/<configuration>/,/<\/configuration>/c\
    <configuration>\
        <property>\
            <name>mapreduce.framework.name<\/name>\
            <value>yarn<\/value>\
        <\/property>\
        <property>\
            <name>mapreduce.application.classpath<\/name>\
            <value>$HADOOP_MAPRED_HOME\/share\/hadoop\/mapreduce\/*:$HADOOP_MAPRED_HOME\/share\/hadoop\/mapreduce\/lib\/*<\/value>\
        <\/property>\
    <\/configuration>' hadoop-3.2.2/etc/hadoop/mapred-site.xml

    ## edit etc/hadoop/yarn-site.xml:
    sed -i '/<configuration>/,/<\/configuration>/c\
    <configuration>\
        <property>\
            <name>yarn.nodemanager.aux-services<\/name>\
            <value>mapreduce_shuffle<\/value>\
        <\/property>\
        <property>\
            <name>yarn.nodemanager.env-whitelist<\/name>\
            <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME<\/value>\
        <\/property>\
    <\/configuration>' hadoop-3.2.2/etc/hadoop/yarn-site.xml

## `Dockerfile`

Reference: <https://github.com/CentOS/CentOS-Dockerfiles/blob/master/ssh/centos7/Dockerfile>

    FROM centos:8

    RUN yum -y update; yum clean all
    RUN yum -y install openssh-server openssh-clients passwd java-1.8.0-openjdk-devel; yum clean all
    ADD ./start.sh /start.sh
    RUN mkdir /var/run/sshd
    RUN ssh-keygen -A
    RUN chmod 755 /start.sh
    RUN ./start.sh

    EXPOSE 22 9000 9870 8088
    WORKDIR /opt/hadoop
    ENV JAVA_HOME=/usr/lib/jvm/java-openjdk
    ENV HDFS_NAMENODE_USER=hdp
    ENV HDFS_DATANODE_USER=hdp
    ENV HDFS_SECONDARYNAMENODE_USER=hdp
    ENV YARN_RESOURCEMANAGER_USER=hdp
    ENV YARN_NODEMANAGER_USER=hdp

    USER hdp
    RUN ssh-keygen -t rsa -b 4096 -N '' -f ~/.ssh/id_rsa
    RUN cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
    RUN chmod 600 ~/.ssh/authorized_keys
    USER root

    CMD /usr/sbin/sshd;\
        rm /run/nologin;\
        test ! -d /tmp/hadoop-hdp && bin/hdfs namenode -format;\
        sbin/start-dfs.sh;\
        sbin/start-yarn.sh;\
        /bin/bash

`start.sh`

    #!/bin/bash

    __create_user() {
    # Create a user to SSH into as.
    useradd hdp
    SSH_USERPASS=123
    echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin hdp)
    echo ssh hdp password: $SSH_USERPASS
    }

    # Call all functions
    __create_user

## build image

    docker build -t hadoop-demo:3.2.2 .

## run container

    docker run --name hadoop -tid -P -v$(pwd)/hadoop-3.2.2:/opt/hadoop hadoop-demo:3.2.2
