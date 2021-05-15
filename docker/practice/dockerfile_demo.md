# Dockerfile Demo

- [Dockerfile Demo](#dockerfile-demo)
  - [Simple demo](#simple-demo)
    - [`Dockerfile`](#dockerfile)
    - [`docker build`](#docker-build)

## Simple demo

### `Dockerfile`

    FROM centos:8

    ENV TZ Asia/Shanghai
    ENV LANG C.UTF-8

    RUN yum install -y nc

    WORKDIR /

    EXPOSE 50000

    CMD ["nc", "-l", "0.0.0.0", "50000"]

### `docker build`

    docker build -t demo:1.0 .
