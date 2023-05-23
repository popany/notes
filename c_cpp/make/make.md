# make

- [make](#make)
  - [GNU Make Manual](#gnu-make-manual)
  - [A Simple Makefile Tutorial](#a-simple-makefile-tutorial)
  - [Examples](#examples)
  - [Practice](#practice)
    - [Create directories using make file](#create-directories-using-make-file)
    - [Determine whether an environment variable is defined](#determine-whether-an-environment-variable-is-defined)
    - [Test whether a directory exists inside a makefile](#test-whether-a-directory-exists-inside-a-makefile)
    - [call bash cmd in makfile](#call-bash-cmd-in-makfile)
  - [command](#command)
    - [Pass macro definition](#pass-macro-definition)
  - [makefile 语法](#makefile-语法)

## [GNU Make Manual](https://www.gnu.org/software/make/manual/)

## [A Simple Makefile Tutorial](https://cs.colby.edu/maxwell/courses/tutorials/maketutor/)

## Examples

[Run make in each subdirectory](https://stackoverflow.com/questions/17834582/run-make-in-each-subdirectory)

## Practice

### [Create directories using make file](https://stackoverflow.com/questions/1950926/create-directories-using-make-file)

### [Determine whether an environment variable is defined](https://stackoverflow.com/a/69847025)

    $ cat Makefile
    ifdef FOO
    $(info FOO is defined)
    endif
    all:;@:

    $ make

    $ FOO=1 make
    FOO is defined

### [Test whether a directory exists inside a makefile](https://stackoverflow.com/a/20763842)

    .PHONY: all
    all:
    ifneq ($(wildcard ./check_dir/.),)
    	@echo "Found ./check_dir"
    else
    	@echo "Did not find ~/check_dir"
    endif

### call bash cmd in makfile

    $(shell mkdir test_dir)

## command

### Pass macro definition

Just use a specific variable for that. [[ref]](https://stackoverflow.com/questions/9052792/how-to-pass-macro-definition-from-make-command-line-arguments-d-to-c-source/9052937#9052937)

    $ cat Makefile 
    all:
        echo foo | gcc $(USER_DEFINES) -E -xc - 
    
    $ make USER_DEFINES="-Dfoo=one"
    echo foo | gcc -Dfoo=one -E -xc - 
    ...
    one
    
    $ make USER_DEFINES="-Dfoo=bar"
    echo foo | gcc -Dfoo=bar -E -xc - 
    ...
    bar
    
    $ make 
    echo foo | gcc  -E -xc - 
    ...
    foo

## makefile 语法

在 Makefile 中, 一句依赖语句通常被称为规则 (rule). 规则包含一个或多个组件, 主要有: 目标 (target) 依赖项 (prerequisites/dependencies) 和命令 (recipe/command)

一个典型的 Makefile 规则如下所示:

    target: dependencies
            commands

- 目标 (target): 该规则生成的文件

- 依赖项 (dependencies): 用于生成目标所需的文件列表

- 命令 (commands): 当任何依赖项发生更改时, 执行以生成目标的命令

以下是一个简单的 Makefile 规则示例:

    output.o: input.c input.h
            gcc -c input.c -o output.o

在这个示例中, output.o 是目标, input.c 和 input.h 是依赖项. 命令 gcc -c input.c -o output.o 用于从依赖项生成目标文件
