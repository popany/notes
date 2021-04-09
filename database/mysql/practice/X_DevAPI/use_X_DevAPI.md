# Use X DevAPi

- [Use X DevAPi](#use-x-devapi)
  - [Download](#download)
  - [Build with CMake](#build-with-cmake)
    - [Reference](#reference)
  - [HowTo](#howto)
    - [How to fetch DateTime from mysql using xdevapi](#how-to-fetch-datetime-from-mysql-using-xdevapi)

## Download

[Connector/C++](https://dev.mysql.com/downloads/connector/cpp/)

## Build with CMake

### Reference

- [Using Connector/C++ 8.0](https://dev.mysql.com/doc/dev/connector-cpp/8.0/usage.html)

  When compiling code which is linked with the connector library statically, define `STATIC_CONCPP` macro before including Connector/C++ public headers. This macro adjusts API declarations in the headers for usage with the static library.

- [Building Connector/C++ Applications](https://dev.mysql.com/doc/connector-cpp/8.0/en/connector-cpp-apps.html)

## HowTo

### [How to fetch DateTime from mysql using xdevapi](https://stackoverflow.com/questions/52137654/how-to-fetch-datetime-from-mysql-using-xdevapi)

Hey I just spend 5 hours tring to figure out the same thing, the solution is to project the `TIME`/`DATE`/`DATETIME` field as a UNIX timestamp (integer) in your SQL Statement using `UNIX_TIMESTAMP()`.

Then you can easily get the field as [`time_t`](http://www.cplusplus.com/reference/ctime/time_t/) (and optionally convert to a [`struct tm`](http://www.cplusplus.com/reference/ctime/tm/)).

    #include<time.h>

    mysqlx::Session session{"mysqlx://root:password@127.0.0.1:33060/catalog"};
    auto row = session.sql("SELECT UNIX_TIMESTAMP(create_time) FROM information_schema.tables ORDER BY 1 LIMIT 1").execute().fetchOne();
    time_t creationTime = (int) row[0];
    struct tm* creationTimePoint = localtime(creationTime);
