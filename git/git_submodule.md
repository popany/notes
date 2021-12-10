# git submodule

- [git submodule](#git-submodule)
  - [命令说明](#命令说明)
    - [`git init --bare /demo/foo.git`](#git-init---bare-demofoogit)
    - [`git clone /demo/foo.git`](#git-clone-demofoogit)
  - [submodule 的使用案例](#submodule-的使用案例)
  - [references](#references)

## 命令说明

### `git init --bare /demo/foo.git`

- 在 `/demo/foo.git` 目录下建立一个裸仓库

- `foo.git` 目录的结构与使用 `git init` 命令时生成的 `.git` 的目录结构相同

- 裸仓库, 即, 没有工作区的仓库, 其只会记录 git 提交的历史信息. 可以使用 `git log` 命令, 但不能进行版本回退或者分支切换等操作.

### `git clone /demo/foo.git`

- 克隆一个裸仓库

- 克隆产生的仓库名为 `foo`

- 仓库 `foo` 的远程 `fetch`/`push` 分支均为 `/demo/foo.git`

  即:

      $ cd /demo/foo
      $ git remote -v
      origin  /demo/foo.git (fetch)
      origin  /demo/foo.git (push)

## submodule 的使用案例

1. 首先分别创建两个远程仓库 `foo.git`/`bar.git` 并克隆. 对克隆产生的仓库进行一些修改, 之后推送到远程分支

       cd /demo
       git init --bare foo.git
       git clone foo.git
       cd foo
       echo "This is project foo." > readme.txt
       git add .
       git commit -m "add readme.txt"
       git push origin HEAD

       cd /demo
       git init --bare bar.git
       git clone bar.git
       cd bar
       echo "This is project bar." > readme.txt
       git add .
       git commit -m "add readme.txt"
       git push origin HEAD














## references

- [Git Submodule管理项目子模块](https://www.cnblogs.com/nicksheng/p/6201711.html)

- [git init 与git init --bare](https://blog.csdn.net/sinat_34349564/article/details/52487860)
