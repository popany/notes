# docker cmd

- [docker cmd](#docker-cmd)
  - [查看各个容器的挂载路径](#查看各个容器的挂载路径)
  - [docker ps 筛选](#docker-ps-筛选)

## 查看各个容器的挂载路径

    docker inspect $(docker ps -q) -f '{{ .Id }} {{ range .Mounts }}{{ .Source }}{{ end }}'

## docker ps 筛选

    docker ps -f 'network=xxx'

