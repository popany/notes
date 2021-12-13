# git branch

- [git branch](#git-branch)
  - [`git branch -u <upstream>`](#git-branch--u-upstream)

## `git branch -u <upstream>`

将分支 `<upstream>` 设置为当前分支的 upstream 分支

案例:

1. 创建一个裸仓库

       git init --bare /demo/foo.git

2. 分别克隆仓库 `foo.git` 到仓库 `foo1`/`foo2`

       cd /demo
       git clone foo.git foo1
       git clone foo.git foo2

3. 在仓库 `foo1` 中创建分支 `b` 做任意修改, 提交后推送至 `foo.git`

       cd /demo/foo1
       git checkout -b b
       touch b.txt
       git add .
       git commit -m "add b.txt"
       git push origin HEAD

4. 切换到仓库 `foo2`, 获取并切换到分支 `b`

       cd /demo/foo2
       git fetch origin b
       git checkout b

5. 在仓库 `foo2` 中查看分支 `b` 的 `upstream` 分支

       & git branch -vv
       * b bfcd659 [origin/b] add b.txt

6. 在仓库 `foo2` 中创建分支 `c` 并做任意修改后提交

       git checkout -b c
       touch c.txt
       git add .
       git commit -m "add c.txt"

7. 在仓库 `foo2` 中切换回分支 `b`, 将分支 `c` 设置为分支 `b` 的 `upstream` 分支

       git checkout b
       git branch -u c

8. 在仓库 `foo2` 查看分支 `b` 的 `upstream` 分支

       $ git branch -vv
       * b bfcd659 [c: behind 1] add b.txt
         c c776088 add c.txt

   注意:

   - 此时分支 `b` 的 `upstream` 分支不再是 `origin/b`

9. 在仓库 `foo2` 中 `rebase` 分支 `b` 到它的 `upstream` 分支

       git checkout b
       git rebase

10. 查看结果

        & git log --graph --pretty=oneline --abbrev-commit
        * c776088 (HEAD -> b, c) add c.txt
        * bfcd659 (origin/b) add b.txt

    可见分支 `b` 已具有其 `upstream` 分支 `c` 的更新

11. 在仓库 `foo1` 中在分支 `b` 中做提交后推送到远端

        cd /demo/foo1
        touch b1.txt
        git add .
        git commit -m "add b1.txt"
        git push origin HEAD

12. 在仓库 `foo2` 中获取分支 `b` 的远程变更, 切换到分支 `b`

        cd /demo/foo2
        git fetch origin b
        git checkout b

13. 调用 `git rebase`

        & git rebase
        Current branch b is up to date.

    说明:

    因为分支 `b` 的 `upstream` 分支 `c` 没有变化, 所以上面的 `git rebase` 命令不会更新分支 `b`

14. 在仓库 `foo2` 中将分支 `b` 的 `upstream` 分支设置为 `origin b`

        git checkout b
        $ git branch -u origin/b
        Branch 'b' set up to track remote branch 'b' from 'origin'.

15. 调用 `git rebase`

        $ git rebase
        Successfully rebased and updated refs/heads/b.

16. 查看结果

        $ git log --graph --pretty=oneline --abbrev-commit
        * c23a8e4 (HEAD -> b) add c.txt
        * 809ae73 (origin/b) add b1.txt
        * bfcd659 add b.txt

    可见分支 `b` 已具有其 `upstream` 分支 `origin/b` 的更新
