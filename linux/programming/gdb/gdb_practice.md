# gdb practice

- [gdb practice](#gdb-practice)
  - [Print C++ vtables using GDB](#print-c-vtables-using-gdb)
  - [打印局部静态符号](#打印局部静态符号)
  - [查找函数](#查找函数)
  - [查看 core 文件中动态库路径](#查看-core-文件中动态库路径)

## [Print C++ vtables using GDB](https://stackoverflow.com/questions/6191678/print-c-vtables-using-gdb)

    p /a (*(void ***)obj)[0]@10

    p /a (*(void ***)(*this))[0]@10

    p /a (*(void ***)(this))[0]@10

## 打印局部静态符号

    p (spdlog::details::registry) 'spdlog::details::registry::instance()::s_instance'

查看符号名

    nm -C xxx.so | grep "spdlog::details::registry::instance"

## 查找函数

    info functions <regex>

## 查看 core 文件中动态库路径

    gdb -c <core-file> <executable-file> -ex "i sharedlibrary" --batch

