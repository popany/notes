# git submodule

- [git submodule](#git-submodule)
  - [命令说明](#命令说明)
    - [`git init --bare ./foo/bar.git`](#git-init---bare-foobargit)
  - [references](#references)

## 命令说明

### `git init --bare ./foo/bar.git`

- 在 `./foo/bar.git` 目录下建立一个裸仓库

- `bar.git` 目录的结构与使用 `git init` 命令时生成的 `.git` 的目录结构相同

- 裸仓库, 即, 没有工作区的仓库, 其只会记录 git 提交的历史信息. 可以使用 `git log` 命令, 但不能进行版本回退或者分支切换等操作.










## references

- [Git Submodule管理项目子模块](https://www.cnblogs.com/nicksheng/p/6201711.html)

- [git init 与git init --bare](https://blog.csdn.net/sinat_34349564/article/details/52487860)
