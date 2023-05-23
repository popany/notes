# Build

- [Build](#build)
  - [Reference](#reference)
  - [Build in Docker by Mount Carla and UE4 from Host](#build-in-docker-by-mount-carla-and-ue4-from-host)
    - [Build carla-dev image](#build-carla-dev-image)
    - [Build UE4](#build-ue4)
    - [Build Carla](#build-carla)
    - [Carla Package Path](#carla-package-path)
  - [Make Process](#make-process)
    - [`make CarlaUE4Editor`](#make-carlaue4editor)
      - [./Util/BuildTools/Setup.sh](#utilbuildtoolssetupsh)
      - [./Util/BuildTools/BuildLibCarla.sh --server --release](#utilbuildtoolsbuildlibcarlash---server---release)
      - [./Util/BuildTools/BuildCarlaUE4.sh --build](#utilbuildtoolsbuildcarlaue4sh---build)
    - [`make PythonAPI`](#make-pythonapi)
      - [./Util/BuildTools/Setup.sh](#utilbuildtoolssetupsh-1)
      - [./Util/BuildTools/BuildLibCarla.sh --client --release](#utilbuildtoolsbuildlibcarlash---client---release)
      - [./Util/BuildTools/BuildOSM2ODR.sh](#utilbuildtoolsbuildosm2odrsh)
      - [./Util/BuildTools/BuildPythonAPI.sh](#utilbuildtoolsbuildpythonapish)
    - [`make build.utils`](#make-buildutils)
    - [`make package`](#make-package)
      - [Util/BuildTools/Package.sh](#utilbuildtoolspackagesh)
  - [Run](#run)
  - [Debug](#debug)
    - [Debug `CarlaUE4-Linux-Shipping`](#debug-carlaue4-linux-shipping)

## Reference

[Build Unreal Engine and CARLA in Docker](https://carla.readthedocs.io/en/0.9.14/build_docker_unreal/)

[Linux build](https://carla.readthedocs.io/en/0.9.14/build_linux/)

https://www.cnblogs.com/kin-zhang/p/15829385.html

https://mirrors.sustech.edu.cn/help/carla.html

## Build in Docker by Mount Carla and UE4 from Host

Clone carla and UE4.26 (you need to have a GitHub account linked to Unreal Engine's account), git account: test05180

    git clone -b 0.9.14 --depth 1 https://github.com/carla-simulator/carla.git

    git clone --depth 1 -b carla https://github.com/CarlaUnreal/UnrealEngine.git UE4.26

### Build carla-dev image

Reference:

- `Util/Docker/Prerequisites.Dockerfile`

- https://carla.readthedocs.io/en/0.9.14/build_linux/

- Need vulkan installed in docker image to run CarlaUE4.sh

  https://gitlab.com/nvidia/container-images/vulkan/-/tree/master?ref_type=heads

Dockerfile

    FROM nvidia/vulkan:1.3-470
    
    USER root
    
    ENV DEBIAN_FRONTEND=noninteractive
    RUN apt-get update ; \
      apt-get install -y wget software-properties-common && \
      add-apt-repository ppa:ubuntu-toolchain-r/test && \
      wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|apt-key add - && \
      apt-add-repository "deb http://apt.llvm.org/focal/ llvm-toolchain-focal main" && \
      apt-get update ; \
      apt-get install -y build-essential \
        clang-10 \
        lld-10 \
        g++-7 \
        cmake \
        ninja-build \
        libvulkan1 \
        python \
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
      update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-10/bin/clang++ 180 && \
      update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-10/bin/clang 180

    RUN apt install -y xorg-dev # Inorder to run in docker container
    RUN apt install -y gdb
    
    RUN useradd -m carla
    USER carla
    WORKDIR /home/carla
    ENV UE4_ROOT /home/carla/UE4.26
    
    WORKDIR /home/carla/

Build image:

    docker build -t carla-dev .

### Build UE4

    docker run -uroot --rm -ti \
        -v $(pwd)/UE4.26:/home/carla/UE4.26 \
        carla-dev:latest \
        bash -c "cd /home/carla/UE4.26 && \
            ./Setup.sh && \
            ./GenerateProjectFiles.sh && \
            make"

- "Failed to download" error:

  Reference: https://forums.unrealengine.com/t/upcoming-disruption-of-service-impacting-unreal-engine-users-on-github/1155880

  Practice: Replace Engine/Build/Commit.gitdeps.xml with https://github.com/EpicGames/UnrealEngine/releases/download/4.26.2-release/Commit.gitdeps.xml

### Build Carla

    docker run --rm -uroot -ti \
        --privileged \
        -v $(pwd)/UE4.26:/home/carla/UE4.26 \
        -v $(pwd)/carla:/home/carla/carla \
        carla-dev:latest \
        bash -c "chown -R carla:carla /home/carla/UE4.26 /home/carla/carla"

    docker run --rm -ti \
        --privileged \
        -v $(pwd)/UE4.26:/home/carla/UE4.26 \
        -v $(pwd)/carla:/home/carla/carla \
        carla-dev:latest \
        bash -c "cd /home/carla/carla && \
            ./Update.sh && \
            make CarlaUE4Editor && \
            make PythonAPI && \
            make package"

- Failed to make build.utils

  In Util/BuildTools/BuildUtilsDocker.sh

      /home/carla/carla/Util/DockerUtils/fbx202001_fbxsdk_linux /home/carla/carla/Util/DockerUtils/fbx/dependencies

  Failed for /home/carla/carla/Util/DockerUtils/fbx/dependencies is mounted from host.

### Carla Package Path

Dist/CARLA_0.9.14.tar.gz

## Make Process

- make variables: Util/BuildTools/Vars.mk

- make process: Util/BuildTools/Linux.mk

### `make CarlaUE4Editor`

rule:

    CarlaUE4Editor: LibCarla.server.release
        @${CARLA_BUILD_TOOLS_FOLDER}/BuildCarlaUE4.sh --build $(ARGS)

steps:

    ./Util/BuildTools/Setup.sh
    ./Util/BuildTools/BuildLibCarla.sh --server --release
    ./Util/BuildTools/BuildCarlaUE4.sh --build

#### ./Util/BuildTools/Setup.sh

1. Download and build dependences and install into `Build` directory

2. Generate `LibCarla/source/carla/Version.h`

3. Generate cmake files

   `Build/LibStdCppToolChain.cmake`

   `Build/LibCppToolChain.cmake`

   `Build/CMakeLists.txt.in`

#### ./Util/BuildTools/BuildLibCarla.sh --server --release

1. Execute cmake in `${M_BUILD_FOLDER}`

   For `Server Release` build, `M_BUILD_FOLDER=Build/libcarla-server-build.release/`

2. Install `libcarla_server.a` to `./Unreal/CarlaUE4/Plugins/Carla/CarlaDependencies/lib/libcarla_server.a`

   `CMAKE_INSTALL_PREFIX` is set to `LIBCARLA_INSTALL_SERVER_FOLDER`

   `LIBCARLA_INSTALL_SERVER_FOLDER=./Unreal/CarlaUE4/Plugins/Carla/CarlaDependencies`

   `libcarla_server.a` is referenced in `Unreal/CarlaUE4/Plugins/Carla/Source/Carla/Carla.Build.cs`

#### ./Util/BuildTools/BuildCarlaUE4.sh --build

Need env variable `UE4_ROOT`

1. `pushd Unreal/CarlaUE4`

2. Edit file `Unreal/CarlaUE4/CarlaUE4.uproject`

   Call `Util/BuildTools/enable_carsim_to_uproject.py`

   Set `CarSim` Plagin 

3. Generate project 

   Call `${UE4_ROOT}/GenerateProjectFiles.sh`

   Output `Unreal/CarlaUE4/Makefile`

4. `make CarlaUE4Editor`

   makefile: `Unreal/CarlaUE4/Makefile`


### `make PythonAPI`

rule:

    PythonAPI: LibCarla.client.release osm2odr
        @${CARLA_BUILD_TOOLS_FOLDER}/BuildPythonAPI.sh $(ARGS)

steps:

    ./Util/BuildTools/Setup.sh
    ./Util/BuildTools/BuildLibCarla.sh --client --release
    ./Util/BuildTools/BuildOSM2ODR.sh
    ./Util/BuildTools/BuildPythonAPI.sh

#### ./Util/BuildTools/Setup.sh

...

#### ./Util/BuildTools/BuildLibCarla.sh --client --release

- cmake execute dir: `Build/libcarla-client-build.release/`

- `-DCMAKE_BUILD_TYPE=Client`

- `-DCMAKE_TOOLCHAIN_FILE=Build/LibStdCppToolChain.cmake`

- `-DCMAKE_INSTALL_PREFIX=PythonAPI/carla/dependencies/`

Output: `Build/libcarla-client-build.release/LibCarla/cmake/client/libcarla_client.a`

Install Path: `PythonAPI/carla/dependencies/lib/libcarla_client.a` 

`libcarla_client.a` is referenced in `PythonAPI/carla/setup.py`


#### ./Util/BuildTools/BuildOSM2ODR.sh

...

#### ./Util/BuildTools/BuildPythonAPI.sh

...

### `make build.utils`

rule:

    build.utils: PythonAPI
        @${CARLA_BUILD_TOOLS_FOLDER}/BuildUtilsDocker.sh

...

### `make package`

rule:

    package: CarlaUE4Editor PythonAPI
        @${CARLA_BUILD_TOOLS_FOLDER}/Package.sh $(ARGS)

steps:

    ...
    Util/BuildTools/Package.sh


#### Util/BuildTools/Package.sh

1. `pushd Unreal/CarlaUE4`

2. Call `Util/BuildTools/enable_carsim_to_uproject.py`

3. Call `${UE4_ROOT}/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun`

...

## Run

Prepare packages 

    mkdir carla-package
    cd carla-package
    tar -xzvf ../carla/Dist/CARLA_0.9.14.tar.gz -C .

Chown of carla-package

    docker run --rm -ti \
        -uroot \
        -v $(pwd):/home/carla/carla-package \
        carla-dev:latest \
        bash -c "chown -R carla:carla /home/carla/carla-package" 

Run in container

    docker run --rm -ti \
        --privileged \
        --gpus all \
        -e NVIDIA_DISABLE_REQUIRE=1 \
        -e NVIDIA_DRIVER_CAPABILITIES=all --device /dev/dri \
        -v /etc/vulkan/icd.d/nvidia_icd.json:/etc/vulkan/icd.d/nvidia_icd.json \
        -v /etc/vulkan/implicit_layer.d/nvidia_layers.json:/etc/vulkan/implicit_layer.d/nvidia_layers.json \
        -v /usr/share/glvnd/egl_vendor.d/10_nvidia.json:/usr/share/glvnd/egl_vendor.d/10_nvidia.json \
        -e XDG_RUNTIME_DIR=/tmp/carla-xdg \
        -v /tmp/carla-xdg:/tmp/carla-xdg \
        -e DISPLAY=172.24.10.124:0.0 \
        -v $(pwd):/home/carla/carla_package \
        carla-dev:latest \
        bash -c "cd /home/carla/carla_package && ./CarlaUE4.sh"

Reference:

[Rendering options](https://carla.readthedocs.io/en/0.9.14/adv_rendering_options/)
	
## Debug

### Debug `CarlaUE4-Linux-Shipping`

Debug in docker

    docker run --rm -ti \
        --privileged \
        --gpus all \
        -e NVIDIA_DISABLE_REQUIRE=1 \
        -e NVIDIA_DRIVER_CAPABILITIES=all --device /dev/dri \
        -v /etc/vulkan/icd.d/nvidia_icd.json:/etc/vulkan/icd.d/nvidia_icd.json \
        -v /etc/vulkan/implicit_layer.d/nvidia_layers.json:/etc/vulkan/implicit_layer.d/nvidia_layers.json \
        -v /usr/share/glvnd/egl_vendor.d/10_nvidia.json:/usr/share/glvnd/egl_vendor.d/10_nvidia.json \
        -e XDG_RUNTIME_DIR=/tmp/carla-xdg \
        -v /tmp/carla-xdg:/tmp/carla-xdg \
        -e DISPLAY=172.24.10.124:0.0 \
        -v $(pwd)/UE4.26:/home/carla/UE4.26 \
        -v $(pwd)/carla:/home/carla/carla \
        carla-dev:latest \
        bash

    cd ~/carla/Unreal/CarlaUE4/Saved/StagedBuilds/LinuxNoEditor/CarlaUE4/Binaries/Linux/
    gdb --args CarlaUE4-Linux-Shipping



