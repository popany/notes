# maven practice

- [maven practice](#maven-practice)
  - [Deploy WAR File to Tomcat](#deploy-war-file-to-tomcat)
  - [Official Examples](#official-examples)
  - [maven-assembly-plugin doesn't add dependencies with system scope](#maven-assembly-plugin-doesnt-add-dependencies-with-system-scope)

## Deploy WAR File to Tomcat

[How to Deploy a WAR File to Tomcat](https://www.baeldung.com/tomcat-deploy-war)

[How do I deploy a maven web application to Tomcat?](http://avajava.com/tutorials/lessons/how-do-i-deploy-a-maven-web-application-to-tomcat.html)

[tomcat7-maven-plugin – Tomcat Maven Plugin to Deploy WAR](https://www.journaldev.com/4738/tomcat7-maven-plugin-deploy-war)

[Maven - Using tomcat-maven-plugin to deploy war file to Tomcat server](https://www.logicbig.com/tutorials/build-tools/apache-maven/tomcat-maven-plugin.html)

[tomcat - Deployment](https://tomcat.apache.org/maven-plugin-trunk/tomcat6-maven-plugin/examples/deployment.html)

## Official Examples

[Adding and Filtering External Web Resources](http://maven.apache.org/plugins/maven-war-plugin/examples/adding-filtering-webresources.html)

## [maven-assembly-plugin doesn't add dependencies with system scope](https://stackoverflow.com/questions/2588502/maven-assembly-plugin-doesnt-add-dependencies-with-system-scope)

[Adding a custom jar as a maven dependency](https://blog.valdaris.com/post/custom-jar/)

On maven 2.2:

    mvn org.apache.maven.plugins:maven-install-plugin:2.3.1:install-file -Dfile=tools.jar -DgroupId=com.sun -DartifactId=tools -Dversion=1.8.0 -Dpackaging=jar -DlocalRepositoryPath=c:\tmp

On maven 2.3 and onwards:

    mvn install:install-file -Dfile=tools.jar -DgroupId=com.sun -DartifactId=tools -Dversion=1.8.0 -Dpackaging=jar -DlocalRepositoryPath=c:\tmp
