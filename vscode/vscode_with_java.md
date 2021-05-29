# vscode with java

- [vscode with java](#vscode-with-java)
  - [reference](#reference)
  - [Debug](#debug)
    - [Attach to process](#attach-to-process)
  - [JDK Version](#jdk-version)
    - [Configure the JDK](#configure-the-jdk)

## reference

[microsoft/vscode-java-debug](https://github.com/microsoft/vscode-java-debug/blob/main/Configuration.md)

## Debug

### Attach to process

start process

    /usr/lib/jvm/java-1.8-openjdk/bin/java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -Dlogging.config=classpath:logback-master.xml -Ddruid.mysql.usePingMethod=false -server -Xms4g -Xmx4g -Xmn2g -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=128m -Xss512k -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:LargePageSizeInBytes=128m -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -XX:+PrintGCDetails -Xloggc:gc.log -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=dump.hprof -classpath /opt/dolphinscheduler/bin/../conf:/opt/dolphinscheduler/bin/../lib/* org.apache.dolphinscheduler.server.master.MasterServer

launch.json

    {
        // Use IntelliSense to learn about possible attributes.
        // Hover to view descriptions of existing attributes.
        // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
        "version": "0.2.0",
        "configurations": [
            {
                "type": "java",
                "name": "Attach to Remote Program",
                "request": "attach",
                "hostName": "172.20.0.6",
                "port": 5005,
                "mainClass": "org.apache.dolphinscheduler.server.master.MasterServer",
                "projectName": "dolphinscheduler-server"
            }
        ]
    }

## JDK Version

reference: [Configure JDK](https://code.visualstudio.com/docs/java/java-project#_configure-jdk)

Two configurations

- `java.configuration.runtimes`

  specifies options for project's execution environment

- `java.home`

  specifies language server's execution environment

NOTE: Although the Java language server requires JDK version 11 or above to run, this is NOT a requirement to your project's runtime.

### Configure the JDK

opening the Command Palette (Ctrl+Shift+P) and typing the command Java: `Configure Java Runtime`

- Project JDKs

- Java Tooling Runtime
