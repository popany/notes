# [MySQL Connector/C++ 8.0 Developer Guide](https://dev.mysql.com/doc/connector-cpp/8.0/en/)

- [MySQL Connector/C++ 8.0 Developer Guide](#mysql-connectorc-80-developer-guide)
  - [Chapter 1 Introduction to Connector/C++](#chapter-1-introduction-to-connectorc)
  - [Platform Support and Prerequisites](#platform-support-and-prerequisites)

This manual describes how to install and configure MySQL Connector/C++ 8.0, which provides C++ and plain C interfaces for communicating with MySQL servers, and how to use Connector/C++ to develop database applications.

Connector/C++ 8.0 is highly recommended for use with MySQL Server 8.0 and 5.7. Please upgrade to Connector/C++ 8.0.

## [Chapter 1 Introduction to Connector/C++](https://dev.mysql.com/doc/connector-cpp/8.0/en/connector-cpp-introduction.html)

Connector/C++ applications that use X DevAPI or X DevAPI for C require a MySQL server that has [X Plugin](https://dev.mysql.com/doc/refman/8.0/en/x-plugin.html) enabled. Connector/C++ applications that use the legacy JDBC-based API neither require nor support X Plugin.

## Platform Support and Prerequisites

To see which platforms are supported, visit the [Connector/C++ downloads page](https://dev.mysql.com/downloads/connector/cpp/).

- Connector/C++ 8.0.19 and higher: VC++ Redistributable 2017 or higher.

- Connector/C++ 8.0.14 to 8.0.18: VC++ Redistributable 2015 or higher.
