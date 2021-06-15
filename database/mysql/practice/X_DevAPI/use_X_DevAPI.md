# Use X DevAPi

- [Use X DevAPi](#use-x-devapi)
  - [Download](#download)
  - [Build with CMake](#build-with-cmake)
    - [Reference](#reference)
  - [Connection](#connection)
    - [Connection pool](#connection-pool)
    - [Connection Settings](#connection-settings)
    - [Autocommint](#autocommint)
  - [HowTo](#howto)
    - [How to fetch DateTime from mysql using xdevapi](#how-to-fetch-datetime-from-mysql-using-xdevapi)

## Download

[Connector/C++](https://dev.mysql.com/downloads/connector/cpp/)

## Build with CMake

### Reference

- [Using Connector/C++ 8.0](https://dev.mysql.com/doc/dev/connector-cpp/8.0/usage.html)

  When compiling code which is linked with the connector library statically, define `STATIC_CONCPP` macro before including Connector/C++ public headers. This macro adjusts API declarations in the headers for usage with the static library.

- [Building Connector/C++ Applications](https://dev.mysql.com/doc/connector-cpp/8.0/en/connector-cpp-apps.html)

## Connection

### Connection pool

example 1: [2.2.3 Connecting to a Single MySQL Server Using Connection Pooling](https://dev.mysql.com/doc/x-devapi-userguide/en/connecting-connection-pool.html)

    using namespace mysqlx;

    Client cli("user:password@host_name/db_name", ClientOption::POOL_MAX_SIZE, 7);
    Session sess = cli.getSession();

    // use Session sess as usual

    cli.close();  // close all Sessions

example 2: [Client Class Reference](https://dev.mysql.com/doc/dev/connector-cpp/8.0/class_client.html)

    Client from_uri("mysqlx://user:pwd\@host:port/db?ssl-mode=disabled");
    
    Client from_options("host", port, "user", "pwd", "db");
    
    Client from_option_list(
        SessionOption::USER, "user",
        SessionOption::PWD,  "pwd",
        SessionOption::HOST, "host",
        SessionOption::PORT, port,
        SessionOption::DB,   "db",
        SessionOption::SSL_MODE, SSLMode::DISABLED
        ClientOption::POOLING, true,
        ClientOption::POOL_MAX_SIZE, 10,
        ClientOption::POOL_QUEUE_TIMEOUT, 1000,
        ClientOption::POOL_MAX_IDLE_TIME, 500,
    );

### Connection Settings

[ClientOption Class Reference](https://dev.mysql.com/doc/dev/connector-cpp/8.0/classmysqlx_1_1abi2_1_1r0_1_1_client_option.html)

|||
|-|-|
POOLING|disable/enable the pool. (Enabled by default)
POOL_MAX_SIZE|size of the pool. (Defaults to 25)
POOL_QUEUE_TIMEOUT|timeout for waiting for a connection in the pool (ms). (No timeout by default)
POOL_MAX_IDLE_TIME|time for a connection to be in the pool without being used (ms).(Will not expire by default)
|||

[SessionOption Class Reference](https://dev.mysql.com/doc/dev/connector-cpp/8.0/classmysqlx_1_1abi2_1_1r0_1_1_session_option.html)

|||
|-|-|
URI|connection URI or string
HOST|DNS name of the host, IPv4 address or IPv6 address
PORT|X Plugin port to connect to
PRIORITY|Assign a priority (a number in range 1 to 100) to the last specified host; these priorities are used to determine the order in which multiple hosts are tried by the connection fail-over logic (see description of [Session](https://dev.mysql.com/doc/dev/connector-cpp/8.0/class_session.html) class)
USER|user name
PWD|password
DB|default database
SSL_MODE|Specify [SSLMode](https://dev.mysql.com/doc/dev/connector-cpp/8.0/devapi_2settings_8h.html#SSLMode) option to be used. In plain C code the value should be a #mysqlx_ssl_mode_t enum constant.
SSL_CA|path to a PEM file specifying trusted root certificates
AUTH|Authentication method to use, see [AuthMethod](https://dev.mysql.com/doc/dev/connector-cpp/8.0/devapi_2settings_8h.html#AuthMethod). In plain C code the value should be a #mysqlx_auth_method_t enum constant.
SOCKET|unix socket path
CONNECT_TIMEOUT|Sets connection timeout in milliseconds. In C++ code can be also set to a std::chrono::duration value.
CONNECTION_ATTRIBUTES|Specifies connection attributes (key-value pairs) to be sent when a session is created. The value is a JSON string (in C++ code can be also a [DbDoc](https://dev.mysql.com/doc/dev/connector-cpp/8.0/classmysqlx_1_1abi2_1_1r0_1_1_db_doc.html) object) defining additional attributes to be sent on top of the default ones. Setting this option to false (in C++ code) or NULL (in plain C code) disables sending any connection attributes (including the default ones). Setting it to true (in C++ code) or empty string (in plain C code) requests sending only the default attributes which is also the default behavior when this option is not set.
TLS_VERSIONS|List of allowed TLS protocol versions, such as "TLSv1.2". The value is a string with comma separated versions. In C++ code it can also be an iterable container with versions.
TLS_CIPHERSUITES|List of allowed TLS cipher suites. The value is a string with comma separated IANA cipher suitenames (such as "TLS_RSA_WITH_3DES_EDE_CBC_SHA"). In C++ code it can also be an iterable container with names. Unknown cipher suites are silently ignored.
DNS_SRV|If enabled (true) will check hostname for DNS SRV record and use its configuration (hostname, port, priority and weight) to connect.
COMPRESSION|enable or disable compression
COMPRESSION_ALGORITHMS|Specify compression algorithms in order of preference
|||

### Autocommint

reference: [8.3 Working with Locking](https://dev.mysql.com/doc/x-devapi-userguide/en/working-with-locking.html)

- [autocommit](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_autocommit) mode means that there is always a transaction open, which is commited automatically when an SQL statement executes.

- By default sessions are in autocommit mode.

- You disable autocommit mode implicitly when you call startTransaction().

- When in autocommit mode, if a lock is acquired, it is released after the statement finishes. This could lead you to conclude that the locks were not acquired, but that is not the case.

- Similarly, if you try to acquire a lock that is already owned by someone else, the statement blocks until the other lock is released.

## HowTo

### [How to fetch DateTime from mysql using xdevapi](https://stackoverflow.com/questions/52137654/how-to-fetch-datetime-from-mysql-using-xdevapi)

Hey I just spend 5 hours tring to figure out the same thing, the solution is to project the `TIME`/`DATE`/`DATETIME` field as a UNIX timestamp (integer) in your SQL Statement using `UNIX_TIMESTAMP()`.

Then you can easily get the field as [`time_t`](http://www.cplusplus.com/reference/ctime/time_t/) (and optionally convert to a [`struct tm`](http://www.cplusplus.com/reference/ctime/tm/)).

    #include<time.h>

    mysqlx::Session session{"mysqlx://root:password@127.0.0.1:33060/catalog"};
    auto row = session.sql("SELECT UNIX_TIMESTAMP(create_time) FROM information_schema.tables ORDER BY 1 LIMIT 1").execute().fetchOne();
    time_t creationTime = (int) row[0];
    struct tm* creationTimePoint = localtime(creationTime);
