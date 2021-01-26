# [Logback](http://logback.qos.ch/index.html)

- [Logback](#logback)
  - [Logback Project](#logback-project)
  - [Logback configuration](#logback-configuration)
    - [The initialization steps that logback follows to try to configure itself](#the-initialization-steps-that-logback-follows-to-try-to-configure-itself)

## [Logback Project](http://logback.qos.ch/index.html)

Logback is intended as a successor to the popular log4j project, [picking up where log4j leaves off](http://logback.qos.ch/reasonsToSwitch.html).

Logback's architecture is sufficiently generic so as to apply under different circumstances. At present time, logback is divided into three modules, logback-core, logback-classic and logback-access.

The logback-core module lays the groundwork for the other two modules. The logback-classic module can be assimilated to a significantly improved version of log4j. Moreover, logback-classic natively implements the [SLF4J API](http://www.slf4j.org/) so that you can readily switch back and forth between logback and other logging frameworks such as log4j or java.util.logging (JUL).

The logback-access module integrates with Servlet containers, such as Tomcat and Jetty, to provide HTTP-access log functionality. Note that you could easily build your own module on top of logback-core.

## [Logback configuration](http://logback.qos.ch/manual/configuration.html)

### The initialization steps that logback follows to try to configure itself

1. Logback tries to find a file called `logback-test.xml` [in the classpath](http://logback.qos.ch/faq.html#configFileLocation).

2. If no such file is found, logback tries to find a file called `logback.groovy` [in the classpath](http://logback.qos.ch/faq.html#configFileLocation).

3. If no such file is found, it checks for the file `logback.xml` [in the classpath](http://logback.qos.ch/faq.html#configFileLocation).

4. If no such file is found, [service-provider loading facility](http://docs.oracle.com/javase/6/docs/api/java/util/ServiceLoader.html) (introduced in JDK 1.6) is used to resolve the implementation of [com.qos.logback.classic.spi.Configurator](http://logback.qos.ch/xref/ch/qos/logback/classic/spi/Configurator.html) interface by looking up the file `META-INF\services\ch.qos.logback.classic.spi.Configurator` in the class path. Its contents should specify the fully qualified class name of the desired `Configurator` implementation.

5. If none of the above succeeds, logback configures itself automatically using the [BasicConfigurator](http://logback.qos.ch/xref/ch/qos/logback/classic/BasicConfigurator.html) which will cause logging output to be directed to the console.

The last step is meant as last-ditch effort to provide a default (but very basic) logging functionality in the absence of a configuration file.

If you are using Maven and if you place the `logback-test.xml` under the `src/test/resources` folder, Maven will ensure that it won't be included in the artifact produced. Thus, you can use a different configuration file, namely `logback-test.xml` during testing, and another file, namely, `logback.xml`, in production.
