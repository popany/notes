# Data Source

- [Data Source](#data-source)
  - [Mysql](#mysql)

## Mysql

pom.xml

    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.25</version>
    </dependency>

application.yml

    spring:
      datasource:
        driver-class-name: com.mysql.cj.jdbc.Driver
        url: jdbc:mysql://${MYSQL_HOST:localhost}:3306/db_test
        username: test
        password: test
        schema: classpath:db/schema-h2.sql
        data: classpath:db/data-h2.sql

note:

- [Changes in the Connector/J API](https://dev.mysql.com/doc/connector-j/8.0/en/connector-j-api-changes.html)

reference:

- [Connect Java to a MySQL Database](https://www.baeldung.com/java-connect-mysql)

- [Spring Boot Connect to MySQL Database Examples](https://www.codejava.net/frameworks/spring-boot/connect-to-mysql-database-examples)

- [Spring Boot – DataSource configuration](https://howtodoinjava.com/spring-boot2/datasource-configuration/)
