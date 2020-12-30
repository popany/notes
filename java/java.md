# Java

- [Java](#java)
  - [Command line tools](#command-line-tools)
  - [Debug tools](#debug-tools)
  - [jar](#jar)
    - [Uber-JAR](#uber-jar)
  - [Practice](#practice)
    - [ProcessBuilder](#processbuilder)

## Command line tools

[How to compile, package and run a Java program using command-line tools (javac, jar and java)
](https://www.codejava.net/java-core/tools/how-to-compile-package-and-run-a-java-program-using-command-line-tools-javac-jar-and-java)

## Debug tools

- jps

- jstack

- jconsole

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
