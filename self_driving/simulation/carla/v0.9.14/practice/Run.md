# Run

- [Run](#run)
  - [Reference](#reference)
  - [Unpack Package](#unpack-package)
  - [Change Owner](#change-owner)
  - [Start Container](#start-container)
  - [Run](#run-1)

## Reference

[Quick start package installation](https://carla.readthedocs.io/en/0.9.14/start_quickstart/)

## Unpack Package

    mkdir carla-package
    cd carla-package
    tar -xzvf ../carla/Dist/CARLA_0.9.14-dirty.tar.gz -C .

## Change Owner

    docker run --rm -ti \
        -uroot \
        --privileged \
        -v $(pwd):/home/carla/carla-package \
        carla-prerequisites:latest \
        bash -c "chown -R carla:carla /home/carla/carla-package" 

## Start Container

    docker run --rm -ti \
        --privileged \
        --gpus all \
        -v $(pwd):/home/carla/carla-package \
        -e DISPLAY=192.168.99.1:0.0 \
        carla-prerequisites:latest \
        bash 

## Run

    ./CarlaUE4.sh


