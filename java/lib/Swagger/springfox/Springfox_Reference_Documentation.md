# [Springfox Reference Documentation](https://springfox.github.io/springfox/docs/current/)

- [Springfox Reference Documentation](#springfox-reference-documentation)
  - [1. Introduction](#1-introduction)
  - [2. Getting Started](#2-getting-started)
    - [2.1. Dependencies](#21-dependencies)
      - [2.1.3. Migrating from existing 2.x version](#213-migrating-from-existing-2x-version)
        - [Spring Boot Applications](#spring-boot-applications)
  - [3. Quick start guides](#3-quick-start-guides)
    - [3.9. Springfox samples](#39-springfox-samples)
  - [4. Architecture](#4-architecture)
  - [5. Swagger](#5-swagger)

## 1. Introduction

The Springfox suite of java libraries are all about automating the generation of machine and human readable specifications for JSON APIs written using the [spring family of projects](http://projects.spring.io/spring-framework). Springfox works by examining an application, once, at runtime to infer API semantics based on spring configurations, class structure and various compile time java Annotations.

## 2. Getting Started

### 2.1. Dependencies

#### 2.1.3. Migrating from existing 2.x version

##### Spring Boot Applications

1. Remove library inclusions of earlier releases. Specifically remove `springfox-swagger2` and `springfox-swagger-ui` inclusions.

2. Remove the `@EnableSwagger2` annotations

3. Add the `springfox-boot-starter`

4. Springfox 3.x removes dependencies on guava and other 3rd party libraries (not zero dep yet! depends on spring plugin and open api libraries for annotations and models) so if you used guava predicates/functions those will need to transition to java 8 function interfaces

## 3. Quick start guides

### 3.9. Springfox samples

The [springfox-demos](https://github.com/springfox/springfox-demos) repository contains a number of samples.

## 4. Architecture

## 5. Swagger

Springfox supports both version [1.2](https://github.com/swagger-api/swagger-spec/blob/master/versions/1.2.md) and version [2.0](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md) of the [Swagger](http://swagger.io/) specification. Where possible, the Swagger 2.0 specification is preferable.






