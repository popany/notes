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

6. 查看镜像内容

   - 保存镜像到 tar 包

         docker save --output x.tar x:1

   - 提取 tar 包

         mkdir tar
         mkdir image
         tar xvf x.tar -C image

   - 查看 image 目录中的文件

         ls image/
         1e33021cb9e4fc8e989445d68584dd2386b15e902fc4e95fba64a5a917759466
         55b7668c516d9a68304c1513c15c1fb8d516372602ec47b0cc64c2b09f2ce772
         5ba03211a158d16543acd8ccaf810e05855f65e8650ab8e786d006df485b95ee
         c91f2aa8f7e37f975b6a78198e6abaf61074942f927335452daa9f6ab6bf29a6.json
         manifest.json
         repositories

     注意其中的文件 c91f2aa8f7e3....json, 这个文件名对应镜像的 id. 其中存储了元数据信息:

         cat image/c91f2aa8f7e37f975b6a78198e6abaf61074942f927335452daa9f6ab6bf29a6.json |python3 -m j
         son.tool
         {
             "architecture": "amd64",
             "config": {
                 "Env": [
                     "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
                 ],
                 "Cmd": [
                     "/bin/sh"
                 ],
                 "OnBuild": null
             },
             "created": "2021-12-11T14:30:59.811702Z",
             "history": [
                 {
                     "created": "2021-11-24T20:19:40.199700946Z",
                     "created_by": "/bin/sh -c #(nop) ADD file:9233f6f2237d79659a9521f7e390df217cec49f1a8aa3a12147bbca1956acdb9 in / "
                 },
                 {
                     "created": "2021-11-24T20:19:40.483367546Z",
                     "created_by": "/bin/sh -c #(nop)  CMD [\"/bin/sh\"]",
                     "empty_layer": true
                 },
                 {
                     "created": "2021-12-11T14:30:59.1800612Z",
                     "created_by": "ADD ./foo . # buildkit",
                     "comment": "buildkit.dockerfile.v0"
                 },
                 {
                     "created": "2021-12-11T14:30:59.811702Z",
                     "created_by": "RUN /bin/sh -c rm -f ./foo # buildkit",
                     "comment": "buildkit.dockerfile.v0"
                 }
             ],
             "os": "linux",
             "rootfs": {
                 "type": "layers",
                 "diff_ids": [
                     "sha256:8d3ac3489996423f53d6087c81180006263b79f206d3fdec9e66f0e27ceb8759",
                     "sha256:9b6f2b68c1c3557308100aa4600c144a1dc1e7dd4914eed52810e1810aa68743",
                     "sha256:7a0267920815fd262a5c85e1833622a381720a0b181be119e07da1c6d57aea87"
                 ]
             }
         }

     文件 manifest.json 指向上面的元数据文件, 并包括每一层的镜像信息.

         cat image/manifest.json |python3 -m json.tool
         [
             {
                 "Config": "c91f2aa8f7e37f975b6a78198e6abaf61074942f927335452daa9f6ab6bf29a6.json",
                 "RepoTags": [
                     "x:1"
                 ],
                 "Layers": [
                     "1e33021cb9e4fc8e989445d68584dd2386b15e902fc4e95fba64a5a917759466/layer.tar",
                     "55b7668c516d9a68304c1513c15c1fb8d516372602ec47b0cc64c2b09f2ce772/layer.tar",
                     "5ba03211a158d16543acd8ccaf810e05855f65e8650ab8e786d006df485b95ee/layer.tar"
                 ]
             }
         ]

     可以看每一层镜像的 id. 其中最后一层不包括文件系统的修改, 所以其对应的是一个 json 文件, c91f2aa8f7e37f975b6a78198e6abaf61074942f927335452daa9f6ab6bf29a6.json. 中间层共三个, 对应三个目录, 且目录下有 tar 包.

     查看层 55b7668c516d9a68304c1513c15c1fb8d516372602ec47b0cc64c2b09f2ce772, 可见该层的 tar 包中包含 foo 文件, 正好对应产生该层的命令 `ADD ./foo .`

         $ tar tvf image/55b7668c516d9a68304c1513c15c1fb8d516372602ec47b0cc64c2b09f2ce772/layer.tar
         -rw-r--r-- 0/0       104857600 2021-12-11 22:27 foo

     查看下一层

         $ tar tvf image/5ba03211a158d16543acd8ccaf810e05855f65e8650ab8e786d006df485b95ee/layer.tar
         drwxr-xr-x 0/0               0 2021-12-11 22:30 etc/
         -rw------- 0/0               0 2021-12-11 22:30 .wh.foo

     该层对应的是 `RUN rm -f ./foo`, 文件 `.wh.foo` 是空的, 可以想到这是 docker 标记 `foo` 文件被删除的方式. 进而印证了每层镜像存储了其相对于上一层的变化.
