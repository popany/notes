# [Docker run reference](https://docs.docker.com/engine/reference/run/)

- [Docker run reference](#docker-run-reference)
  - [Overriding Dockerfile image defaults](#overriding-dockerfile-image-defaults)
    - [EXPOSE (incoming ports)](#expose-incoming-ports)

...

## [Overriding Dockerfile image defaults](https://docs.docker.com/engine/reference/run/#overriding-dockerfile-image-defaults)

...

### [EXPOSE (incoming ports)](https://docs.docker.com/engine/reference/run/#expose-incoming-ports)

The following `run` command options work with container networking:

    --expose=[]: Expose a port or a range of ports inside the container.
                 These are additional to those exposed by the `EXPOSE` instruction
    -P         : Publish all exposed ports to the host interfaces
    -p=[]      : Publish a container's port or a range of ports to the host
                   format: ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort | containerPort
                   Both hostPort and containerPort can be specified as a
                   range of ports. When specifying ranges for both, the
                   number of container ports in the range must match the
                   number of host ports in the range, for example:
                       -p 1234-1236:1234-1236/tcp
    
                   When specifying a range for hostPort only, the
                   containerPort must not be a range.  In this case the
                   container port is published somewhere within the
                   specified hostPort range. (e.g., `-p 1234-1236:1234/tcp`)
    
                   (use 'docker port' to see the actual mapping)
    
    --link=""  : Add link to another container (<name or id>:alias or <name or id>)

With the exception of the `EXPOSE` directive, an image developer hasn’t got much control over networking. The `EXPOSE` instruction defines the initial incoming ports that provide services. These ports are available to processes inside the container. An operator can use the `--expose` option to add to the exposed ports.

To expose a container’s internal port, an operator can start the container with the `-P` or `-p` flag. The exposed port is accessible on the host and the ports are available to any client that can reach the host.

The `-P` option publishes all the ports to the host interfaces. **Docker binds each exposed port to a random port on the host**. The range of ports are within an **ephemeral port range** defined by `/proc/sys/net/ipv4/ip_local_port_range`. Use the `-p` flag to explicitly map a single port or range of ports.

The port number inside the container (where the service listens) **does not need to match the port number** exposed on the outside of the container (where clients connect). For example, inside the container an HTTP service is listening on port 80 (and so the image developer specifies `EXPOSE 80` in the Dockerfile). At runtime, the port might be bound to 42800 on the host. To find the mapping between the host ports and the exposed ports, use `docker port`.

If the operator uses `--link` when starting a new client container in the default bridge network, then the client container can access the exposed port via a **private networking interface**. If `--link` is used when starting a container in a user-defined network as described in [Networking overview](https://docs.docker.com/network/), it will provide a named alias for the container being linked to.
