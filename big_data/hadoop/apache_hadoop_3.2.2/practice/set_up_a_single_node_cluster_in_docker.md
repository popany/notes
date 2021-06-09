# Setting up a Single Node Cluster in Docker

- [Setting up a Single Node Cluster in Docker](#setting-up-a-single-node-cluster-in-docker)
  - [Reference](#reference)
  - [Build docker image](#build-docker-image)
    - [Download package](#download-package)
    - [`Dockerfile`](#dockerfile)
  - [](#)

## Reference

[Hadoop: Setting up a Single Node Cluster](https://hadoop.apache.org/docs/r3.2.2/hadoop-project-dist/hadoop-common/SingleCluster.html)

## Build docker image

### Download package

    curl -o hadoop-3.2.2.tar.gz https://ftp.yz.yamagata-u.ac.jp/pub/network/apache/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz
    
    tar zxf hadoop-3.2.2.tar.gz

### `Dockerfile`

    FROM centos:8

    ENV TZ Asia/Shanghai
    ENV LANG C.UTF-8

    COPY hadoop-3.2.2 /opt

## 

docker build -t demo:1.0 .
