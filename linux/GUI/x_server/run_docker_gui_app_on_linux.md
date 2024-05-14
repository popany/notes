# Run Docker Gui App on Windows

- [Run Docker Gui App on Windows](#run-docker-gui-app-on-windows)

1. 允许本地用户访问 X Server

       xhost +local:

2. 运行容器并挂载 X11 相关文件

   当运行 Docker 容器时，你需要共享 /tmp/.X11-unix 文件夹，这样容器就能够与宿主机的 X11 通信。同时，你还需要将宿主机的 $DISPLAY 环境变量传递给容器：

       docker run -it \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           container_image

3. 在容器中运行 GUI 程序

       docker run -it \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           ubuntu:latest bash -c "apt-get update && apt-get install -y x11-apps && xeyes"
       
       