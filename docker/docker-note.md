# Docker Note

- [Docker Note](#docker-note)
  - [Dockerfile](#dockerfile)
    - [`CMD` vs [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)](#cmd-vs-entrypoint)
      - [Instruction's forms](#instructions-forms)
      - [User specified arguments to `docker run`](#user-specified-arguments-to-docker-run)
      - [Disadvantage of shell form](#disadvantage-of-shell-form)
      - [Command executed for different `ENTRYPOINT` / `CMD` combinations:](#command-executed-for-different-entrypoint--cmd-combinations)

## Dockerfile

[Dockerfile reference](https://docs.docker.com/engine/reference/builder/)

### [`CMD`](https://docs.docker.com/engine/reference/builder/#cmd) vs [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)

#### Instruction's forms

- `CMD` has three forms

  - exec form

        CMD ["executable","param1","param2"]
  
  - as default parameters to `ENTRYPOINT`

        CMD ["param1","param2"]

  - shell form

        CMD command param1 param2

    is equivalent to the JSON array format:

        CMD ["/bin/sh", "-c", "command", "param1", "param2"]

- `ENTRYPOINT` has two forms

  - exec form

        ENTRYPOINT ["executable", "param1", "param2"]

  - shell form

        ENTRYPOINT command param1 param2

#### User specified arguments to `docker run`

- Only `CMD` specified

  The arguments will override the default specified in `CMD`

- Only `ENTRYPOINT` specified

  - 'ENTRYPOINT' is exec form

     The arguments will be append after all elements in `ENTRYPOINT`

  - 'ENTRYPOINT' is bash form

     The arguments will be omitted

- Both `CMD` and `ENTRYPOINT` specified

  - 'ENTRYPOINT' is exec form

     The arguments will be append after all elements in `ENTRYPOINT`

     `CMD` will be omitted

  - 'ENTRYPOINT' is bash form

     The arguments will be omitted

     `CMD` will be omitted

#### Disadvantage of shell form

- The executable will not be the container's `PID 1`

- The executable will not receive Unix signals

#### Command executed for different `ENTRYPOINT` / `CMD` combinations:

||No ENTRYPOINT|`ENTRYPOINT exec_entry p1_entry`|`ENTRYPOINT ["exec_entry", "p1_entry"]`|
|-|-|-|-|
|No CMD|error, not allowed|`/bin/sh -c exec_entry p1_entry`|`exec_entry p1_entry`|
|`CMD ["exec_cmd", "p1_cmd"]`|`exec_cmd p1_cmd`|`/bin/sh -c exec_entry p1_entry`|`exec_entry p1_entry exec_cmd p1_cmd`|
|`CMD ["p1_cmd", "p2_cmd"]`|`p1_cmd p2_cmd`|`/bin/sh -c exec_entry p1_entry`|`exec_entry p1_entry p1_cmd p2_cmd`|
|`CMD exec_cmd p1_cmd`|`/bin/sh -c exec_cmd p1_cmd`|`/bin/sh -c exec_entry p1_entry`|`exec_entry p1_entry /bin/sh -c exec_cmd p1_cmd`|
|||||
