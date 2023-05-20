# Run

- [Run](#run)
  - [Unpack Package](#unpack-package)
  - [Change Owner](#change-owner)
  - [Start Container](#start-container)

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
        -v $(pwd):/home/carla/carla-package \
        -e DISPLAY=192.168.99.1:0.0 \
        carla-prerequisites:latest \
        bash 




