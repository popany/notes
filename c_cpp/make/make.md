# make

- [make](#make)
  - [GNU Make Manual](#gnu-make-manual)
  - [A Simple Makefile Tutorial](#a-simple-makefile-tutorial)
  - [Examples](#examples)
  - [Practice](#practice)
    - [Create directories using make file](#create-directories-using-make-file)
  - [command](#command)
    - [Pass macro definition](#pass-macro-definition)

## [GNU Make Manual](https://www.gnu.org/software/make/manual/)

## [A Simple Makefile Tutorial](https://cs.colby.edu/maxwell/courses/tutorials/maketutor/)

## Examples

[Run make in each subdirectory](https://stackoverflow.com/questions/17834582/run-make-in-each-subdirectory)

## Practice

### [Create directories using make file](https://stackoverflow.com/questions/1950926/create-directories-using-make-file)

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
