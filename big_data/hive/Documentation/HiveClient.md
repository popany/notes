# [HiveClient](https://cwiki.apache.org/confluence/display/Hive/HiveClient)

- [HiveClient](#hiveclient)
  - [Command Line](#command-line)
  - [JDBC](#jdbc)

This page describes the different clients supported by Hive. The command line client currently only supports an embedded server. The JDBC and Thrift-Java clients support both embedded and standalone servers. Clients in other languages only support standalone servers.

For details about the standalone server see [Hive Server](https://cwiki.apache.org/confluence/display/Hive/HiveServer) or [HiveServer2](https://cwiki.apache.org/confluence/display/Hive/Setting+Up+HiveServer2).

## Command Line

Operates in embedded mode only, that is, it needs to have access to the Hive libraries. For more details see [Getting Started](https://cwiki.apache.org/confluence/display/Hive/GettingStarted) and [Hive CLI](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Cli).

## JDBC

**This document describes the JDBC client for the original [Hive Server](https://cwiki.apache.org/confluence/display/Hive/HiveServer) (sometimes called Thrift server or HiveServer1). For information about the HiveServer2 JDBC client, see [JDBC in the HiveServer2 Clients document](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-JDBC). HiveServer2 use is recommended; the original HiveServer has several concurrency issues and lacks several features available in HiveServer2.**

|||
|-|-|
|**Version information**|The original [Hive Server](https://cwiki.apache.org/confluence/display/Hive/HiveServer) was removed from Hive releases starting in [version 1.0.0](https://cwiki.apache.org/confluence/display/Hive/Home#Home-HiveVersions). See [HIVE-6977](https://issues.apache.org/jira/browse/HIVE-6977).|
|||

For embedded mode, uri is just "jdbc:hive://". For standalone server, uri is "jdbc:hive://host:port/dbname" where host and port are determined by where the Hive server is run. For example, "jdbc:hive://localhost:10000/default". Currently, the only dbname supported is "default".

