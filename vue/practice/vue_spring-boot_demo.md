# Vue + Spring Boot Demo

- [Vue + Spring Boot Demo](#vue--spring-boot-demo)
  - [Reference](#reference)
  - [Install Vue.js](#install-vuejs)
  - [Create Project](#create-project)
    - [Project structure](#project-structure)
    - [Create Project script](#create-project-script)
  - [Coding](#coding)
  - [Build Project](#build-project)
    - [Compile](#compile)
    - [Package](#package)

## Reference

- [Vue.js Exemples - TodoMVC](https://v3.vuejs.org/examples/todomvc.html)

- [jonashackt/spring-boot-vuejs](https://github.com/jonashackt/spring-boot-vuejs#create-a-new-vue-login-component)

- [Build a Simple CRUD App with Spring Boot and Vue.js](https://developer.okta.com/blog/2018/11/20/build-crud-spring-and-vue)

- [Create a single page app with Spring Boot and Vue.js](https://dev.to/tunaranch/create-a-single-page-app-with-spring-boot-and-vue-js-2on)

- [Serve Static Resources with Spring](https://www.baeldung.com/spring-mvc-static-resources)

## Install Vue.js

    yum install -y npm
    npm install -g @vue/cli

## Create Project

### Project structure

    todo_mvc
    ├─┬ backend     → backend module with Spring Boot code
    │ ├── src
    │ └── pom.xml
    ├─┬ frontend    → frontend module with Vue.js code
    │ ├── src
    │ └── pom.xml
    └── pom.xml     → Maven parent pom managing both modules

### Create Project script

    # Create Spring Boot App
    curl https://start.spring.io/starter.tgz -d dependencies=web,devtools \
        -d bootVersion=2.5.0 \
        -d type=maven-project \
        -d packaging=jar \
        -d language=java \
        -d javaVersion=11 \
        -d groupId=org.example \
        -d artifactId=todo_mvc \
        -d name=todo_mvc \
        -d baseDir=todo_mvc | tar -xzvf -

    # Change Directory Structure

    cd todo_mvc
    mkdir backend
    mv src backend/
    mv pom.xml backend/

    # Modify ./backend/pom.xml

    # change artifactId
    sed -i 's/<artifactId>todo_mvc<\/artifactId>/<artifactId>backend<\/artifactId>/' backend/pom.xml

    # change name
    sed -i 's/<name>todo_mvc<\/name>/<name>backend<\/name>/' backend/pom.xml

    # change parent
    sed -i '/<parent>/,/<\/parent>/c\
        <parent>\
            <groupId>org.example<\/groupId>\
            <artifactId>todo_mvc<\/artifactId>\
            <version>0.0.1-SNAPSHOT<\/version>\
        </parent>' backend/pom.xml

    # add build plugin to copy content from frontend
    sed -i '/<build>/,/<\/build>/c\
        <build>\
            <plugins>\
                <plugin>\
                    <groupId>org.springframework.boot<\/groupId>\
                    <artifactId>spring-boot-maven-plugin<\/artifactId>\
                <\/plugin>\
                <plugin>\
                    <artifactId>maven-resources-plugin<\/artifactId>\
                    <executions>\
                        <execution>\
                            <id>copy Vue.js frontend content<\/id>\
                            <phase>generate-resources<\/phase>\
                            <goals>\
                                <goal>copy-resources<\/goal>\
                            <\/goals>\
                            <configuration>\
                                <outputDirectory>src\/main\/resources\/public<\/outputDirectory>\
                                <overwrite>true<\/overwrite>\
                                <resources>\
                                    <resource>\
                                        <directory>${project.parent.basedir}\/frontend\/dist<\/directory>\
                                        <includes>\
                                            <include>css\/<\/include>\
                                            <include>favicon.ico<\/include>\
                                            <include>img\/<\/include>\
                                            <include>index.html<\/include>\
                                            <include>js\/<\/include>\
                                        <\/includes>\
                                    <\/resource>\
                                <\/resources>\
                            <\/configuration>\
                        <\/execution>\
                    <\/executions>\
                <\/plugin>\
            <\/plugins>\
        <\/build>' backend\/pom.xml

    # Create vue project

    #Vue CLI v4.5.13
    #? Please pick a preset: Manually select features
    #? Check the features needed for your project: Choose Vue version, Babel, Router, Linter
    #? Choose a version of Vue.js that you want to start the project with 3.x
    #? Use history mode for router? (Requires proper server setup for index fallback in production) Yes
    #? Pick a linter / formatter config: Prettier
    #? Pick additional lint features: Lint on save
    #? Where do you prefer placing config for Babel, ESLint, etc.? In dedicated config files

    vue create frontend \
        --no-git -i '{
      "useConfigFiles": true,
      "plugins": {
        "@vue/cli-plugin-babel": {},
        "@vue/cli-plugin-router": {
          "historyMode": true
        },
        "@vue/cli-plugin-eslint": {
          "config": "prettier",
          "lintOn": [
            "save"
          ]
        }
      },
      "vueVersion": "3"
    }'

    # Create ./frontend/pom.xml

    cat > ./frontend/pom.xml <<EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <artifactId>frontend</artifactId>
        <packaging>pom</packaging>

        <parent>
            <groupId>org.example</groupId>
            <artifactId>todo_mvc</artifactId>
            <version>0.0.1-SNAPSHOT</version>
        </parent>

        <properties>
            <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
            <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
            <frontend-maven-plugin.version>1.12.0</frontend-maven-plugin.version>
        </properties>

        <build>
            <plugins>
                <plugin>
                    <groupId>com.github.eirslett</groupId>
                    <artifactId>frontend-maven-plugin</artifactId>
                    <version>\${frontend-maven-plugin.version}</version>
                    <executions>
                        <!-- Install our node and npm version to run npm/node scripts-->
                        <execution>
                            <id>install node and npm</id>
                            <goals>
                                <goal>install-node-and-npm</goal>
                            </goals>
                            <configuration>
                                <nodeVersion>v15.8.0</nodeVersion>
                            </configuration>
                        </execution>
                        <!-- Install all project dependencies -->
                        <execution>
                            <id>npm install</id>
                            <goals>
                                <goal>npm</goal>
                            </goals>
                            <!-- optional: default phase is "generate-resources" -->
                            <phase>generate-resources</phase>
                            <!-- Optional configuration which provides for running any npm command -->
                            <configuration>
                                <arguments>install</arguments>
                            </configuration>
                        </execution>
                        <!-- Build and minify static files -->
                        <execution>
                            <id>npm run build</id>
                            <goals>
                                <goal>npm</goal>
                            </goals>
                            <configuration>
                                <arguments>run build</arguments>
                            </configuration>
                        </execution>
                    </executions>
                </plugin>
            </plugins>
        </build>
    </project>
    EOF

    # Create Root pom.xml

    cat > pom.xml <<EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>2.5.0</version>
            <relativePath/> <!-- lookup parent from repository -->
        </parent>
        <groupId>org.example</groupId>
        <artifactId>todo_mvc</artifactId>
        <version>0.0.1-SNAPSHOT</version>
        <packaging>pom</packaging>
        <name>todo_mvc</name>
        <description>Demo project for Spring Boot</description>

        <modules>
            <module>frontend</module>
            <module>backend</module>
        </modules>

    </project>
    EOF

## Coding

...

## Build Project

### Compile

    ./mvnv compile

node version v15.8.0 will be installed into  /note/java/java_programming/learn_vue/todo_mvc/frontend/node

add `note/` into frontend/.gitignore to ignore this directory

### Package

    ./mvnv package


