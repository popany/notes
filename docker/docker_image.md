# Docker Image

- [Docker Image](#docker-image)
  - [整理](#整理)
    - [参考](#参考)
  - [案例](#案例)
    - [在 Dockerfile 中通过 `RUN` 命令删除之前 `ADD` 的文件并不能减小最终镜像的大小](#在-dockerfile-中通过-run-命令删除之前-add-的文件并不能减小最终镜像的大小)

## 整理

- 除去 `FROM scratch` 的镜像外, 每一个镜像都有其基础镜像, 镜像本身包括了其相对于其基础镜像的变更.

- 一个标签对应一个镜像

- 一个镜像可以有多个标签

- 镜像等同于层

- Dockerfile 中的每个指令都会导致新建一个层

  每一层镜像保存了相对于上一层的变更, 包括:

  1. 元数据变更

  2. 文件系统变更

- 每一层都可被用来创建容器

- 层也被称为中间镜像, 因为他们往往是匿名的

### 参考

- [What Are Docker Image Layers?](https://vsupalov.com/docker-image-layers/)

- [Digging into Docker layers](https://jessicagreben.medium.com/digging-into-docker-layers-c22f948ed612)

- [What's A Docker Image Anyway?](https://vsupalov.com/whats-a-docker-image/)

- [Digging into Docker layers](https://jessicagreben.medium.com/digging-into-docker-layers-c22f948ed612)

## 案例

### 在 Dockerfile 中通过 `RUN` 命令删除之前 `ADD` 的文件并不能减小最终镜像的大小

参考:

- [Why RUN command which deletes files inflates image size?](https://forums.docker.com/t/why-run-command-which-deletes-files-inflates-image-size/33670)

- [Creating Smaller Docker Images](https://www.ianlewis.org/en/creating-smaller-docker-images)

原因:

因为 `ADD` 新建了一层, 该层中有新增的文件, 通过 `RUN` 命令是无法删除上层镜像中的文件的. 每一层只记录相对上一层的变化. 虽然最终的镜像是不包括 `ADD` 的文件的, 但最终的镜像包括其所依赖的所有层, 所以自然包括 `ADD` 这一层的大小.

例子:

1. Dockerfile:

       FROM alpine
       ADD ./foo .
       RUN rm -f ./foo

2. 在 Dockerfile 同一目录创建文件 `foo`, 大小 100M

       dd if=/dev/zero of=./foo ibs=1M count=100

3. 创建镜像

       docker build -t x:1 .

4. 查看镜像大小, 可知最终镜像大小包括 `foo` 文件的大小 (100M)

       $ docker images
       REPOSITORY               TAG       IMAGE ID       CREATED          SIZE
       x                        1         c91f2aa8f7e3   26 seconds ago   110MB
       ...

5. 查看每层的大小

       $ docker history x:1
       IMAGE          CREATED              CREATED BY                                      SIZE      COMMENT
       c91f2aa8f7e3   About a minute ago   RUN /bin/sh -c rm -f ./foo # buildkit           0B        buildkit.dockerfile.v0
       <missing>      About a minute ago   ADD ./foo . # buildkit                          105MB     buildkit.dockerfile.v0
       <missing>      2 weeks ago          /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B
       <missing>      2 weeks ago          /bin/sh -c #(nop) ADD file:9233f6f2237d79659…   5.59MB

  注:

  使用 `--squash` 选项可以消除中间层, 最终镜像大小不包括 `foo` 文件大小
