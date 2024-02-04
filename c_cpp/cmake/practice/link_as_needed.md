# Link as Needed

## `--as-needed` linker option

设置链接器仅当符号被实际使用时才将库链接到最终的二进制文件中.

例如，在 g++ 中:

    g++ main.cpp -o main -Wl,--as-needed -lunused_library

## 在 CMake 中添加 `--as-needed` 连接器选项的方式

### 通过 `target_link_options `

    cmake_minimum_required(VERSION 3.13)

    project(MyProject)

    add_executable(my_executable main.cpp)

    # 使用target_link_options添加--as-needed标志
    target_link_options(my_executable PRIVATE "-Wl,--as-needed")

    # 链接其他库
    target_link_libraries(my_executable PRIVATE some_library)

### 通过 `target_link_libraries`

    cmake_minimum_required(VERSION 3.0)

    project(MyProject)

    add_executable(my_executable main.cpp)

    # 在target_link_libraries中添加--as-needed标志
    target_link_libraries(my_executable PRIVATE -Wl,--as-needed some_library)
