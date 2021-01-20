# Binutils Examples

- [Binutils Examples](#binutils-examples)
  - [`readelf`](#readelf)
    - [Show required dynamic libraries](#show-required-dynamic-libraries)
    - [Show path and source file name](#show-path-and-source-file-name)

## `readelf`

### Show required dynamic libraries

    readelf -d <path-to-elf-file>

### Show path and source file name

    readelf --string-dump=.debug_str YOUR_PROGRAM | sed -n '/\/\|\.c/{s/.*\]  //p}'



