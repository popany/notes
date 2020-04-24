# grpc

- [grpc](#grpc)
  - [C++ Quick Start](#c-quick-start)
    - [Setup](#setup)
    - [Prerequisites](#prerequisites)
      - [cmake](#cmake)
      - [gRPC and Protocol Buffers](#grpc-and-protocol-buffers)
  - [Repository](#repository)
    - [gRPC C++ - Building from source](#grpc-c---building-from-source)
      - [Pre-requisites](#pre-requisites)
        - [Linux](#linux)
        - [Windows](#windows)
      - [Clone the repository (including submodules)](#clone-the-repository-including-submodules)
      - [Build from source](#build-from-source)
        - [Building with bazel (recommended)](#building-with-bazel-recommended)
        - [Building with CMake](#building-with-cmake)
          - [Linux/Unix, Using Make](#linuxunix-using-make)
          - [Windows, Using Visual Studio 2015 or 2017](#windows-using-visual-studio-2015-or-2017)
          - [Windows, Using Ninja (faster build)](#windows-using-ninja-faster-build)
          - [Dependency management](#dependency-management)
          - [Install after build](#install-after-build)
  - [gRPC 官方文档中文版](#grpc-%e5%ae%98%e6%96%b9%e6%96%87%e6%a1%a3%e4%b8%ad%e6%96%87%e7%89%88)

## [C++ Quick Start](https://grpc.io/docs/quickstart/cpp/)

This guide gets you started with gRPC in C++ with a simple working example.

In the C++ world, there's no universally accepted standard for **managing project dependencies**. In this quick start, you'll follow steps to **build** and locally **install** gRPC before building and running this quick start's Hello World example.

### Setup

Choose a **directory to hold locally installed packages**. This page assumes that the environment variable `MY_INSTALL_DIR` holds this directory path. For example:

    export MY_INSTALL_DIR=$HOME/local

Ensure that the directory exists:

    mkdir -p $MY_INSTALL_DIR

Add the local bin folder to your path variable, for example:

    export PATH="$PATH:$MY_INSTALL_DIR/bin"

### Prerequisites

#### cmake

Version 3.13 or later of `cmake` is required to install gRPC locally.

#### gRPC and Protocol Buffers

While not mandatory, gRPC applications usually leverage [Protocol Buffers](https://developers.google.com/protocol-buffers) for service definitions and data serialization, and the example code uses [proto3](https://developers.google.com/protocol-buffers/docs/proto3).

The following instructions will locally install gRPC and Protocol Buffers.

1. Install the basic tools required to build gRPC:
Linux

    apt install -y build-essential autoconf libtool pkg-config














## [Repository](https://github.com/grpc/grpc)

    git clone --recurse-submodules git@github.com:grpc/grpc.git

### [gRPC C++ - Building from source](https://github.com/grpc/grpc/blob/master/BUILDING.md)

#### Pre-requisites

##### Linux

    # apt-get install build-essential autoconf libtool pkg-config

##### Windows

To prepare for cmake + Microsoft Visual C++ compiler build

- Install Visual Studio 2015 or 2017 (Visual C++ compiler will be used).
- Install [Git](https://git-scm.com/).
- Install [CMake](https://cmake.org/download/).
- Install [nasm](https://www.nasm.us/) and add it to `PATH (choco install nasm)` - required by boringssl
- (Optional) Install [Ninja](https://ninja-build.org/) (`choco install ninja`)

#### Clone the repository (including submodules)

Before building, you need to clone the gRPC github repository and download submodules containing source code for gRPC's dependencies (that's done by the submodule command or --recursive flag). Use following commands to clone the gRPC repository at the [latest stable release tag](https://github.com/grpc/grpc/releases)

- Unix

      git clone -b RELEASE_TAG_HERE https://github.com/grpc/grpc
      cd grpc
      git submodule update --init

- Windows

      git clone -b RELEASE_TAG_HERE https://github.com/grpc/grpc
      cd grpc
      git submodule update --init

NOTE: The bazel build tool uses a different model for dependencies. You only need to worry about downloading submodules if you're building with something else than bazel (e.g. cmake).

#### Build from source

In the C++ world, there's no "standard" build system that would work for in all supported use cases and on all supported platforms. Therefore, gRPC supports several major build systems, which should satisfy most users. Depending on your needs we recommend building using **bazel** or **cmake**.

##### Building with bazel (recommended)

Bazel is the primary build system for gRPC C++ and if you're comfortable with using bazel, we can certainly recommend it. Using bazel will give you the best developer experience as well as faster and cleaner builds.

You'll need bazel version 1.0.0 or higher to build gRPC. See Installing Bazel for instructions how to install bazel on your system. We support building with bazel on Linux, MacOS and Windows.

From the grpc repository root

Build gRPC C++

    bazel build :all

Run all the C/C++ tests

    bazel test --config=dbg //test/...

##### Building with CMake

###### Linux/Unix, Using Make

Run from grpc directory after cloning the repo with --recursive or updating submodules.

    mkdir -p cmake/build
    cd cmake/build
    cmake ../..
    make

If you want to build shared libraries (.so files), run cmake with -DBUILD_SHARED_LIBS=ON.

###### Windows, Using Visual Studio 2015 or 2017

When using the "Visual Studio" generator, cmake will generate a solution (grpc.sln) that contains a VS project for every target defined in CMakeLists.txt (+ few extra convenience projects added automatically by cmake). After opening the solution with Visual Studio you will be able to browse and build the code.

Run from grpc directory after cloning the repo with --recursive or updating submodules.

    md .build
    cd .build
    cmake .. -G "Visual Studio 14 2015"
    cmake --build . --config Release

If you want to build DLLs, run cmake with -DBUILD_SHARED_LIBS=ON.

###### Windows, Using Ninja (faster build)

Please note that when using Ninja, you will still need Visual C++ (part of Visual Studio) installed to be able to compile the C/C++ sources.

Run from grpc directory after cloning the repo with --recursive or updating submodules.

    cd cmake
    md build
    cd build
    call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x64
    cmake ..\.. -GNinja -DCMAKE_BUILD_TYPE=Release
    cmake --build .

If you want to build DLLs, run cmake with -DBUILD_SHARED_LIBS=ON.

###### Dependency management

gRPC's CMake build system provides two modes for handling dependencies.

- module - build dependencies alongside gRPC.

- package - use external copies of dependencies that are already available on your system.

This behavior is controlled by the `gRPC_<depname>_PROVIDER` CMake variables, ie `gRPC_CARES_PROVIDER`.

###### Install after build

Perform the following steps to install gRPC using CMake.

- Set -DgRPC_INSTALL=ON

- Build the install target

The install destination is controlled by the `CMAKE_INSTALL_PREFIX` variable.

If you are running CMake v3.13 or newer you can build gRPC's dependencies in "module" mode and install them alongside gRPC in a single step. Example

If you are using an older version of gRPC, you will need to select "package" mode (rather than "module" mode) for the dependencies. This means you will need to have external copies of these libraries available on your system. This example shows how to install dependencies with cmake before proceeding to installing gRPC itself.

NOTE: all of gRPC's dependencies need to be already installed

    cmake ../.. -DgRPC_INSTALL=ON                \
                -DCMAKE_BUILD_TYPE=Release       \
                -DgRPC_ABSL_PROVIDER=package     \
                -DgRPC_CARES_PROVIDER=package    \
                -DgRPC_PROTOBUF_PROVIDER=package \
                -DgRPC_SSL_PROVIDER=package      \
                -DgRPC_ZLIB_PROVIDER=package
    make
    make install














## [gRPC 官方文档中文版](http://doc.oschina.net/grpc)














