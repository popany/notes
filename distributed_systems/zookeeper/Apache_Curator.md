# [Apache Curator](https://curator.apache.org/)

- [Apache Curator](#apache-curator)
  - [What is Curator?](#what-is-curator)
  - [Maven / Artifacts](#maven--artifacts)

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




