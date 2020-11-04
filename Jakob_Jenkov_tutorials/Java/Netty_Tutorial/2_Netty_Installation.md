# [Netty Installation](http://tutorials.jenkov.com/netty/installation.html)

- [Netty Installation](#netty-installation)
  - [Installing Netty Using Maven](#installing-netty-using-maven)

Installing Netty in your Java project only requires that you download the Netty JAR files and include them on the classpath.

## Installing Netty Using Maven

Installing Netty most easily done using [Maven](http://tutorials.jenkov.com/maven/index.html), by inserting the following Maven dependencies into the dependencies section of the POM for your Java project:

    <dependency>
        <groupId>io.netty</groupId>
        <artifactId>netty-all</artifactId>
        <version>4.1.16.Final</version>
    </dependency>

Remember to exchange the versions in the XML above with the version of Netty you plan to use.
