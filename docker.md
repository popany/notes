# docker

- [docker](#docker)
  - [教程](#%e6%95%99%e7%a8%8b)
    - [Docker入门实践（精讲版）](#docker%e5%85%a5%e9%97%a8%e5%ae%9e%e8%b7%b5%e7%b2%be%e8%ae%b2%e7%89%88)
  - [网络](#%e7%bd%91%e7%bb%9c)
  - [networking](#networking)
    - [Use host networking](#use-host-networking)
    - [Networking using the host network](#networking-using-the-host-network)
  - [volume](#volume)
    - [Use volumes](#use-volumes)
      - [Create and manage volumes](#create-and-manage-volumes)
        - [Create a volume](#create-a-volume)
        - [List volumes](#list-volumes)
        - [Inspect a volume](#inspect-a-volume)
        - [Remove a volume](#remove-a-volume)
      - [Start a container with a volume](#start-a-container-with-a-volume)
  - [cmd](#cmd)
    - [run a centos container](#run-a-centos-container)
      - [Run a centos container in Docker Desktop](#run-a-centos-container-in-docker-desktop)
    - [Commit a container and change ENTRYPOINT](#commit-a-container-and-change-entrypoint)
    - [Move Docker container to another host](#move-docker-container-to-another-host)
      - [Export and import containers](#export-and-import-containers)
      - [Container image migration](#container-image-migration)
      - [Migrate data volumes](#migrate-data-volumes)
  - [Troubleshooting](#troubleshooting)
    - [Error pulling image : no matching manifest](#error-pulling-image--no-matching-manifest)
      - [Find the OS/Arch of you system](#find-the-osarch-of-you-system)
      - [Find the OS/Arch of the image you want to download](#find-the-osarch-of-the-image-you-want-to-download)
  - [Docker Desktop for Windows](#docker-desktop-for-windows)
    - [Logs and troubleshooting](#logs-and-troubleshooting)
    - [Windows and containers](#windows-and-containers)
    - [Get started with Docker for Windows](#get-started-with-docker-for-windows)
      - [Switch between Windows and Linux containers](#switch-between-windows-and-linux-containers)
    - [Get started: Prep Windows for containers](#get-started-prep-windows-for-containers)
    - [Get started: Run your first Windows container](#get-started-run-your-first-windows-container)
      - [Install a container base image](#install-a-container-base-image)
      - [Run a Windows container](#run-a-windows-container)
    - [Docker Engine on Windows](#docker-engine-on-windows)
    - [Container Tools in Visual Studio](#container-tools-in-visual-studio)
    - [Build and run your first Docker Windows Server container](#build-and-run-your-first-docker-windows-server-container)
    - [.NET Framework Docker Samples](#net-framework-docker-samples)
      - [Try a pre-built .NET Framework Docker Image](#try-a-pre-built-net-framework-docker-image)
      - [Building .NET Framework Apps with Docker](#building-net-framework-apps-with-docker)
      - [Related Docker Hub Repos](#related-docker-hub-repos)
        - [.NET Framework](#net-framework)
        - [.NET Core](#net-core)
  - [Install & Update](#install--update)
    - [Get Docker Engine - Community for CentOS](#get-docker-engine---community-for-centos)
      - [Uninstall old versions](#uninstall-old-versions)
      - [Install Docker Engine - Community](#install-docker-engine---community)
        - [Install using the repository](#install-using-the-repository)
          - [Set up the repository](#set-up-the-repository)
          - [Install Docker Engine - Community](#install-docker-engine---community-1)
  - [Q & A](#q--a)
    - [Can Windows Containers be hosted on linux?](#can-windows-containers-be-hosted-on-linux)

## 教程

### [Docker入门实践（精讲版）](http://c.biancheng.net/docker/)

## 网络

[Docker：网络模式详解](https://www.cnblogs.com/zuxing/articles/8780661.html)

[Docker 网络-端口映射、容器链接、Networking](https://itbilu.com/linux/docker/Ey5dT-i2G.html)

[docker 网络配置](https://www.jianshu.com/p/d84cdfe2ea86)

[Docker学习笔记：Docker 网络配置](http://www.docker.org.cn/dockerppt/111.html)

## networking

### [Use host networking](https://docs.docker.com/network/host/)

### [Networking using the host network](https://docs.docker.com/network/network-tutorial-host/)

## volume

### [Use volumes](https://docs.docker.com/storage/volumes)

#### Create and manage volumes

##### Create a volume

    docker volume create my-vol

##### List volumes

    docker volume ls

##### Inspect a volume

    docker volume inspect my-vol

##### Remove a volume

    docker volume rm my-vol

#### Start a container with a volume

    docker run -d --name devtest --mount source=myvol2,target=/app nginx:latest

or

    docker run -d --name devtest -v myvol2:/app nginx:latest

## cmd

### run a centos container

    docker volume create vol_a

    docker run -d --name test --network host -v vol_a:/app -ti centos

#### Run a centos container in Docker Desktop

    docker run -d --name test --network host --mount type=bind,source="/c/test",target=/app -ti centos

### [Commit a container and change ENTRYPOINT](https://stackoverflow.com/questions/29015023/docker-commit-created-images-and-entrypoint)

    docker commit --change='ENTRYPOINT ["/bin/bash"]' <container-name> <image-name>

### [Move Docker container to another host](https://bobcares.com/blog/move-docker-container-to-another-host/)

#### Export and import containers

Export:

    docker export container-name | gzip > container-name.gz

Import:

    zcat container-name.gz | docker import - container-name

The new container created in the new host can be accessed using `docker run` command.

One **drawback** of export tool is that, it does not copy ports and variables, or the underlying data volume which contains the container data.

This can lead to errors when trying to load the container in another host. In such cases, we opt for Docker image migration to move containers from one host to another.

#### Container image migration

Save the container's image

    docker commit container-id image-name
    docker save image-name > image-name.tar

Load image in new host

    cat image-name.tar | docker load

#### Migrate data volumes

When Docker containers or images are moved from one host to another using export or commit tools, the underlying data volume is not migrated.

In such situations, the directory containing data is manually moved to the new host. Then containers are created there with reference to that directory as its data volume.

Another fool proof method is to backup and restore the data volume by passing ‘–volumes-from’ parameter in the ‘docker run’ command.

    docker run --rm --volumes-from datavolume-name -v $(pwd):/backup image-name tar cvf  backup.tar /path-to-datavolume

This command provides a backup of the data volume. The backup generated can be moved to new host via scp or ftp tools.

Copied backup is then extracted and restored to the data volume in the new container there.

    docker run --rm --volumes-from datavolume-name -v $(pwd):/backup image-name bash -c "cd /path-to-datavolume && tar xvf /backup/backup.tar --strip 1"

## Troubleshooting

### [Error pulling image : no matching manifest](https://success.docker.com/article/error-pulling-image-no-matching-manifest)

#### Find the OS/Arch of you system

    docker info  -f '{{.OSType}}/{{.Architecture}}'

#### Find the OS/Arch of the image you want to download

    docker manifest inspect -v library/tomcat:latest | jq .[].Platform

## Docker Desktop for Windows

### [Logs and troubleshooting](https://docs.docker.com/docker-for-windows/troubleshoot/)

### [Windows and containers](https://docs.microsoft.com/en-us/virtualization/windowscontainers/about/)

### [Get started with Docker for Windows](https://docs.docker.com/docker-for-windows/)

#### Switch between Windows and Linux containers

From the Docker Desktop menu, you can toggle which daemon (Linux or Windows) the Docker CLI talks to. Select **Switch to Windows containers** to use Windows containers, or select **Switch to Linux containers** to use Linux containers (the default).

### [Get started: Prep Windows for containers](https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/set-up-environment?tabs=Windows-10-Client)

### [Get started: Run your first Windows container](https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/run-your-first-container)

#### Install a container base image

    docker pull mcr.microsoft.com/windows/nanoserver:1903

#### Run a Windows container

1. Start a container with an interactive session from the nanoserver image

    docker run -it mcr.microsoft.com/windows/nanoserver:1903 cmd.exe

2. Create a simple ‘Hello World’ text file and then exit the container

    echo "Hello World!" > Hello.txt
    exit

3. Get the container ID

    docker ps -a

4. Create a new 'HelloWorld' image

    docker commit \<containerid\> helloworld

5. Run the new container by using the docker run command with the --rm parameter that automatically removes the container once the command line (cmd.exe) stops.

    docker run --rm helloworld cmd.exe /s /c type Hello.txt

### [Docker Engine on Windows](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon)

### [Container Tools in Visual Studio](https://docs.microsoft.com/en-us/visualstudio/containers/overview?view=vs-2019)

### [Build and run your first Docker Windows Server container](https://www.docker.com/blog/build-your-first-docker-windows-server-container/)

### [.NET Framework Docker Samples](https://github.com/microsoft/dotnet-framework-docker/blob/master/samples/README.md)

#### Try a pre-built .NET Framework Docker Image

    docker run --rm mcr.microsoft.com/dotnet/framework/samples:dotnetapp

#### Building .NET Framework Apps with Docker

[NET Framework Console Docker Sample](https://github.com/microsoft/dotnet-framework-docker/blob/master/samples/dotnetapp/README.md) - This sample builds, tests, and runs the sample. It includes and builds multiple projects.

#### Related Docker Hub Repos

##### .NET Framework

- [dotnet/framework/sdk](https://hub.docker.com/_/microsoft-dotnet-framework-sdk/): .NET Framework SDK
- [dotnet/framework/aspnet](https://hub.docker.com/_/microsoft-dotnet-framework-aspnet/): ASP.NET Web Forms and MVC
- [dotnet/framework/runtime](https://hub.docker.com/_/microsoft-dotnet-framework-runtime/): .NET Framework Runtime
- [dotnet/framework/wcf](https://hub.docker.com/_/microsoft-dotnet-framework-wcf/): Windows Communication Foundation (WCF)
- [dotnet/framework/samples](https://hub.docker.com/_/microsoft-dotnet-framework-samples/): .NET Framework, ASP.NET and WCF Samples

##### .NET Core

- [dotnet/core](https://hub.docker.com/_/microsoft-dotnet-core/): .NET Core
- [dotnet/core/samples](https://hub.docker.com/_/microsoft-dotnet-core-samples/): .NET Core Samples
- [dotnet/core-nightly](https://hub.docker.com/_/microsoft-dotnet-core-nightly/): .NET Core (Preview)

## Install & Update

### [Get Docker Engine - Community for CentOS](https://docs.docker.com/install/linux/docker-ce/centos/)

#### Uninstall old versions

Older versions of Docker were called `docker` or `docker-engine`. If these are installed, uninstall them, along with associated dependencies.

    yum remove docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-engine

It’s OK if yum reports that none of these packages are installed.

The contents of `/var/lib/docker/`, including images, containers, volumes, and networks, are **preserved**. The Docker Engine - Community package is now called `docker-ce`.

#### Install Docker Engine - Community

##### Install using the repository

###### Set up the repository

- Install required packages. `yum-utils` provides the `yum-config-manager` utility, and `device-mapper-persistent-data` and `lvm2` are required by the `devicemapper` storage driver.

    yum install -y yum-utils \
        device-mapper-persistent-data \
        lvm2

- Use the following command to set up the stable repository.

    yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo

- Optional: Enable the nightly or test repositories.

###### Install Docker Engine - Community

- Install the latest version of Docker Engine - Community and containerd

        yum install docker-ce docker-ce-cli containerd.io

- Start Docker

        systemctl start docker

- Verify that Docker Engine - Community is installed correctly by running the hello-world image.

        docker run hello-world

## Q & A

### [Can Windows Containers be hosted on linux?](https://stackoverflow.com/questions/42158596/can-windows-containers-be-hosted-on-linux)

