# [Logback](http://logback.qos.ch/index.html)

- [Logback](#logback)
  - [Logback Project](#logback-project)

## [Logback Project](http://logback.qos.ch/index.html)

Logback is intended as a successor to the popular log4j project, [picking up where log4j leaves off](http://logback.qos.ch/reasonsToSwitch.html).

Logback's architecture is sufficiently generic so as to apply under different circumstances. At present time, logback is divided into three modules, logback-core, logback-classic and logback-access.

The logback-core module lays the groundwork for the other two modules. The logback-classic module can be assimilated to a significantly improved version of log4j. Moreover, logback-classic natively implements the [SLF4J API](http://www.slf4j.org/) so that you can readily switch back and forth between logback and other logging frameworks such as log4j or java.util.logging (JUL).

The logback-access module integrates with Servlet containers, such as Tomcat and Jetty, to provide HTTP-access log functionality. Note that you could easily build your own module on top of logback-core.


