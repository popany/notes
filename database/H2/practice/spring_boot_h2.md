# Spring Boot H2

- [Spring Boot H2](#spring-boot-h2)
  - [Config](#config)

## Config

    # DataSource Config
    spring:
      datasource:
        driver-class-name: org.h2.Driver
        schema: classpath:db/schema-h2.sql
        data: classpath:db/data-h2.sql
        url: jdbc:h2:mem:test
        username: root
        password: test
      h2:
        console:
          enabled: true
          path: /h2-console
          trace: true
          settings:
            web-allow-others: true
