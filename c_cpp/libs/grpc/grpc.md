# grpc

- [grpc](#grpc)
  - [C++ Quick Start](#c-quick-start)
    - [Setup](#setup)
    - [Prerequisites](#prerequisites)
      - [cmake](#cmake)
    - [gRPC and Protocol Buffers](#grpc-and-protocol-buffers)
      - [Install the basic tools required to build gRPC](#install-the-basic-tools-required-to-build-grpc)
      - [Clone the `grpc` repo and its submodules](#clone-the-grpc-repo-and-its-submodules)
      - [Build and locally install gRPC and all requisite tools](#build-and-locally-install-grpc-and-all-requisite-tools)
      - [More information:](#more-information)
    - [Build the example](#build-the-example)
    - [Try it](#try-it)
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
  - [Practice](#practice)
    - [Compile gRPC v1.14.0](#compile-grpc-v1140)
      - [CentOS 8](#centos-8)
        - [Try](#try)
          - [Install packages](#install-packages)
          - [Clone repository](#clone-repository)
          - [Compile](#compile)
        - [Feasible solution](#feasible-solution)
      - [Windows10 + vs2019 + gRPC v1.14.0](#windows10--vs2019--grpc-v1140)
        - [Install choco](#install-choco)
        - [Install packages](#install-packages-1)
        - [Compile & Install OpenSSL](#compile--install-openssl)
        - [Build](#build)
        - [Build an example](#build-an-example)
    - [Compile gRPC v1.28.1](#compile-grpc-v1281)
      - [CentOS 8](#centos-8-1)
    - [Compile gRPC v1.38.1](#compile-grpc-v1381)
      - [Windows vs2019 v140](#windows-vs2019-v140)

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

Version 3.13 or later of cmake is required to install gRPC locally.

- Linux

      sudo apt install -y cmake

Under Linux, the version of the system-wide cmake can be too low. You can install a more recent version into your local installation directory as follows:

    wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0-Linux-x86_64.sh

    sh cmake-linux.sh -- --skip-license --prefix=$MY_INSTALL_DIR

    rm cmake-linux.sh

### gRPC and Protocol Buffers

While not mandatory, gRPC applications usually leverage [Protocol Buffers](https://developers.google.com/protocol-buffers) for service definitions and data serialization, and the example code uses [proto3](https://developers.google.com/protocol-buffers/docs/proto3).

The following instructions will locally install gRPC and Protocol Buffers.

#### Install the basic tools required to build gRPC

- Linux

      sudo apt install -y build-essential autoconf libtool pkg-config

#### Clone the `grpc` repo and its submodules

    git clone --recurse-submodules -b v1.28.1 https://github.com/grpc/grpc
    cd grpc

#### Build and locally install gRPC and all requisite tools

    mkdir -p cmake/build
    pushd cmake/build
    cmake -DgRPC_INSTALL=ON \
        -DgRPC_BUILD_TESTS=OFF \
        -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR \
        ../..
    make -j
    make install
    popd

#### More information:

You can find a complete set of instructions for building gRPC C++ in [Building from source](https://github.com/grpc/grpc/blob/master/BUILDING.md).

For general instructions on how to add gRPC as a dependency to your C++ project, see [Start using gRPC C++](https://github.com/grpc/grpc/tree/master/src/cpp#to-start-using-grpc-c).

### Build the example

The example code is part of the grpc repo source, which you cloned as part of the steps of the previous section.

Change to the example’s directory:

    cd examples/cpp/helloworld

Build the example using cmake:

    mkdir -p cmake/build
    pushd cmake/build
    cmake -DCMAKE_PREFIX_PATH=$MY_INSTALL_DIR ../..
    make -j

### Try it

Run the example from the example build directory examples/cpp/helloworld/cmake/build:

Run the server:

    ./greeter_server

From a different terminal, run the client and see the client output:

    ./greeter_client










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

- **module** - build dependencies alongside gRPC.

- **package** - use external copies of dependencies that are already available on your system.

This behavior is controlled by the `gRPC_<depname>_PROVIDER` CMake variables, ie `gRPC_CARES_PROVIDER`.

###### Install after build

Perform the following steps to install gRPC using CMake.

- Set -DgRPC_INSTALL=ON

- Build the install target

The install destination is controlled by the `CMAKE_INSTALL_PREFIX` variable.

**If you are running CMake v3.13 or newer you can build gRPC's dependencies in "module" mode and install them alongside gRPC in a single step**. [Example](https://github.com/grpc/grpc/blob/master/test/distrib/cpp/run_distrib_test_cmake_module_install.sh)

**If you are using an older version of gRPC, you will need to select "package" mode (rather than "module" mode) for the dependencies**. This means you will need to have external copies of these libraries available on your system. This example shows how to install dependencies with cmake before proceeding to installing gRPC itself.

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

## Practice

### Compile gRPC v1.14.0

#### CentOS 8

##### Try

###### Install packages

    yum install -y autoconf libtool pkg-config gcc-c++ cmake make go

---

Note: `go` depends on `openssl` and `openssl-devel`

---

- g++ version

    g++ (GCC) 8.3.1 20190507 (Red Hat 8.3.1-4)

- cmake version

    cmake version 3.11.4

###### Clone repository

    git clone git@github.com:grpc/grpc.git
    git checkout v1.14.0
    git submodule update --init

###### Compile

    export GRPC_INSTALL_DIR=/grpc_install_dir
    mkdir -p $GRPC_INSTALL_DIR

    mkdir -p cmake/build
    pushd cmake/build
    cmake -DgRPC_INSTALL=ON \
        -DgRPC_BUILD_TESTS=OFF \
        -DCMAKE_INSTALL_PREFIX=$GRPC_INSTALL_DIR \
        -DCMAKE_BUILD_TYPE=Release \
        ../..

---

Warning occurred:

<pre>CMake Warning at cmake/zlib.cmake:32 (message):
  gRPC_INSTALL will be forced to FALSE because gRPC_ZLIB_PROVIDER is "module"
Call Stack (most recent call first):
  CMakeLists.txt:116 (include)
</pre>

`gRPC_INSTALL` will be forced to FALSE if it's dependancies are in "module" mode and `cmake` version is less than `3.13`. (In this case gRPC verison is v1.14.0, the `cmake` version will not be considered for v1.14.0 is an "order version of gRPC")

If `gRPC_INSTALL` if `FALSE`, `gRPCTargets.cmake` will not be installed, and then `find_package` will fail with gRPC.

For gRPC v1.14.0, gRPC's dependencies must be handled in "package" mode (i.e. use `-DgRPC_<depname>_PROVIDER`).

>     cmake -DgRPC_INSTALL=ON \
>         -DgRPC_BUILD_TESTS=OFF \
>         -DCMAKE_INSTALL_PREFIX=$GRPC_INSTALL_DIR \
>         -DCMAKE_BUILD_TYPE=Release \
>         -DgRPC_CARES_PROVIDER=package \
>         -DgRPC_PROTOBUF_PROVIDER=package \
>         -DgRPC_SSL_PROVIDER=package \
>         -DgRPC_ZLIB_PROVIDER=package \
>         ../..

We can't use the above command directly, because `cmake` will report an error:

<pre>  Could not find a package configuration file provided by "c-ares" with any
  of the following names:

    c-aresConfig.cmake
    c-ares-config.cmake
</pre>

Let's put the "package" question aside, and continue without `-DgRPC_<depname>_PROVIDER`.

---

    make VERBOSE=1

---

Error occurred:

<pre>
[ 96%] Building CXX object third_party/boringssl/crypto/CMakeFiles/crypto_test.dir/x509/x509_test.cc.o
cd /demo/grpc_build/grpc/cmake/build/third_party/boringssl/crypto && /usr/bin/c++  -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -DPB_FIELD_16BIT -I/demo/grpc_build/grpc/third_party/zlib -I/demo/grpc_build/grpc/third_party/boringssl/third_party/googletest/include -I/demo/grpc_build/grpc/third_party/boringssl/crypto/../include  -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wno-free-nonheap-object -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -fno-exceptions -fno-rtti -Wshadow -O2 -DNDEBUG -fPIE   -o CMakeFiles/crypto_test.dir/x509/x509_test.cc.o -c /demo/grpc_build/grpc/third_party/boringssl/crypto/x509/x509_test.cc
/demo/grpc_build/grpc/third_party/boringssl/crypto/x509/x509_test.cc: In member function ‘virtual void X509Test_ZeroLengthsWithX509PARAM_Test::TestBody()’:
/demo/grpc_build/grpc/third_party/boringssl/crypto/x509/x509_test.cc:712:10: error: declaration of ‘struct X509Test_ZeroLengthsWithX509PARAM_Test::TestBody()::Test’ shadows a previous local [-Werror=shadow]
   struct Test {
          ^~~~
In file included from /demo/grpc_build/grpc/third_party/boringssl/crypto/x509/x509_test.cc:19:
/demo/grpc_build/grpc/third_party/boringssl/third_party/googletest/include/gtest/gtest.h:375:23: note: shadowed declaration is here
 class GTEST_API_ Test {
                       ^
cc1plus: all warnings being treated as errors
make[2]: *** [third_party/boringssl/crypto/CMakeFiles/crypto_test.dir/build.make:635: third_party/boringssl/crypto/CMakeFiles/crypto_test.dir/x509/x509_test.cc.o] Error 1
make[2]: Leaving directory '/demo/grpc_build/grpc/cmake/build'
make[1]: *** [CMakeFiles/Makefile2:2336: third_party/boringssl/crypto/CMakeFiles/crypto_test.dir/all] Error 2
make[1]: Leaving directory '/demo/grpc_build/grpc/cmake/build'
make: *** [Makefile:130: all] Error 2
</pre>

Because of `-Wshadow` flag is set in `grpc/third_party/boringssl/CMakeLists.txt`:

>     if((CMAKE_COMPILER_IS_GNUCXX AND CMAKE_C_COMPILER_VERSION VERSION_GREATER "4.7.99") OR
>        CLANG)
>       set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wshadow")
>       set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wshadow")
>     endif()

solution:

recompile this file without `-Wshadow`

---

    cd /demo/grpc_build/grpc/cmake/build/third_party/boringssl/crypto && /usr/bin/c++  -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -DPB_FIELD_16BIT -I/demo/grpc_build/grpc/third_party/zlib -I/demo/grpc_build/grpc/third_party/boringssl/third_party/googletest/include -I/demo/grpc_build/grpc/third_party/boringssl/crypto/../include  -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wno-free-nonheap-object -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -fno-exceptions -fno-rtti -O2 -DNDEBUG -fPIE   -o CMakeFiles/crypto_test.dir/x509/x509_test.cc.o -c /demo/grpc_build/grpc/third_party/boringssl/crypto/x509/x509_test.cc
    cd -

    make VERBOSE=1

    make install
    popd

##### Feasible solution

    yum install -y autoconf libtool pkg-config gcc-c++ cmake make go

    git clone git@github.com:grpc/grpc.git
    git checkout v1.14.0
    git submodule update --init

    export GRPC_INSTALL_DIR=/grpc_install_dir
    mkdir -p $GRPC_INSTALL_DIR

    mkdir -p cmake/build
    pushd cmake/build
    cmake -DgRPC_INSTALL=ON \
        -DgRPC_BUILD_TESTS=OFF \
        -DCMAKE_INSTALL_PREFIX=$GRPC_INSTALL_DIR \
        -DCMAKE_BUILD_TYPE=Release \
        ../..

    pushd third_party/cares/cares/
    make -j4
    make install
    popd

    pushd third_party/protobuf/
    make -j4
    make install
    popd

    cmake -DgRPC_INSTALL=ON \
        -DgRPC_BUILD_TESTS=OFF \
        -DCMAKE_INSTALL_PREFIX=$GRPC_INSTALL_DIR \
        -DCMAKE_BUILD_TYPE=Release \
        -DgRPC_CARES_PROVIDER=package \
        -DgRPC_PROTOBUF_PROVIDER=package \
        -DgRPC_SSL_PROVIDER=package \
        -DgRPC_ZLIB_PROVIDER=package \
        ../..

    make -j4
    make install
    popd

Build the example using cmake:

    cd examples/cpp/helloworld
    mkdir -p cmake/build
    pushd cmake/build
    cmake -DCMAKE_PREFIX_PATH=$GRPC_INSTALL_DIR ../..
    make -j
    popd

#### Windows10 + vs2019 + [gRPC v1.14.0](https://github.com/grpc/grpc/blob/v1.14.0/BUILDING.md)

##### Install choco

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

##### Install packages

    choco install activeperl
    choco install golang
    choco install yasm

##### Compile & Install OpenSSL

##### Build

    pushd
    Launch-VsDevShell.ps1
    popd

    $ENV:GRPC_INSTALL_DIR="C:\grpc_install_dir"
    md -p $ENV:GRPC_INSTALL_DIR

    md .build
    pushd .build

    cmake -G "Visual Studio 14 2015" -DgRPC_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=C:\grpc_install_dir ..

    pushd .\third_party\zlib\
    cmake  --build . --config Release
    cmake --install .
    popd

    pushd .\third_party\cares\cares\
    cmake  --build . --config Release
    cmake --install .
    popd

    pushd .\third_party\protobuf
    cmake  --build . --config Release
    cmake --install .
    popd

    $ENV:OPENSSL_LIBRARIES="C:\openssl_install_dir_x86\lib"
    $ENV:OPENSSL_INCLUDE_DIR="C:\openssl_install_dir_x86\include"
    $ENV:PATH=$ENV:PATH + ";" + "C:\openssl_install_dir_x86\bin"

    cmake -G "Visual Studio 14 2015" -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=C:\grpc_install_dir -DgRPC_CARES_PROVIDER=package -DgRPC_PROTOBUF_PROVIDER=package -DgRPC_SSL_PROVIDER=package -DgRPC_ZLIB_PROVIDER=package -DProtobuf_USE_STATIC_LIBS=ON -DCMAKE_PREFIX_PATH=C:\grpc_install_dir ..

    cmake --build . --config Release
    cmake --install .

    popd

##### Build an example

    cd examples/cpp/helloworld

    mkdir -p cmake/build
    pushd cmake/build

    cmake -G "Visual Studio 14 2015" -DCMAKE_PREFIX_PATH=C:\grpc_install_dir ../..

    cmake --build . --config Release

### Compile gRPC v1.28.1

#### CentOS 8

    yum install -y openssl-devel
    yum install -y wget

    wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.16.1/cmake-3.16.1-Linux-x86_64.sh

    sh cmake-linux.sh -- --skip-license --prefix=/usr
    rm -f cmake-linux.sh

    yum install -y autoconf libtool pkg-config gcc-c++ make go

    git clone git@github.com:grpc/grpc.git
    git checkout v1.28.1
    git submodule update --init

    mkdir -p "cmake/build"
    pushd "cmake/build"

    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DgRPC_INSTALL=ON \
      -DgRPC_BUILD_TESTS=OFF \
      -DgRPC_SSL_PROVIDER=package \
      ../..

    make -j4 install
    popd

### Compile gRPC v1.38.1

#### Windows vs2019 v140

powershell

    git clone -b RELEASE_TAG_HERE https://github.com/grpc/grpc
    cd grpc
    git submodule update --init

    md .build
    cd .build

    pushd
    Launch-VsDevShell.ps1
    popd

    cmake .. -G "Visual Studio 16 2019" -A x64 -T v140 -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=C:/local/grpc

    cmake --build . --config Release -j
    cmake --install .
