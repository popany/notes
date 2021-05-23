# Vue + Spring Boot Demo

- [Vue + Spring Boot Demo](#vue--spring-boot-demo)
  - [Reference](#reference)
  - [Install Vue.js](#install-vuejs)
  - [Project setup](#project-setup)
  - [Create Spring Boot App Using Spring Initializr](#create-spring-boot-app-using-spring-initializr)

## Reference

- [Vue.js Exemples - TodoMVC](https://v3.vuejs.org/examples/todomvc.html)

- [jonashackt/spring-boot-vuejs](https://github.com/jonashackt/spring-boot-vuejs#create-a-new-vue-login-component)

- [Build a Simple CRUD App with Spring Boot and Vue.js](https://developer.okta.com/blog/2018/11/20/build-crud-spring-and-vue)

## Install Vue.js

    yum install -y npm
    npm install -g @vue/cli

## Project setup

    todo_mvc
    ├─┬ backend     → backend module with Spring Boot code
    │ ├── src
    │ └── pom.xml
    ├─┬ frontend    → frontend module with Vue.js code
    │ ├── src
    │ └── pom.xml
    └── pom.xml     → Maven parent pom managing both modules

## Create Spring Boot App Using Spring Initializr

- Specify Spring Boot version

  2.5.0

- Specify project language

  Java

- Input Group Id for your project

  org.example

- Input Artifact Id for your project

  todo_mvc

- Specify packaging type

  jar

- Specify Java version

  8

- Search for dependencies

  - Spring Web WEB

    Build web, including RESTful, applications using Spring MVC. Uses Apache Tomcat as the default embedded container.








