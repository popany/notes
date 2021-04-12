# git

- [git](#git)
  - [`git commmit`](#git-commmit)
    - [Change last commit time](#change-last-commit-time)
  - [`git tag`](#git-tag)
    - [List tags with pattern `v-*`](#list-tags-with-pattern-v-)
    - [Add a tag](#add-a-tag)
    - [Delete a tag](#delete-a-tag)
    - [Checkout a tag](#checkout-a-tag)
    - [Fetch origin tags](#fetch-origin-tags)
  - [`git clone`](#git-clone)
  - [`git diff`](#git-diff)
    - [Show changed files's name between two branches](#show-changed-filess-name-between-two-branches)
  - [`git show`](#git-show)
    - [View a file at a specific commit](#view-a-file-at-a-specific-commit)
  - [git submodule](#git-submodule)
    - [Starting with Submodules](#starting-with-submodules)
    - [Cloning a Project with Submodules](#cloning-a-project-with-submodules)
    - [`git submodule` command](#git-submodule-command)
  - [Practice](#practice)
    - [SSH Key](#ssh-key)
  - [Config](#config)
    - [`autocrlf`](#autocrlf)
    - [safecrlf](#safecrlf)
  - [Q&A](#qa)

## `git commmit`

### Change last commit time

    git commit --amend --date="$(date -R)"

or

    git commit --amend --date=`date -R`

or

    git commit --amend --date="Sun, 25 Dec 2016 19:42:09 +0800"

## `git tag`

### List tags with pattern `v-*`

    git tag -l 'v-*'

### Add a tag

    git tag tag-name

### Delete a tag

    git tag -d tag-name

### Checkout a tag

    git checkout tag-name

### Fetch origin tags

    git fetch --tags --all

## `git clone`

    --branch <name>, -b <name>
        Instead of pointing the newly created HEAD to the branch pointed to by the cloned repositoryâ€™s HEAD, point to <name> branch instead. In a non-bare repository, this is the branch that will be checked out. --branch can also take tags and detaches the HEAD at that commit in the resulting repository.    

## `git diff`

### Show changed files's name between two branches

    git diff foo bar --name-only

## `git show`

### View a file at a specific commit

    git show REVISION:/path/to/file

## [git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

It often happens that while working on one project, you need to **use another project from within it**. Perhaps it’s a library that a third party developed or that you’re developing separately and using in multiple parent projects. A **common issue** arises in these scenarios: you want to be able to treat the two projects as separate yet still be able to use one from within the other.

Here’s an example. Suppose you’re developing a website and creating Atom feeds. Instead of writing your own Atom-generating code, you decide to use a library. You’re likely to have to either include this code from a shared library like a CPAN install or Ruby gem, or copy the source code into your own project tree. The issue with including the library is that it’s difficult to customize the library in any way and often more difficult to deploy it, because you need to make sure every client has that library available. The issue with copying the code into your own project is that any custom changes you make are difficult to merge when upstream changes become available.

Git addresses this issue using submodules. Submodules allow you to keep a Git repository **as a subdirectory** of another Git repository. This lets you clone another repository into your project and **keep your commits separate**.

### Starting with Submodules

We’ll walk through developing a simple project that has been split up into a main project and a few sub-projects.

Let’s start by **adding an existing Git repository as a submodule** of the repository that we’re working on. To add a new submodule you use the git submodule add command with the **absolute or relative URL** of the project you would like to start tracking. In this example, we’ll add a library called “DbConnector”.

    $ git submodule add https://github.com/chaconinc/DbConnector
    Cloning into 'DbConnector'...
    remote: Counting objects: 11, done.
    remote: Compressing objects: 100% (10/10), done.
    remote: Total 11 (delta 0), reused 11 (delta 0)
    Unpacking objects: 100% (11/11), done.
    Checking connectivity... done.

By default, submodules will add the subproject into a directory named the same as the repository, in this case “DbConnector”. You can add a different path at the end of the command if you want it to go elsewhere.

If you run git status at this point, you’ll notice a few things.

    $ git status
    On branch master
    Your branch is up-to-date with 'origin/master'.

    Changes to be committed:
    (use "git reset HEAD <file>..." to unstage)

        new file:   .gitmodules
        new file:   DbConnector

First you should notice the new `.gitmodules` file. This is a configuration file that stores the mapping between the project’s URL and the local subdirectory you’ve pulled it into:

    [submodule "DbConnector"]
        path = DbConnector
        url = https://github.com/chaconinc/DbConnector

If you have multiple submodules, you’ll have multiple entries in this file. It’s important to note that this file is **version-controlled with your other files**, like your .gitignore file. It’s pushed and pulled with the rest of your project. **This is how other people who clone this project know where to get the submodule projects from**.

Note:  
Since the URL in the `.gitmodules` file is what other people will first try to clone/fetch from, make sure to use a URL that they can access if possible. For example, if you use a different URL to push to than others would to pull from, use the one that others have access to. You can overwrite this value locally with `git config submodule.DbConnector.url PRIVATE_URL` for your own use. When applicable, a relative URL can be helpful.

The other listing in the `git status` output is the project folder entry. If you run `git diff` on that, you see something interesting:

    $ git diff --cached DbConnector
    diff --git a/DbConnector b/DbConnector
    new file mode 160000
    index 0000000..c3f01dc
    --- /dev/null
    +++ b/DbConnector
    @@ -0,0 +1 @@
    +Subproject commit c3f01dc8862123d317dd46284b05b6892c7b29bc

Although `DbConnector` is a subdirectory in your working directory, Git sees it as a submodule and **doesn’t track its contents** when you’re not in that directory. Instead, Git sees it as a particular commit from that repository.

If you want a little nicer diff output, you can pass the `--submodule` option to `git diff`.

    $ git diff --cached --submodule
    diff --git a/.gitmodules b/.gitmodules
    new file mode 100644
    index 0000000..71fc376
    --- /dev/null
    +++ b/.gitmodules
    @@ -0,0 +1,3 @@
    +[submodule "DbConnector"]
    +       path = DbConnector
    +       url = https://github.com/chaconinc/DbConnector
    Submodule DbConnector 0000000...c3f01dc (new submodule)

When you commit, you see something like this:

    $ git commit -am 'Add DbConnector module'
    [master fb9093c] Add DbConnector module
    2 files changed, 4 insertions(+)
    create mode 100644 .gitmodules
    create mode 160000 DbConnector

Notice the `160000` mode for the `DbConnector` entry. That is a special mode in Git that basically means you’re **recording a commit as a directory entry** rather than a subdirectory or a file.

Lastly, push these changes:

    git push origin master

### Cloning a Project with Submodules

Here we’ll clone a project with a submodule in it. When you clone such a project, by default you get the directories that contain submodules, but none of the files within them yet:

    $ git clone https://github.com/chaconinc/MainProject
    Cloning into 'MainProject'...
    remote: Counting objects: 14, done.
    remote: Compressing objects: 100% (13/13), done.
    remote: Total 14 (delta 1), reused 13 (delta 0)
    Unpacking objects: 100% (14/14), done.
    Checking connectivity... done.
    $ cd MainProject
    $ ls -la
    total 16
    drwxr-xr-x   9 schacon  staff  306 Sep 17 15:21 .
    drwxr-xr-x   7 schacon  staff  238 Sep 17 15:21 ..
    drwxr-xr-x  13 schacon  staff  442 Sep 17 15:21 .git
    -rw-r--r--   1 schacon  staff   92 Sep 17 15:21 .gitmodules
    drwxr-xr-x   2 schacon  staff   68 Sep 17 15:21 DbConnector
    -rw-r--r--   1 schacon  staff  756 Sep 17 15:21 Makefile
    drwxr-xr-x   3 schacon  staff  102 Sep 17 15:21 includes
    drwxr-xr-x   4 schacon  staff  136 Sep 17 15:21 scripts
    drwxr-xr-x   4 schacon  staff  136 Sep 17 15:21 src
    $ cd DbConnector/
    $ ls
    $

The `DbConnector` directory is there, but empty. You must run two commands: `git submodule init` to initialize your **local configuration** file, and `git submodule update` to **fetch all the data** from that project and check out the appropriate commit listed in your superproject:

    $ git submodule init
    Submodule 'DbConnector' (https://github.com/chaconinc/DbConnector) registered for path 'DbConnector'
    $ git submodule update
    Cloning into 'DbConnector'...
    remote: Counting objects: 11, done.
    remote: Compressing objects: 100% (10/10), done.
    remote: Total 11 (delta 0), reused 11 (delta 0)
    Unpacking objects: 100% (11/11), done.
    Checking connectivity... done.
    Submodule path 'DbConnector': checked out 'c3f01dc8862123d317dd46284b05b6892c7b29bc'

Now your DbConnector subdirectory is at the exact state it was in when you committed earlier.

There is another way to do this which is a little simpler, however. If you pass `--recurse-submodules` to the `git clone` command, it will automatically initialize and update each submodule in the **repository**, including **nested submodules** if any of the **submodules in the repository have submodules themselves**.

    $ git clone --recurse-submodules https://github.com/chaconinc/MainProject
    Cloning into 'MainProject'...
    remote: Counting objects: 14, done.
    remote: Compressing objects: 100% (13/13), done.
    remote: Total 14 (delta 1), reused 13 (delta 0)
    Unpacking objects: 100% (14/14), done.
    Checking connectivity... done.
    Submodule 'DbConnector' (https://github.com/chaconinc/DbConnector) registered for path 'DbConnector'
    Cloning into 'DbConnector'...
    remote: Counting objects: 11, done.
    remote: Compressing objects: 100% (10/10), done.
    remote: Total 11 (delta 0), reused 11 (delta 0)
    Unpacking objects: 100% (11/11), done.
    Checking connectivity... done.
    Submodule path 'DbConnector': checked out 'c3f01dc8862123d317dd46284b05b6892c7b29bc'

If you already cloned the project and forgot `--recurse-submodules`, you can combine the `git submodule init` and `git submodule update` steps by running `git submodule update --init`. To also initialize, fetch and checkout any nested submodules, you can use the foolproof **`git submodule update --init --recursive`**.

### `git submodule` command

With `git clone`

    git clone --recurse-submodules https://github.com/chaconinc/MainProject

Initialize, fetch and checkout any nested submodules

    git submodule update --init --recursive

## Practice

### SSH Key

    git config --global --add user.name "xxx"
    git config --global --add user.email "xxx@example.com"
    ssh-keygen -t rsa -b 4096 -C "xxx@example.com"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa

## Config

### `autocrlf`

    // 提交时转换为LF，检出时转换为CRLF
    git config --global core.autocrlf true

    // 提交时转换为LF，检出时不转换
    git config --global core.autocrlf input

    // 提交检出均不转换
    git config --global core.autocrlf false

### safecrlf

    #拒绝提交包含混合换行符的文件
    git config --global core.safecrlf true   

    #允许提交包含混合换行符的文件
    git config --global core.safecrlf false   

    #提交包含混合换行符的文件时给出警告
    git config --global core.safecrlf warn

## Q&A

- [git rm - fatal: pathspec did not match any files](https://stackoverflow.com/questions/25458306/git-rm-fatal-pathspec-did-not-match-any-files)
