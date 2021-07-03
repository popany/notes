# Java

- [Java](#java)
  - [Command line tools](#command-line-tools)
  - [Debug](#debug)
    - [Remote debug](#remote-debug)
    - [Debug tools](#debug-tools)
  - [Decompiler](#decompiler)
  - [Performance Analysis](#performance-analysis)
    - [JMC](#jmc)
  - [Diagnostic](#diagnostic)
  - [jar](#jar)
    - [Uber-JAR](#uber-jar)
  - [Practice](#practice)
    - [ProcessBuilder](#processbuilder)

## Command line tools

[How to compile, package and run a Java program using command-line tools (javac, jar and java)
](https://www.codejava.net/java-core/tools/how-to-compile-package-and-run-a-java-program-using-command-line-tools-javac-jar-and-java)

## Debug

### Remote debug

    java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -jar foo.jar

- `transport=dt_socket`

  means the way used to connect to JVM (socket is a good choice, it can be used to debug a distant computer)

- `address=5005`

  TCP/IP port exposed, to connect from the debugger

- `suspend=y`

  if 'y', tell the JVM to wait until debugger is attached to begin execution, otherwise (if 'n'), starts execution right away.

### Debug tools

- jps

- jstack

- jconsole

- jinfo

## Decompiler

[JD-GUI](http://java-decompiler.github.io/)

[java-decompiler](https://github.com/JetBrains/intellij-community/tree/master/plugins/java-decompiler/engine)

## Performance Analysis

### JMC

    java -Dcom.sun.management.jmxremote=true -Djava.rmi.server.hostname=<ip> -Dcom.sun.management.jmxremote.port=<port> -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.managementote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -XX:+UnlockCommercialFeatures -XX:+FlightRecorder -jar xxx.jar

## Diagnostic

[Arthas](https://arthas.aliyun.com/doc/en/)

## jar

### [Uber-JAR](https://imagej.net/Uber-JAR)

ubar jar is also known as fat jar i.e. jar with dependencies.

There are three common methods for constructing an uber jar:

1. **Unshaded**: Unpack all JAR files, then repack them into a single JAR. Works with Java's default class loader. Tools [maven-assembly-plugin](http://maven.apache.org/plugins/maven-assembly-plugin/)

2. **Shaded**: Same as unshaded, but rename (i.e., "shade") all packages of all dependencies. Works with Java's default class loader. Avoids some (not all) dependency version clashes. Tools [maven-shade-plugin](http://maven.apache.org/plugins/maven-shade-plugin/)

3. **JAR of JARs**: The final JAR file contains the other JAR files embedded within. Avoids dependency version clashes. All resource files are preserved. Tools: [Eclipse JAR File Exporter](http://help.eclipse.org/luna/index.jsp?topic=%2Forg.eclipse.jdt.doc.user%2Freference%2Fref-export-jar.htm)

## Practice

### ProcessBuilder

[Java ProcessBuilder: How to suppress output instead of redirecting it](https://stackoverflow.com/questions/55628999/java-processbuilder-how-to-suppress-output-instead-of-redirecting-it)

## Install

### Windows

- [Java Platform, Standard Edition 8 Reference Implementations](https://jdk.java.net/java-se-ri/8-MR3)

- [Java Platform, Standard Edition 11 Reference Implementations](https://jdk.java.net/java-se-ri/11)
