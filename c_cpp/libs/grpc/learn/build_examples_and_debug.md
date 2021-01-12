# Build Grpc Examples and Debug

- [Build Grpc Examples and Debug](#build-grpc-examples-and-debug)
  - [Build & Install grpc](#build--install-grpc)

## Build & Install grpc

    # CentOS 8

    yum install -y git 
    yum install -y openssl-devel
    yum install -y wget

    wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.16.1/cmake-3.16.1-Linux-x86_64.sh

    sh cmake-linux.sh -- --skip-license --prefix=/usr
    rm -f cmake-linux.sh

    yum install -y autoconf libtool pkg-config gcc-c++ make go

    git clone git@github.com:grpc/grpc.git
    git checkout v1.34.0
    git submodule update --init

    export GRPC_INSTALL_DIR=/usr1/grpc-debug
    mkdir -p $GRPC_INSTALL_DIR

    mkdir -p "cmake/build"
    pushd "cmake/build"

    cmake \
      -DCMAKE_INSTALL_PREFIX=$GRPC_INSTALL_DIR \
      -DCMAKE_BUILD_TYPE=Debug \
      -DBUILD_SHARED_LIBS=ON \
      -DgRPC_INSTALL=ON \
      -DgRPC_BUILD_TESTS=OFF \
      -DgRPC_SSL_PROVIDER=package \
      ../..

    make -j4 install
    popd
















TODO grpc xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx