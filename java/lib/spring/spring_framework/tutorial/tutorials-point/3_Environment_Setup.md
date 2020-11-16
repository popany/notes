## [Environment Setup](https://www.tutorialspoint.com/spring/spring_environment_setup.htm)

- [Environment Setup](#environment-setup)
- [Step 1 - Setup Java Development Kit (JDK)](#step-1---setup-java-development-kit-jdk)
- [Step 2 - Install Apache Common Logging API](#step-2---install-apache-common-logging-api)
- [Step 3 - Setup Eclipse IDE](#step-3---setup-eclipse-ide)
- [Step 4 - Setup Spring Framework Libraries](#step-4---setup-spring-framework-libraries)

This chapter will guide you on how to prepare a development environment to start your work with Spring Framework. It will also teach you how to set up JDK, Tomcat and Eclipse on your machine before you set up Spring Framework −

## Step 1 - Setup Java Development Kit (JDK)

You can download the latest version of SDK from Oracle's Java site − [Java SE Downloads](https://www.oracle.com/technetwork/java/javase/downloads/index.html). You will find instructions for installing JDK in downloaded files, follow the given instructions to install and configure the setup. Finally set `PATH` and `JAVA_HOME` environment variables to refer to the directory that contains `java` and `javac`, typically `java_install_dir/bin` and `java_install_dir` respectively.

If you are running Windows and have installed the JDK in `C:\jdk1.6.0_15`, you would have to put the following line in your `C:\autoexec.bat` file.

    set PATH=C:\jdk1.6.0_15\bin;%PATH% 
    set JAVA_HOME=C:\jdk1.6.0_15 

## Step 2 - Install Apache Common Logging API

You can download the latest version of Apache Commons Logging API from <https://commons.apache.org/logging/>. Once you download the installation, unpack the binary distribution into a convenient location. For example, in `C:\commons-logging-1.1.1` on Windows, or `/usr/local/commons-logging-1.1.1` on Linux/Unix. This directory will have the following jar files and other supporting documents, etc.

Make sure you set your `CLASSPATH` variable on this directory properly otherwise you will face a problem while running your application.

## Step 3 - Setup Eclipse IDE

All the examples in this tutorial have been written using Eclipse IDE. So we would suggest you should have the latest version of Eclipse installed on your machine.

To install Eclipse IDE, download the latest Eclipse binaries from <https://www.eclipse.org/downloads/>. Once you download the installation, unpack the binary distribution into a convenient location. For example, in `C:\eclipse on Windows`, or `/usr/local/eclipse` on Linux/Unix and finally set `PATH` variable appropriately.

Eclipse can be started by executing the following commands on Windows machine, or you can simply double-click on eclipse.exe

    C:\eclipse\eclipse.exe 

Eclipse can be started by executing the following commands on Unix (Solaris, Linux, etc.) machine −

    /usr/local/eclipse/eclipse

## Step 4 - Setup Spring Framework Libraries

Now if everything is fine, then you can proceed to set up your Spring framework. Following are the simple steps to download and install the framework on your machine.

- Make a choice whether you want to install Spring on Windows or Unix, and then proceed to the next step to download `.zip` file for Windows and `.tz` file for Unix.

- Download the latest version of Spring framework binaries from <https://repo.spring.io/release/org/springframework/spring>

You will find all the Spring libraries in the directory E:\spring\libs. Make sure you set your CLASSPATH variable on this directory properly otherwise you will face a problem while running your application. If you are using Eclipse, then it is not required to set CLASSPATH because all the setting will be done through Eclipse.

Once you are done with this last step, you are ready to proceed to your first Spring Example in the next chapter.
