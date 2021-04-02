# [MySQL Connector/C++ Documentation](https://dev.mysql.com/doc/dev/connector-cpp/8.0/)

- [MySQL Connector/C++ Documentation](#mysql-connectorc-documentation)

MySQL Connector/C++ is a library for applications written in C or C++ that communicate with MySQL database servers. Version 8.0 of Connector/C++ implements three different APIs which can be used by applications:

- The new [X DevAPI](https://dev.mysql.com/doc/dev/connector-cpp/8.0/devapi_ref.html) for applications written in C++.
- The new [X DevAPI for C](https://dev.mysql.com/doc/dev/connector-cpp/8.0/xapi_ref.html) for applications written in plain C.
- The [legacy JDBC4-based API](https://dev.mysql.com/doc/dev/connector-cpp/8.0/jdbc_ref.html) also implemented in version 1.1 of the connector.

The new APIs give access to MySQL implementing a document store. Internally these APIs use the new X Protocol to communicate with the MySQL Server. Consequently, code written against these APIs can work only with MySQL Server 8 with the X Plugin enabled in it. Apart from accessing the document store, the new APIs allow executing traditional SQL queries as well.

Applications written against the JDBC4 based API of Connector/C++ 1.1 can be also compiled with Connector/C++ 8.0 which is backward compatible with the earlier version. Such code does not require the X Plugin and can communicate with older versions of the MySQL Server using the legacy protocol.

The API to be used is chosen by including appropriate set of headers, as explained in [Using Connector/C++ 8.0](https://dev.mysql.com/doc/dev/connector-cpp/8.0/usage.html).

More information:

- [Connector/C++ X DevAPI Reference](https://dev.mysql.com/doc/dev/connector-cpp/8.0/group__devapi.html)
- [Connector/C++ X DevAPI for C Reference](https://dev.mysql.com/doc/dev/connector-cpp/8.0/group__xapi.html)
- [How to build code that uses Connector/C++](https://dev.mysql.com/doc/dev/connector-cpp/8.0/usage.html)
- [Indexing Document Collections](https://dev.mysql.com/doc/dev/connector-cpp/8.0/indexing.html)

See also our [online documentation](https://dev.mysql.com/doc/connector-cpp/8.0/en/)
