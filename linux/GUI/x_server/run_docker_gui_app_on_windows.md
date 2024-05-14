# Run Docker Gui App on Windows

- [Run Gui App In Docker Container](#run-gui-app-in-docker-container)
  - [How to use GUI apps in linux docker container from Windows Host](#how-to-use-gui-apps-in-linux-docker-container-from-windows-host)
    - [1. Set up X server on windows](#1-set-up-x-server-on-windows)
    - [2. Execute a linux container](#2-execute-a-linux-container)
    - [3. Link container's DISPLAY to use windows host](#3-link-containers-display-to-use-windows-host)
    - [4. Test out some x apps!](#4-test-out-some-x-apps)
  - [Run GUI Applications in a Docker Container](#run-gui-applications-in-a-docker-container)
  - [Running Linux Desktop Apps From a Docker Container on Windows with MobaXterm](#running-linux-desktop-apps-from-a-docker-container-on-windows-with-mobaxterm)
  - [Running a graphical app in a Docker container, on a remote server](#running-a-graphical-app-in-a-docker-container-on-a-remote-server)

## [How to use GUI apps in linux docker container from Windows Host](https://medium.com/@potatowagon/how-to-use-gui-apps-in-linux-docker-container-from-windows-host-485d3e1c64a3)

### 1. Set up X server on windows

Install x server. I like the x server from VcXsrv but there are others you can try like X Ming.

    choco install vcxsrv

Launch the x server. Run XLaunch from start menu, or if not found, try looking for xlaunch.exe at the default install location "C:\Program Files\VcXsrv\xlaunch.exe"

Go with all the default settings, however do note to check **"Disable access control"**

### 2. Execute a linux container

    docker run -ti ubuntu /bin/bash

To start a container from the ubuntu image and run an interactive shell

### 3. Link container's DISPLAY to use windows host

Get the IP of your windows host

    ipconfig

If you're like me using windows docker toolbox, the host IP address is likely 192.168.99.1

Lets set the `DISPLAY` env variable in the container.

    export DISPLAY=192.168.99.1:0.0

The format of the display variable is `[host]:<display>[.screen]`. When X11 forwarding over SSH, the TCP port number to open is `6000 + <display>`. For more info see [this unix stack exchange page](https://unix.stackexchange.com/questions/16815/what-does-display-0-0-actually-mean).

### 4. Test out some x apps!

    apt-get install x11-apps

To install a bunch of tiny gui apps like xeyes and xclock

    xeyes

## [Run GUI Applications in a Docker Container](https://gursimarsm.medium.com/run-gui-applications-in-a-docker-container-ca625bad4638)

## [Running Linux Desktop Apps From a Docker Container on Windows with MobaXterm](https://www.rootisgod.com/2021/Running-Linux-Desktop-Apps-From-a-Docker-Container-on-Windows-with-MobaXterm/)

## [Running a graphical app in a Docker container, on a remote server](https://blog.yadutaf.fr/2017/09/10/running-a-graphical-app-in-a-docker-container-on-a-remote-server/)
