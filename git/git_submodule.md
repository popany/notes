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

2. 将仓库 `bar.git` 作为子模块加入仓库 `foo`

       cd /demo/foo
       git submodule add /demo/bar.git third_party/bar

   说明:

   - 此时在 `foo` 目录下使用 `git status` 查看可以发现新增了两个被跟踪的条目, 分别是 `.gitmodules` 与 `third_party/bar`

         $ git status
         On branch master
         Your branch is up to date with 'origin/master'.
         
         Changes to be committed:
           (use "git restore --staged <file>..." to unstage)
                 new file:   .gitmodules
                 new file:   third_party/bar 

     通过 `git diff --cached` 命令可以看到 `.gitmodules` 中存储了子模块 `bar` 在 `foo` 中的路径, 以及远程库的 url. 对于子模块 `bar` 所在的 `third_party/bar` 这个目录, 仓库 `foo` 并没有跟踪里面的文件, 只是记录了 `bar` 的 commit id, 这个 commit id 与调用 `git submodule add` 命令添加子模块时, 子模块远程仓库的默认分支的 commit id 相同.

         # git diff --cached
         diff --git a/.gitmodules b/.gitmodules
         new file mode 100644
         index 0000000..1542c7d
         --- /dev/null
         +++ b/.gitmodules
         @@ -0,0 +1,3 @@
         +[submodule "third_party/bar"]
         +       path = third_party/bar
         +       url = /demo/bar.git
         diff --git a/third_party/bar b/third_party/bar
         new file mode 160000
         index 0000000..47dc847
         --- /dev/null
         +++ b/third_party/bar
         @@ -0,0 +1 @@
         +Subproject commit 47dc847f75da60f7b91f59fec43dabacced8e4c3

     注意, 此时 `thire_party/bar` 目录下是有文件的, 且与上面提到的仓库 bar 的 commit id 一致.

         $ ls third_party/bar/
         readme.txt

   - 此时在 `foo/.git/config` 文件中也已添加了子库对应的信息

3. 提交并推送到 `foo` 的远程仓库

       git commit -m "add submodule"
       git push origin HEAD

4. 克隆带 submodule 的仓库

       cd /demo
       git clone foo.git foo2

   说明:

   - 此时 `third_party/bar` 目录是空的

   - `.gitmodules` 文件中有子库信息

   - `.git/config` 文件中没有子库信息

5. 初始化子库
   
       cd /demo/foo2
       git submodule init

   说明:

   - 此时 `third_party/bar` 目录依然是空的

   - `.git/config` 文件中增加了子库信息

6. 获取子库代码并 checkout 父库中记录的分支, 并将子库 checkout 到父库记录的子库 commit id

       git submodule update

   - 此时 `third_party/bar` 目录下为子库相应 commit id 的内容

7. 初始化与获取子库 (包括子库中嵌套的子库) 的其他方式

       git clone --recurse-submodules foo.git foo2

   或

       git clone foo.git foo2
       cd foo2
       git submodule update --init --recursive

8. 更新子库的 commit id

       cd /demo/bar
       touch readme2.md
       git add .
       git commit -m "add readme2.txt"
       git push origin HEAD

       cd /demo/foo2
       cd /demo/foo2/third_party/bar/
       git checkout master
       git pull origin master
       cd ../../

   说明:

   - 此时通过 `git status` 可以看到 `foo2` 有变动

         $ git status
         On branch master
         Your branch is up to date with 'origin/master'.
         
         Changes not staged for commit:
           (use "git add <file>..." to update what will be committed)
           (use "git restore <file>..." to discard changes in working directory)
                 modified:   third_party/bar (new commits)
         
         no changes added to commit (use "git add" and/or "git commit -a")

   - 通过 `git diff` 命令可查看到 `foo2` 中维护的子库 bar 的 commit id 发生变化, 变为与 bar.git 远程仓库的 master 分支的 commit id 相同.

         # git diff
         diff --git a/third_party/bar b/third_party/bar
         index 47dc847..4787cbb 160000
         --- a/third_party/bar
         +++ b/third_party/bar
         @@ -1 +1 @@
         -Subproject commit 47dc847f75da60f7b91f59fec43dabacced8e4c3
         +Subproject commit 4787cbbfaea2df18c5c2ca91408ddaeb4a28eb8c

9. 提交仓库 foo2 的修改到远程分支

       git add .
       git commit -m "update bar commit id"
       git push origin HEAD

10. 使 foo 获取最新变更

        cd /demo/foo
        git pull origin master

    说明:

    - 此时通过 `git status` 可以看到 `foo` 有变动

          $ git status
          On branch master
          Your branch is up to date with 'origin/master'.
          
          Changes not staged for commit:
            (use "git add <file>..." to update what will be committed)
            (use "git restore <file>..." to discard changes in working directory)
                  modified:   third_party/bar (new commits)
          
          no changes added to commit (use "git add" and/or "git commit -a")

    - 通过 `git diff` 命令可查看到 `foo` 中维护的子库 bar 的 commit id 与 `foo2` 中更新的值不一致

          $ git diff
          diff --git a/third_party/bar b/third_party/bar
          index 4787cbb..47dc847 160000
          --- a/third_party/bar
          +++ b/third_party/bar
          @@ -1 +1 @@
          -Subproject commit 4787cbbfaea2df18c5c2ca91408ddaeb4a28eb8c
          +Subproject commit 47dc847f75da60f7b91f59fec43dabacced8e4c3

    - `third_party/bar` 目录也没有更新

11. 更新 foo 的子库

        git submodule update

## references

- [Git Submodule管理项目子模块](https://www.cnblogs.com/nicksheng/p/6201711.html)

- [git init 与git init --bare](https://blog.csdn.net/sinat_34349564/article/details/52487860)

- [Git Tools - Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
