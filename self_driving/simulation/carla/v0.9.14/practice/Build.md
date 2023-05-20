# Build

- [Build](#build)
  - [Reference](#reference)
  - [Build in Docker by Mount Carla and UE4 from Host](#build-in-docker-by-mount-carla-and-ue4-from-host)
    - [Mod Util/Docker/Prerequisites.Dockerfile](#mod-utildockerprerequisitesdockerfile)
  - [Build Prerequisites Image](#build-prerequisites-image)
  - [Build UE4](#build-ue4)
  - [Build Carla](#build-carla)
  - [Carla Package Path](#carla-package-path)
  - [Make Process](#make-process)
    - [`make CarlaUE4Editor`](#make-carlaue4editor)

## Reference

[Build Unreal Engine and CARLA in Docker](https://carla.readthedocs.io/en/0.9.14/build_docker_unreal/)

[Linux build](https://carla.readthedocs.io/en/0.9.14/build_linux/)

https://www.cnblogs.com/kin-zhang/p/15829385.html

https://mirrors.sustech.edu.cn/help/carla.html

## Build in Docker by Mount Carla and UE4 from Host

Clone carla and UE4.26 (you need to have a GitHub account linked to Unreal Engine's account), git account: test05180

    git clone -b 0.9.14 --depth 1 https://github.com/carla-simulator/carla.git

    git clone --depth 1 -b carla https://github.com/CarlaUnreal/UnrealEngine.git UE4.26

### Mod Util/Docker/Prerequisites.Dockerfile

    FROM ubuntu:18.04
    
    USER root
    
    ARG EPIC_USER=user
    ARG EPIC_PASS=pass
    ENV DEBIAN_FRONTEND=noninteractive
    RUN apt-get update ; \
      apt-get install -y wget software-properties-common && \
      add-apt-repository ppa:ubuntu-toolchain-r/test && \
      wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|apt-key add - && \
      apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main" && \
      apt-get update ; \
      apt-get install -y build-essential \
        clang-8 \
        lld-8 \
        g++-7 \
        cmake \
        ninja-build \
        libvulkan1 \
        python \
        python-pip \
        python-dev \
        python3-dev \
        python3-pip \
        libpng-dev \
        libtiff5-dev \
        libjpeg-dev \
        tzdata \
        sed \
        curl \
        unzip \
        autoconf \
        libtool \
        rsync \
        libxml2-dev \
        git \
        aria2 && \
      pip3 install -Iv setuptools==47.3.1 && \
      pip3 install distro && \
      update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-8/bin/clang++ 180 && \
      update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-8/bin/clang 180
    
    RUN useradd -m carla
    # COPY --chown=carla:carla . /home/carla
    USER carla
    WORKDIR /home/carla
    ENV UE4_ROOT /home/carla/UE4.26
    
    # RUN git clone --depth 1 -b carla "https://${EPIC_USER}:${EPIC_PASS}@github.com/CarlaUnreal/UnrealEngine.git" ${UE4_ROOT}
    
    # RUN cd $UE4_ROOT && \
    #   ./Setup.sh && \
    #   ./GenerateProjectFiles.sh && \
    #   make
    
    WORKDIR /home/carla/

## Build Prerequisites Image 

    docker build -t carla-prerequisites -f  carla/Util/Docker/Prerequisites.Dockerfile .

## Build UE4

    docker run -uroot --rm -ti \
        -v $(pwd)/UE4.26:/home/carla/UE4.26 \
        carla-prerequisites:latest \
        bash -c "cd /home/carla/UE4.26 && \
            ./Setup.sh && \
            ./GenerateProjectFiles.sh && \
            make"

"Failed to download" error:

https://forums.unrealengine.com/t/upcoming-disruption-of-service-impacting-unreal-engine-users-on-github/1155880

## Build Carla

    chmod 777 -R carla
    docker run --rm -uroot -ti \
        --privileged \
        -v $(pwd)/UE4.26:/home/carla/UE4.26 \
        -v $(pwd)/carla:/home/carla/carla \
        carla-prerequisites:latest \
        bash -c "chown -R carla:carla /home/carla"

    docker run --rm -ti \
        --privileged \
        -v $(pwd)/UE4.26:/home/carla/UE4.26 \
        -v $(pwd)/carla:/home/carla/carla \
        carla-prerequisites:latest \
        bash -c "cd /home/carla/carla && \
            ./Update.sh && \
            make CarlaUE4Editor && \
            make PythonAPI && \
            make build.utils && \
            make package && \
            rm -r /home/carla/carla/Dist"

- Failed to make build.utils

  In Util/BuildTools/BuildUtilsDocker.sh

      /home/carla/carla/Util/DockerUtils/fbx202001_fbxsdk_linux /home/carla/carla/Util/DockerUtils/fbx/dependencies

  Failed for /home/carla/carla/Util/DockerUtils/fbx/dependencies is mounted from host.

## Carla Package Path

Dist/CARLA_0.9.14-dirty.tar.gz

## Make Process

### `make CarlaUE4Editor`

    ./Util/BuildTools/Setup.sh
    ./Util/BuildTools/BuildLibCarla.sh --server --release
    ./Util/BuildTools/BuildCarlaUE4.sh --build


