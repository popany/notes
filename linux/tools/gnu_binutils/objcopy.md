# [objcopy](https://sourceware.org/binutils/docs-2.36/binutils/objcopy.html#objcopy)

- [objcopy](#objcopy)
  - [Options](#options)
    - [`-S`, `--strip-all`](#-s---strip-all)
  - [Practice](#practice)
    - [Copy without relocation/symbol/debug](#copy-without-relocationsymboldebug)

## Options

### `-S`, `--strip-all`

Do not copy relocation and symbol information from the source file. Also deletes debug sections.

## Practice

### Copy without relocation/symbol/debug

    objcopy -S a.out b.out
