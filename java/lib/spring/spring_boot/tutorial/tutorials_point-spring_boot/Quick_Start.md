# [Quick Start](https://www.tutorialspoint.com/spring_boot/spring_boot_quick_start.htm)

- [Quick Start](#quick-start)
  - [Prerequisites](#prerequisites)
  - [Spring Boot CLI](#spring-boot-cli)

This chapter will teach you how to create a Spring Boot application using Maven and Gradle.

## Prerequisites

Your system need to have the following minimum requirements to create a Spring Boot application −

- Java 7
- Maven 3.2
- Gradle 2.5

## Spring Boot CLI

The Spring Boot CLI is a command line tool and it allows us to run the Groovy scripts. This is the easiest way to create a Spring Boot application by using the Spring Boot Command Line Interface. You can create, run and test the application in command prompt itself.

This section explains you the steps involved in manual installation of Spring Boot CLI. For further help, you can use the following link: <https://docs.spring.io/springboot/> docs/current-SNAPSHOT/reference/htmlsingle/#getting-started-installing-springboot

You can also download the Spring CLI distribution from the Spring Software repository at: <https://docs.spring.io/spring-boot/docs/current-SNAPSHOT/reference/htmlsingle/#getting-started-manual-cli-installation>

For manual installation, you need to use the following two folders −

    spring-boot-cli-2.0.0.BUILD-SNAPSHOT-bin.zip

    spring-boot-cli-2.0.0.BUILD-SNAPSHOT-bin.tar.gz

After the download, unpack the archive file and follow the steps given in the `install.txt` file. Not that it does not require any environment setup.

In Windows, go to the Spring Boot CLI bin directory in the command prompt and run the command spring –-version to make sure spring CLI is installed correctly. After executing the command, you can see the spring CLI version as shown below −

    spring --version

Run Hello World with Groovy

Create a simple groovy file which contains the Rest Endpoint script and run the groovy file with spring boot CLI. Observe the code shown here for this purpose −

    @Controller
    class Example {
        @RequestMapping("/")
        @ResponseBody
        public String hello() {
            "Hello Spring Boot"
        }
    }

Now, save the groovy file with the name hello.groovy. Note that in this example, we saved the groovy file inside the Spring Boot CLI bin directory. Now run the application by using the command spring run hello.groovy as shown in the screenshot given below −

    spring run hello.groovy








