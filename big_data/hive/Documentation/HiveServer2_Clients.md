# [HiveServer2 Clients](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients)

- [HiveServer2 Clients](#hiveserver2-clients)
  - [Beeline – Command Line Shell](#beeline--command-line-shell)
  - [JDBC](#jdbc)
    - [Connection URLs](#connection-urls)
      - [Connection URL Format](#connection-url-format)
      - [Connection URL for Remote or Embedded Mode](#connection-url-for-remote-or-embedded-mode)
      - [Connection URL When HiveServer2 Is Running in HTTP Mode](#connection-url-when-hiveserver2-is-running-in-http-mode)
      - [Connection URL When SSL Is Enabled in HiveServer2](#connection-url-when-ssl-is-enabled-in-hiveserver2)
      - [Connection URL When ZooKeeper Service Discovery Is Enabled](#connection-url-when-zookeeper-service-discovery-is-enabled)
      - [Named Connection URLs](#named-connection-urls)
      - [Reconnecting](#reconnecting)
      - [Using hive-site.xml to automatically connect to HiveServer2](#using-hive-sitexml-to-automatically-connect-to-hiveserver2)
      - [Using beeline-site.xml to automatically connect to HiveServer2](#using-beeline-sitexml-to-automatically-connect-to-hiveserver2)
    - [Using JDBC](#using-jdbc)
      - [JDBC Client Sample Code](#jdbc-client-sample-code)
    - [JDBC Data Types](#jdbc-data-types)
    - [JDBC Client Setup for a Secure Cluster](#jdbc-client-setup-for-a-secure-cluster)
      - [Multi-User Scenarios and Programmatic Login to Kerberos KDC](#multi-user-scenarios-and-programmatic-login-to-kerberos-kdc)
    - [JDBC Fetch Size](#jdbc-fetch-size)
  - [Python Client](#python-client)
  - [Ruby Client](#ruby-client)
  - [Integration with SQuirrel SQL Client](#integration-with-squirrel-sql-client)
  - [Integration with SQL Developer](#integration-with-sql-developer)
  - [Integration with DbVisSoftware's DbVisualizer](#integration-with-dbvissoftwares-dbvisualizer)
  - [Advanced Features for Integration with Other Tools](#advanced-features-for-integration-with-other-tools)

This page describes the different clients supported by [HiveServer2](https://cwiki.apache.org/confluence/display/Hive/Setting+Up+HiveServer2).  Other documentation for HiveServer2 includes:

- [HiveServer2 Overview](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Overview)
- [Setting Up HiveServer2](https://cwiki.apache.org/confluence/display/Hive/Setting+Up+HiveServer2)
- [Hive Configuration Properties:  HiveServer2](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties#ConfigurationProperties-HiveServer2)

|||
|-|-|
|**Version**|Introduced in Hive version 0.11. See HIVE-2935.|
|||

## Beeline – Command Line Shell

## JDBC

HiveServer2 has a JDBC driver. It supports both embedded and remote access to HiveServer2. Remote HiveServer2 mode is recommended for production use, as it is more secure and doesn't require direct HDFS/metastore access to be granted for users.

### Connection URLs

#### Connection URL Format

The HiveServer2 URL is a string with the following syntax:

    jdbc:hive2://<host1>:<port1>,<host2>:<port2>/dbName;initFile=<file>;sess_var_list?hive_conf_list#hive_var_list

where

- `<host1>:<port1>,<host2>:<port2>` is a server instance or a comma separated list of server instances to connect to (if dynamic service discovery is enabled). If empty, the embedded server will be used.
- `dbName` is the name of the initial database.
- `<file>` is the path of init script file ([Hive 2.2.0](https://issues.apache.org/jira/browse/HIVE-5867) and later). This script file is written with SQL statements which will be executed automatically after connection. This option can be empty.
- `sess_var_list` is a semicolon separated list of key=value pairs of session variables (e.g., `user=foo;password=bar`).
- `hive_conf_list` is a semicolon separated list of key=value pairs of Hive configuration variables for this session
- `hive_var_list` is a semicolon separated list of key=value pairs of Hive variables for this session.

Special characters in `sess_var_list`, `hive_conf_list`, `hive_var_list` parameter values should be encoded with URL encoding if needed.

#### Connection URL for Remote or Embedded Mode

The JDBC connection URL format has the prefix `jdbc:hive2://` and the Driver class is `org.apache.hive.jdbc.HiveDriver`. Note that this is different from the old [HiveServer](https://cwiki.apache.org/confluence/display/Hive/HiveServer).

- For a remote server, the URL format is `jdbc:hive2://<host>:<port>/<db>;initFile=<file>` (default port for HiveServer2 is 10000).
- For an embedded server, the URL format is `jdbc:hive2:///;initFile=<file>` (no host or port).

The initFile option is available in [Hive 2.2.0](https://issues.apache.org/jira/browse/HIVE-5867) and later releases.

#### Connection URL When HiveServer2 Is Running in HTTP Mode

JDBC connection URL:  `jdbc:hive2://<host>:<port>/<db>;transportMode=http;httpPath=<http_endpoint>`, where:

- `<http_endpoint>` is the corresponding HTTP endpoint configured in [hive-site.xml](https://cwiki.apache.org/confluence/display/Hive/AdminManual+Configuration#AdminManualConfiguration-ConfiguringHive). Default value is `cliservice`.
- Default port for HTTP transport mode is 10001.

|||
|-|-|
|**Versions earlier than 0.14**|In versions earlier than [0.14](https://issues.apache.org/jira/browse/HIVE-6972) these parameters used to be called [hive.server2.transport.mode](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties#ConfigurationProperties-hive.server2.transport.mode) and [hive.server2.thrift.http.path](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties#ConfigurationProperties-hive.server2.thrift.http.path) respectively and were part of the hive_conf_list. These versions have been deprecated in favour of the new versions (which are part of the sess_var_list) but continue to work for now.|
|||

#### Connection URL When SSL Is Enabled in HiveServer2

JDBC connection URL:  `jdbc:hive2://<host>:<port>/<db>;ssl=true;sslTrustStore=<trust_store_path>;trustStorePassword=<trust_store_password>`, where:

- `<trust_store_path>` is the path where client's truststore file lives.
- `<trust_store_password>` is the password to access the truststore.

In HTTP mode:  `jdbc:hive2://<host>:<port>/<db>;ssl=true;sslTrustStore=<trust_store_path>;trustStorePassword=<trust_store_password>;transportMode=http;httpPath=<http_endpoint>`.

For versions earlier than 0.14, see the [version note](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=82903124#HiveServer2Clients-HIVE-6972) above.

#### Connection URL When ZooKeeper Service Discovery Is Enabled


#### Named Connection URLs


#### Reconnecting


#### Using hive-site.xml to automatically connect to HiveServer2


#### Using beeline-site.xml to automatically connect to HiveServer2

### Using JDBC

You can use JDBC to access data stored in a relational database or other tabular format.

1. Load the HiveServer2 JDBC driver. As of [1.2.0](https://issues.apache.org/jira/browse/HIVE-7998) applications no longer need to explicitly load JDBC drivers using Class.forName().

   For example:

       Class.forName("org.apache.hive.jdbc.HiveDriver");

2. Connect to the database by creating a Connection object with the JDBC driver.

   For example:

       Connection cnct = DriverManager.getConnection("jdbc:hive2://<host>:<port>", "<user>", "<password>");

   The default `<port>` is 10000. In non-secure configurations, specify a `<user>` for the query to run as. The `<password>` field value is ignored in non-secure mode.

       Connection cnct = DriverManager.getConnection("jdbc:hive2://<host>:<port>", "<user>", "");

   In Kerberos secure mode, the user information is based on the Kerberos credentials.

3. Submit SQL to the database by creating a `Statement` object and using its `executeQuery()` method.

   For example:

       Statement stmt = cnct.createStatement();
       ResultSet rset = stmt.executeQuery("SELECT foo FROM bar");

4. Process the result set, if necessary.

These steps are illustrated in the sample code below.

#### JDBC Client Sample Code

### JDBC Data Types

### JDBC Client Setup for a Secure Cluster

#### Multi-User Scenarios and Programmatic Login to Kerberos KDC

### JDBC Fetch Size

## Python Client

## Ruby Client

## Integration with SQuirrel SQL Client 

## Integration with SQL Developer

## Integration with DbVisSoftware's DbVisualizer

## Advanced Features for Integration with Other Tools
