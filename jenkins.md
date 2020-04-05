# Jenkins

- [Jenkins](#jenkins)
  - [Jenkins User Documentation](#jenkins-user-documentation)
    - [What is Jenkins](#what-is-jenkins)
    - [About this documentation](#about-this-documentation)
    - [Documentation scope](#documentation-scope)
    - [Guided Tour](#guided-tour)
      - [Getting started with the Guided Tour](#getting-started-with-the-guided-tour)
        - [Prerequisites](#prerequisites)
        - [Download and run Jenkins](#download-and-run-jenkins)
      - [Creating your first Pipeline](#creating-your-first-pipeline)
        - [What is a Jenkins Pipeline](#what-is-a-jenkins-pipeline)
  - [Official Jenkins Docker image](#official-jenkins-docker-image)
    - [Usage](#usage)
      - [Backing up data](#backing-up-data)
    - [Setting the number of executors](#setting-the-number-of-executors)
    - [Attaching build executors](#attaching-build-executors)
    - [Passing JVM parameters](#passing-jvm-parameters)
    - [Configuring logging](#configuring-logging)
    - [Configuring reverse proxy](#configuring-reverse-proxy)
    - [Passing Jenkins launcher parameters](#passing-jenkins-launcher-parameters)
    - [Installing more tools](#installing-more-tools)
      - [Preinstalling plugins](#preinstalling-plugins)
        - [Setting update centers](#setting-update-centers)
        - [Plugin version format](#plugin-version-format)
        - [Fine-tune the downloads](#fine-tune-the-downloads)
        - [Other environment variables](#other-environment-variables)
        - [Script usage](#script-usage)
    - [Upgrading](#upgrading)
      - [Upgrading plugins](#upgrading-plugins)
      - [Hacking](#hacking)
  - [Practice](#practice)
    - [Get latest LTS](#get-latest-lts)
    - [Run jenkins container](#run-jenkins-container)
  - [.Net 自动化构建](#net-%e8%87%aa%e5%8a%a8%e5%8c%96%e6%9e%84%e5%bb%ba)

## [Jenkins User Documentation](https://jenkins.io/doc/)

### What is Jenkins

Jenkins is a self-contained, open source **automation server** which can be used to automate all sorts of tasks related to **building**, **testing**, and **delivering** or **deploying** software.

Jenkins can be installed through native system packages, Docker, or even run standalone by any machine with a Java Runtime Environment (JRE) installed.

### About this documentation

This documentation begins with a [Guided Tour](https://jenkins.io/doc/pipeline/tour/getting-started/) to help you get up and running with Jenkins and introduce you to Jenkins’s main feature, Pipeline.

There are also [tutorials](https://jenkins.io/doc/tutorials/) geared to developers who want to orchestrate and automate building their project in Jenkins using Pipeline and Blue Ocean.

If you’ve never used Jenkins before or have limited Jenkins experience, then the Guided Tour and introductory tutorials are good places to start.

If you are looking for more detailed information about using Jenkins, please refer to the [User Handbook](https://jenkins.io/doc/book/getting-started/).

### Documentation scope

Jenkins is a highly extensible product whose functionality can be extended through the installation of plugins.

There are a vast array of plugins available to Jenkins. However, the documentation covered in the [Guided Tour](https://jenkins.io/doc/pipeline/tour/getting-started/), [Tutorials](https://jenkins.io/doc/tutorials/), [Solution pages](https://jenkins.io//solutions/) and [User Handbook](https://jenkins.io/doc/book/getting-started/) of this documentation are based on a [Jenkins installation](https://jenkins.io/doc/book/installing/) with the [Blue Ocean plugins installed](https://jenkins.io/doc/book/blueocean/getting-started/), as well as the "suggested plugins", which are specified when running through the [Post-installation setup wizard](https://jenkins.io/doc/book/installing/#setup-wizard).

### Guided Tour

#### Getting started with the Guided Tour

This guided tour introduces you to the basics of using Jenkins and its main feature, Jenkins **Pipeline**. This tour uses the "standalone" Jenkins distribution, which runs locally on your own machine.

##### Prerequisites

For this tour, you will require:

- A machine with:
  - 256 MB of RAM, although more than 512MB is recommended
  - 10 GB of drive space (for Jenkins and your Docker image)

- The following software installed:
  - Java 8 or 11 (either a JRE or Java Development Kit (JDK) is fine)
  - Docker (navigate to Get Docker at the top of the website to access the [Docker download](https://hub.docker.com/r/jenkins/jenkins) that’s suitable for your platform)

##### Download and run Jenkins

1. Download Jenkins.
2. Open up a terminal in the download directory.
3. Run `java -jar jenkins.war --httpPort=8080`.
4. Browse to http://localhost:8080.
5. Follow the instructions to complete the installation.

#### Creating your first Pipeline

##### What is a Jenkins Pipeline

Jenkins Pipeline (or simply "Pipeline") is a suite of plugins which supports implementing and integrating continuous delivery pipelines into Jenkins.

A continuous delivery pipeline is an automated expression of your process for getting software from version control right through to your users and customers.

Jenkins Pipeline provides an extensible set of tools for modeling simple-to-complex delivery pipelines "as code". The definition of a Jenkins Pipeline is typically written into a text file (called a `Jenkinsfile`) which in turn is checked into a project’s source control repository.

For more information about Pipeline and what a `Jenkinsfile` is, refer to the respective [Pipeline](https://jenkins.io/doc/book/pipeline) and [Using a Jenkinsfile](https://jenkins.io/doc/book/pipeline/jenkinsfile) sections of the User Handbook.

To get started quickly with Pipeline:






























## [Official Jenkins Docker image](https://github.com/jenkinsci/docker/blob/master/README.md)

The Jenkins Continuous Integration and Delivery server [available on Docker Hub](https://hub.docker.com/r/jenkins/jenkins).

This is a fully functional Jenkins server. [https://jenkins.io/](https://jenkins.io/).

### Usage

    docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts

NOTE: read below the build executors part for the role of the `50000` port mapping.

This will store the workspace in `/var/jenkins_home`. All **Jenkins data** lives in there - including **plugins** and **configuration**. You will probably want to make that an explicit volume so you can manage it and attach to another container for upgrades:

    docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts

this will **automatically create** a `jenkins_home` [docker volume](https://docs.docker.com/storage/volumes/) on the host machine, that will survive the container stop/restart/deletion.

NOTE: **Avoid** using a [bind mount](https://docs.docker.com/storage/bind-mounts/) from a folder on the host machine into `/var/jenkins_home`, as this might result in **file permission issues** (the user used inside the container might not have rights to the folder on the host machine). If you really need to bind mount `jenkins_home`, ensure that the directory on the host is accessible by the jenkins user inside the container (jenkins user - uid 1000) or use `-u some_other_user` parameter with `docker run`.

    docker run -d -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts

this will run Jenkins in **detached mode** with port forwarding and volume added. You can access logs with command `docker logs CONTAINER_ID` in order to check first login token. ID of container will be returned from output of command above.

#### Backing up data

If you bind mount in a volume - you can simply back up that directory (which is `jenkins_home`) at any time.

This is highly recommended. Treat the `jenkins_home` directory as you would a database - in Docker you would generally put a database on a volume.

If your volume is inside a container - you can use `docker cp $ID:/var/jenkins_home` command to extract the data, or other options to find where the volume data is. Note that some symlinks on some OSes may be converted to copies (this can confuse jenkins with lastStableBuild links etc)

For more info check Docker docs section on [Managing data in containers](https://docs.docker.com/engine/tutorials/dockervolumes/)

### Setting the number of executors

You can specify and set the number of executors of your Jenkins master instance using a groovy script. By default its set to 2 executors, but you can extend the image and change it to your desired number of executors :

`executors.groovy`

    import jenkins.model.*
    Jenkins.instance.setNumExecutors(5)

and `Dockerfile`

    FROM jenkins/jenkins:lts
    COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

### Attaching build executors

You can run builds on the master out of the box.
But if you want to attach build slave servers through JNLP (Java Web Start): make sure you map the port: -p 50000:50000 - which will be used when you connect a slave agent.

If you are only using [SSH slaves](https://wiki.jenkins-ci.org/display/JENKINS/SSH+Slaves+plugin), then you do **NOT** need to put that port mapping.

### Passing JVM parameters

You might need to customize the JVM running Jenkins, typically to pass system properties ([list of props](https://wiki.jenkins.io/display/JENKINS/Features+controlled+by+system+properties)) or tweak heap memory settings. Use `JAVA_OPTS` environment variable for this purpose:

    docker run --name myjenkins -p 8080:8080 -p 50000:50000 --env JAVA_OPTS=-Dhudson.footerURL=http://mycompany.com jenkins/jenkins:lts

### Configuring logging

Jenkins logging can be configured through a properties file and `java.util.logging.config.file` Java property. For example:

    mkdir data
    cat > data/log.properties <<EOF
    handlers=java.util.logging.ConsoleHandler
    jenkins.level=FINEST
    java.util.logging.ConsoleHandler.level=FINEST
    EOF
    docker run --name myjenkins -p 8080:8080 -p 50000:50000 --env JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties" -v `pwd`/data:/var/jenkins_home jenkins/jenkins:lts

### Configuring reverse proxy

If you want to install Jenkins behind a reverse proxy with prefix, example: mysite.com/jenkins, you need to add environment variable `JENKINS_OPTS="--prefix=/jenkins"` and then follow the below procedures to configure your reverse proxy, which will depend if you have Apache or Nginx:

    [Apache](https://wiki.jenkins-ci.org/display/JENKINS/Running+Jenkins+behind+Apache)
    [Nginx](https://wiki.jenkins-ci.org/display/JENKINS/Jenkins+behind+an+NGinX+reverse+proxy)

### Passing Jenkins launcher parameters

Argument you pass to docker running the jenkins image are passed to jenkins launcher, so you can run for sample:

    docker run jenkins/jenkins:lts --version

This will dump Jenkins version, just like when you run jenkins as an executable war.

You also can define jenkins arguments as `JENKINS_OPTS`. This is usefull to define a set of arguments to pass to jenkins launcher as you define a derived jenkins image based on the official one with some customized settings. The following sample Dockerfile uses this option to force use of HTTPS with a certificate included in the image

    FROM jenkins/jenkins:lts

    COPY https.pem /var/lib/jenkins/cert
    COPY https.key /var/lib/jenkins/pk
    ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8083 --httpsCertificate=/var/lib/jenkins/cert --httpsPrivateKey=/var/lib/jenkins/pk
    EXPOSE 8083

You can also change the default slave agent port for jenkins by defining `JENKINS_SLAVE_AGENT_PORT` in a sample Dockerfile.

    FROM jenkins/jenkins:lts
    ENV JENKINS_SLAVE_AGENT_PORT 50001

or as a parameter to docker,

    docker run --name myjenkins -p 8080:8080 -p 50001:50001 --env JENKINS_SLAVE_AGENT_PORT=50001 jenkins/jenkins:lts

Note: This environment variable will be used to set the port adding the system property `jenkins.model.Jenkins.slaveAgentPort` to `JAVA_OPTS`.

If this property is already set in `JAVA_OPTS`, then the value of `JENKINS_SLAVE_AGENT_PORT` will be ignored.

### Installing more tools

You can run your container as root - and install via apt-get, install as part of build steps via jenkins tool installers, or you can create your own Dockerfile to customise, for example:

    FROM jenkins/jenkins:lts
    # if we want to install via apt
    USER root
    RUN apt-get update && apt-get install -y ruby make more-thing-here
    # drop back to the regular jenkins user - good practice
    USER jenkins

In such a derived image, you can customize your jenkins instance with hook scripts or additional plugins. For this purpose, use `/usr/share/jenkins/ref` as a place to define the default `JENKINS_HOME` content you wish the target installation to look like:

    FROM jenkins/jenkins:lts
    COPY custom.groovy /usr/share/jenkins/ref/init.groovy.d/custom.groovy

#### Preinstalling plugins

You can rely on the `install-plugins.sh` script to pass a set of plugins to download with their dependencies. This script will perform downloads from update centers, and internet access is required for the default update centers.

##### Setting update centers

##### Plugin version format

##### Fine-tune the downloads

##### Other environment variables

##### Script usage

### Upgrading

#### Upgrading plugins

#### Hacking

## Practice

### Get latest LTS

    docker pull jenkins/jenkins:lts

### Run jenkins container

    docker run --name myjenkins -d -v jenkins_home:/var/jenkins_home -p 8081:8080 -p 50001:50000 jenkins/jenkins:lts

## .Net 自动化构建

[jenkins部署.net平台自动化构建](https://www.cnblogs.com/shenh/p/8946404.html)

[Jenkins 部署.NET 自动化构建](https://testerhome.com/topics/9743)

[Jenkins自动化构建.net问题解决方案](https://blog.csdn.net/RainyLin/article/details/79302519)


























