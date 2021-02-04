# Dolphinscheduler Build

- [Dolphinscheduler Build](#dolphinscheduler-build)
  - [参考 `./docker/build/README.md`](#参考-dockerbuildreadmemd)
    - [构建镜像](#构建镜像)
      - [`./docker/build/hooks/build` 内容](#dockerbuildhooksbuild-内容)
      - [`./docker/build/Dockerfile` 内容](#dockerbuilddockerfile-内容)

## 参考 `./docker/build/README.md`

### 构建镜像

使用脚本 `./docker/build/hooks/build`

#### `./docker/build/hooks/build` 内容

- 构建 maven 项目

      mvn -B clean compile package -Prelease -Dmaven.test.skip=true

- 将构建生成的 tar 包拷贝到指定目录

      mv $(pwd)/dolphinscheduler-dist/target/apache-dolphinscheduler-incubating-${VERSION}-dolphinscheduler-bin.tar.gz $(pwd)/docker/build/

- 构建 docker 镜像

      sudo docker build --build-arg VERSION=${VERSION} -t $DOCKER_REPO:${VERSION} $(pwd)/docker/build/

#### `./docker/build/Dockerfile` 内容

- 配置 nginx

    RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
        rm -rf /etc/nginx/conf.d/*
    ADD ./conf/nginx/dolphinscheduler.conf /etc/nginx/conf.d

  - nginx 配置文件 `./conf/nginx/dolphinscheduler.conf`

