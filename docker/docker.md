# docker

- [docker](#docker)
  - [Install & Update](#install--update)
    - [Get Docker Engine - Community for CentOS](#get-docker-engine---community-for-centoshttpsdocsdockercominstalllinuxdocker-cecentos)
      - [Uninstall old versions](#uninstall-old-versions)
      - [Install Docker Engine - Community](#install-docker-engine---community)
        - [Install using the repository](#install-using-the-repository)
          - [Set up the repository](#set-up-the-repository)
          - [Install Docker Engine - Community](#install-docker-engine---community-1)
  - [教程](#教程)
    - [Docker入门实践（精讲版）](#docker入门实践精讲版httpcbianchengnetdocker)
  - [networking](#networking)
    - [docker 网络](#docker-网络)
    - [Use host networking](#use-host-networkinghttpsdocsdockercomnetworkhost)
    - [Networking using the host network](#networking-using-the-host-networkhttpsdocsdockercomnetworknetwork-tutorial-host)
  - [volume](#volume)
    - [Use volumes](#use-volumeshttpsdocsdockercomstoragevolumes)
      - [Create and manage volumes](#create-and-manage-volumes)
        - [Create a volume](#create-a-volume)
        - [List volumes](#list-volumes)
        - [Inspect a volume](#inspect-a-volume)
        - [Remove a volume](#remove-a-volume)
      - [Start a container with a volume](#start-a-container-with-a-volume)
      - [Backup, restore, or migrate data volumes](#backup-restore-or-migrate-data-volumes)
        - [Backup a container](#backup-a-container)
        - [Restore container from backup](#restore-container-from-backup)
      - [Remove volumes](#remove-volumes)
        - [Remove anonymous volumes](#remove-anonymous-volumes)
        - [Remove all volumes](#remove-all-volumes)
  - [logging](#logging)
    - [View logs for a container or service](#view-logs-for-a-container-or-servicehttpsdocsdockercomconfigcontainerslogging)
  - [cmd](#cmd)
    - [run a centos container](#run-a-centos-container)
      - [Run a centos container in Docker Desktop](#run-a-centos-container-in-docker-desktop)
      - [Publish container port 8080 to the host port 8081](#publish-container-port-8080-to-the-host-port-8081)
    - [Override CMD when running a docker image](#override-cmd-when-running-a-docker-image)
    - [Copy files/folders between a container and the local filesystem](#copy-filesfolders-between-a-container-and-the-local-filesystem)
    - [Commit a container and change ENTRYPOINT](#commit-a-container-and-change-entrypointhttpsstackoverflowcomquestions29015023docker-commit-created-images-and-entrypoint)
    - [Move Docker container to another host](#move-docker-container-to-another-hosthttpsbobcarescomblogmove-docker-container-to-another-host)
    - [Remove the volumes associated with the container](#remove-the-volumes-associated-with-the-container)
      - [Export and import containers](#export-and-import-containers)
      - [Container image migration](#container-image-migration)
    - [`docker logs`](#docker-logs)
  - [Troubleshooting](#troubleshooting)
    - [Error pulling image : no matching manifest](#error-pulling-image--no-matching-manifesthttpssuccessdockercomarticleerror-pulling-image-no-matching-manifest)
      - [Find the OS/Arch of you system](#find-the-osarch-of-you-system)
      - [Find the OS/Arch of the image you want to download](#find-the-osarch-of-the-image-you-want-to-download)
  - [Q & A](#q--a)
    - [Can Windows Containers be hosted on linux?](#can-windows-containers-be-hosted-on-linuxhttpsstackoverflowcomquestions42158596can-windows-containers-be-hosted-on-linux)
  - [Practice](#practice)
    - [ssh into a centos container](#ssh-into-a-centos-container)
      - [`/usr/sbin/sshd`](#usrsbinsshd)

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

## 教程

### [Docker入门实践（精讲版）](http://c.biancheng.net/docker/)

## networking

### docker 网络

[Docker：网络模式详解](https://www.cnblogs.com/zuxing/articles/8780661.html)

[Docker 网络-端口映射、容器链接、Networking](https://itbilu.com/linux/docker/Ey5dT-i2G.html)

[docker 网络配置](https://www.jianshu.com/p/d84cdfe2ea86)

[Docker学习笔记：Docker 网络配置](http://www.docker.org.cn/dockerppt/111.html)

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

If you start a container with a volume that does not yet exist, Docker creates the volume for you.

- use `--mount`

      docker run -d --name devtest --mount source=myvol2,target=/app nginx:latest

- user `-v`

      docker run -d --name devtest -v myvol2:/app nginx:latest

#### Backup, restore, or migrate data volumes

Volumes are useful for backups, restores, and migrations. Use the `--volumes-from` flag to create a new container that mounts that volume.

##### Backup a container

For example, create a new container named `dbstore`:

    docker run -v /dbdata --name dbstore centos /bin/bash

Then in the next command, we:

- Launch a new container and mount the volume from the `dbstore` container
- Mount a local host directory as `/backup`
- Pass a command that tars the contents of the `dbdata` volume to a `backup.tar` file inside our `/backup` directory.

    docker run --rm --volumes-from dbstore -v $(pwd):/backup centos tar cvf /backup/backup.tar /dbdata

When the command completes and the container stops, we are left with a backup of our `dbdata` volume.

##### Restore container from backup

With the backup just created, you can restore it to the same container, or another that you made elsewhere.

For example, create a new container named `dbstore2`:

    docker run -v /dbdata --name dbstore2 centos /bin/bash

Then un-tar the backup file in the new container`s data volume:

    docker run --rm --volumes-from dbstore2 -v $(pwd):/backup centos bash -c "cd /dbdata && tar xvf /backup/backup.tar --strip 1"

You can use the techniques above to automate backup, migration and restore testing using your preferred tools.

#### Remove volumes

A Docker data volume persists after a container is deleted. There are two types of volumes to consider:

- **Named volumes** have a specific source from outside the container, for example `awesome:/bar`.

- Anonymous volumes have no specific source so when the container is deleted, instruct the Docker Engine daemon to remove them.

##### Remove anonymous volumes

To automatically remove anonymous volumes, use the `--rm` option. For example, this command creates an **anonymous** `/foo` volume. When the container is removed, the Docker Engine removes the `/foo` volume but not the `awesome` volume.

    docker run --rm -v /foo -v awesome:/bar busybox top

##### Remove all volumes

To remove all unused volumes and free up space:

    docker volume prune

## logging

### [View logs for a container or service](https://docs.docker.com/config/containers/logging/)

The `docker logs` command shows information logged by a running container. The `docker service logs` command shows information logged by all containers participating in a service. The information that is logged and the format of the log depends almost entirely on the container’s endpoint command.

By default, `docker logs` or `docker service logs` shows the command’s output just as it would appear if you ran the command interactively in a terminal.

In some cases, docker logs may not show useful information unless you take additional steps.

- If you use a [logging driver](https://docs.docker.com/config/containers/logging/configure/) which sends logs to a file, an external host, a database, or another logging back-end, `docker logs` may not show useful information.

- If your image runs a non-interactive process such as a web server or a database, that application may send its output to log files instead of `STDOUT` and `STDERR`.

In the first case, your logs are processed in other ways and you may choose not to use `docker logs`. In the second case, the official `nginx` image shows one workaround, and the official Apache `httpd` image shows another.

The official `nginx` image creates a symbolic link from `/var/log/nginx/access.log` to `/dev/stdout`, and creates another symbolic link from `/var/log/nginx/error.log` to `/dev/stderr`, overwriting the log files and causing logs to be sent to the relevant special device instead. See the [Dockerfile](https://github.com/nginxinc/docker-nginx/blob/8921999083def7ba43a06fabd5f80e4406651353/mainline/jessie/Dockerfile#L21-L23).

The official `httpd` driver changes the httpd application’s configuration to write its normal output directly to `/proc/self/fd/1` (which is `STDOUT`) and its errors to `/proc/self/fd/2` (which is `STDERR`). See the [Dockerfile](https://github.com/docker-library/httpd/blob/b13054c7de5c74bbaa6d595dbe38969e6d4f860c/2.2/Dockerfile#L72-L75).

## cmd

### run a centos container

    docker volume create vol_a

    docker run -d --name test --network host -v vol_a:/app -ti centos

#### Run a centos container in Docker Desktop

    docker run -d --name test --network host --mount type=bind,source="/c/test",target=/app -ti centos

#### Publish container port 8080 to the host port 8081

    docker run -d --name test -p 8081:8080 -v vol_a:/app -ti centos

### Override CMD when running a docker image

    docker run -it --entrypoint=/bin/bash $IMAGE -i

### Copy files/folders between a container and the local filesystem

    docker cp CONTAINER:SRC_PATH DEST_PATH

    docker cp SRC_PATH CONTAINER:DEST_PATH

### [Commit a container and change ENTRYPOINT](https://stackoverflow.com/questions/29015023/docker-commit-created-images-and-entrypoint)

    docker commit --change='ENTRYPOINT ["/bin/bash"]' <container-name> <image-name>

### [Move Docker container to another host](https://bobcares.com/blog/move-docker-container-to-another-host/)

### Remove the volumes associated with the container

    docker rm -v <container>

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

### `docker logs`

This command is only functional for containers that are started with the json-file or journald logging driver.

## Troubleshooting

### [Error pulling image : no matching manifest](https://success.docker.com/article/error-pulling-image-no-matching-manifest)

#### Find the OS/Arch of you system

    docker info  -f '{{.OSType}}/{{.Architecture}}'

#### Find the OS/Arch of the image you want to download

    docker manifest inspect -v library/tomcat:latest | jq .[].Platform

## Q & A

### [Can Windows Containers be hosted on linux?](https://stackoverflow.com/questions/42158596/can-windows-containers-be-hosted-on-linux)

## Practice

[ssh登录容器](http://www.fecmall.com/topic/592)

### ssh into a centos container

[dockerfiles-centos-ssh](https://github.com/CentOS/CentOS-Dockerfiles/tree/master/ssh/centos7)

    docker run -ti --name test-ssh -p 50022 centos:7.4 bash

    mkdir /root/.ssh

edit `/root/.ssh/authorized_keys`, add `id_rsa.pub` of client

    yum -y install openssh-server
    passwd root
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

edit `/etc/ssh/sshd_config`

    PermitRootLogin yes
    PubkeyAuthentication yes
    RSAAuthentication yes

start `sshd`

    mkdir /var/run/sshd
    /usr/sbin/sshd -E /var/run/sshd/sshd.log -p 50022

#### `/usr/sbin/sshd`

- `-D`
  
  When this option is specified, sshd will not detach and does not become a daemon. This allows easy monitoring of sshd.

- `-d`

  Debug mode. The server sends verbose debug output to standard error, and does not put itself in the background. The server also will not fork and will only process one connection. This option is only intended for debugging for the server. Multiple -d options increase the debugging level. Maximum is 3.

[SSH still asks for password after setting up key based authentication](https://superuser.com/questions/352368/ssh-still-asks-for-password-after-setting-up-key-based-authentication/1072999#1072999)

> If I ran sshd on different port 'sshd -p 5555 -d'. The key worked. Passwordless login ok. WTF?
>
> Then I disabled selinux (set SELINUX=disabled in /etc/selinux/config) and reboot. Passwordless login then worked ok.
