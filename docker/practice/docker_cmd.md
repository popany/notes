# docker cmd

- [docker cmd](#docker-cmd)
  - [查看各个容器的挂载路径](#查看各个容器的挂载路径)
  - [docker ps 筛选](#docker-ps-筛选)
  - [docker run](#docker-run)
    - [Using current user when running container in docker-compose](#using-current-user-when-running-container-in-docker-compose)

## 查看各个容器的挂载路径

    docker inspect $(docker ps -q) -f '{{ .Id }} {{ range .Mounts }}{{ .Source }}{{ end }}'

## docker ps 筛选

    docker ps -f 'network=xxx'

## docker run

### [Using current user when running container in docker-compose](https://stackoverflow.com/questions/64857370/using-current-user-when-running-container-in-docker-compose)




