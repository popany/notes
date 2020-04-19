# grpc

- [grpc](#grpc)
  - [C++ Quick Start](#c-quick-start)
    - [Setup](#setup)
    - [Prerequisites](#prerequisites)
      - [cmake](#cmake)
      - [gRPC and Protocol Buffers](#grpc-and-protocol-buffers)
  - [Repository](#repository)
    - [gRPC C++ - Building from source](#grpc-c---building-from-source)

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
















