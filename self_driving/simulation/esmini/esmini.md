# esmini

- [esmini](#esmini)
  - [HowTo](#howto)
    - [run in docker](#run-in-docker)
    - [build](#build)
    - [run](#run)

[github repo](https://github.com/esmini/esmini)

## HowTo

### run in docker

    FROM ubuntu:18.04

    RUN apt update && \
        apt install -y build-essential gdb ninja-build git pkg-config libgl1-mesa-dev libpthread-stubs0-dev libjpeg-dev libxml2-dev libpng-dev libtiff5-dev libgdal-dev libpoppler-dev libdcmtk-dev libgstreamer1.0-dev libgtk2.0-dev libcairo2-dev libpoppler-glib-dev libxrandr-dev libxinerama-dev curl cmake

    docker build -t esmini-env --file Dockerfile .

    docker run --name esmini --rm -tid --privileged -v $(pwd):/opt/esmini -w /opt/esmini esmini-env:latest bash

### build

    mkdir build
    cd build
    cmake ..
    make -j8 install

### run

    export DISPLAY=<ip>:0.0
    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/cut-in.xosc






