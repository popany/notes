# target_link_libraries

- [target_link_libraries](#target_link_libraries)
  - [PRIVATE v.s. PUBLIC](#private-vs-public)
  - [public link greeting](#public-link-greeting)
  - [private link greeting](#private-link-greeting)
  - [Conclusion](#conclusion)
  - [Supplementary](#supplementary)
  - [Experiment](#experiment)
    - [Experiment 1](#experiment-1)
    - [Experiment 2](#experiment-2)

## PRIVATE v.s. PUBLIC

project hello

    .
    ├── CMakeLists.txt
    ├── build
    ├── lib
    │   ├── CMakeLists.txt
    │   ├── greeting
    │   │   ├── CMakeLists.txt
    │   │   ├── greeting.cc
    │   │   └── greeting.h
    │   └── hello
    │       ├── CMakeLists.txt
    │       ├── hello.cc
    │       └── hello.h
    └── src
        ├── CMakeLists.txt
        └── main.cc

./CMakeLists.txt

    cmake_minimum_required (VERSION 3.15)

    project (hello)

    add_subdirectory (lib)
    add_subdirectory (src)

./lib/CMakeLists.txt

    add_subdirectory (hello)
    add_subdirectory (greeting)

./lib/greeting/CMakeLists.txt

    add_library (greeting STATIC greeting.cc)
    target_include_directories (greeting PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
    target_compile_options (greeting PRIVATE -fPIC)

 ./lib/greeting/greeting.cc

    #include "greeting.h"

    const char* greeting_str = "nice to meet you!";

    const char* greeting()
    {
        return greeting_str;
    }

./lib/greeting/greeting.h

    const char* greeting();

 ./lib/hello/CMakeLists.txt

    add_library (hello SHARED hello.cc)
    target_include_directories (hello PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
    if (PRIVATE_LINK_GREETING)
        message ("private link greeting")
        target_link_libraries (hello PRIVATE greeting)
    else ()
        message ("public link greeting")
        target_link_libraries (hello PUBLIC greeting)
    endif ()

./lib/hello/hello.cc

    #include <iostream>
    #include <greeting.h>

    void hello()
    {
        std::cout << "hello, " << greeting() << std::endl;
    }

./lib/hello/hello.h

    void hello();

./src/CMakeLists.txt

    add_executable (hello_demo main.cc)

    target_link_libraries (hello_demo PRIVATE hello)

./src/main.cc

    #include <hello.h>

    int main()
    {
        hello();

        return 0;
    }

## public link greeting

cmake

    $ cmake ..
    -- The C compiler identification is GNU 9.4.0
    -- The CXX compiler identification is GNU 9.4.0
    -- Detecting C compiler ABI info
    -- Detecting C compiler ABI info - done
    -- Check for working C compiler: /usr/bin/cc - skipped
    -- Detecting C compile features
    -- Detecting C compile features - done
    -- Detecting CXX compiler ABI info
    -- Detecting CXX compiler ABI info - done
    -- Check for working CXX compiler: /usr/bin/c++ - skipped
    -- Detecting CXX compile features
    -- Detecting CXX compile features - done
    public link greeting
    -- Configuring done
    -- Generating done
    -- Build files have been written to: /home/xjy/demo/build

make

    $ make VERBOSE=1
    ...
    [ 66%] Linking CXX shared library libhello.so
    cd /home/xjy/demo/build/lib/hello && /usr/bin/cmake -E cmake_link_script CMakeFiles/hello.dir/link.txt --verbose=1
    /usr/bin/c++ -fPIC -shared -Wl,-soname,libhello.so -o libhello.so CMakeFiles/hello.dir/hello.cc.o  ../greeting/libgreeting.a
    make[2]: Leaving directory '/home/xjy/demo/build'
    [ 66%] Built target hello
    ...

We can see the command to link libhello.so is:

    /usr/bin/c++ -fPIC -shared -Wl,-soname,libhello.so -o libhello.so CMakeFiles/hello.dir/hello.cc.o  ../greeting/libgreeting.a


nm -DC lib/hello/libhello.so

    $ nm -DC lib/hello/libhello.so
    ...
    0000000000001199 T hello()
    0000000000001252 T greeting()
    ...
    0000000000004048 D greeting_str
    ...

nm -DC src/hello_demo

    $ nm -DC src/hello_demo
    
                     w _ITM_deregisterTMCloneTable
                     w _ITM_registerTMCloneTable
                     U hello()
                     w __cxa_finalize
                     w __gmon_start__
                     U __libc_start_main

## private link greeting

cmake

    $ cmake .. -DPRIVATE_LINK_GREETING=ON
    -- The C compiler identification is GNU 9.4.0
    -- The CXX compiler identification is GNU 9.4.0
    -- Detecting C compiler ABI info
    -- Detecting C compiler ABI info - done
    -- Check for working C compiler: /usr/bin/cc - skipped
    -- Detecting C compile features
    -- Detecting C compile features - done
    -- Detecting CXX compiler ABI info
    -- Detecting CXX compiler ABI info - done
    -- Check for working CXX compiler: /usr/bin/c++ - skipped
    -- Detecting CXX compile features
    -- Detecting CXX compile features - done
    private link greeting
    -- Configuring done
    -- Generating done
    -- Build files have been written to: /home/xjy/demo/build

make

    $ make VERBOSE=1
    ...
    [ 66%] Linking CXX shared library libhello.so
    cd /home/xjy/demo/build/lib/hello && /usr/bin/cmake -E cmake_link_script CMakeFiles/hello.dir/link.txt --verbose=1
    /usr/bin/c++ -fPIC -shared -Wl,-soname,libhello.so -o libhello.so CMakeFiles/hello.dir/hello.cc.o  ../greeting/libgreeting.a
    make[2]: Leaving directory '/home/xjy/demo/build'
    [ 66%] Built target hello
    ...

We can see the command to link libhello.so is:

    /usr/bin/c++ -fPIC -shared -Wl,-soname,libhello.so -o libhello.so CMakeFiles/hello.dir/hello.cc.o  ../greeting/libgreeting.a

It's the same with the case of "public link greeting".

nm -DC lib/hello/libhello.so

    $ nm -DC lib/hello/libhello.so
    ...
    0000000000001199 T hello()
    0000000000001252 T greeting()
    ...
    0000000000004048 D greeting_str
    ...

It's the same with the case of "public link greeting".

nm -DC src/hello_demo

    $ nm -DC src/hello_demo
                     w _ITM_deregisterTMCloneTable
                     w _ITM_registerTMCloneTable
                     U hello()
                     w __cxa_finalize
                     w __gmon_start__
                     U __libc_start_main

It's the same with the case of "public link greeting".

## Conclusion

In this case, `target_link_libraries (hello PRIVATE greeting)` and `target_link_libraries (hello PUBLIC greeting)` makes no difference.

## Supplementary

    cmake version 3.22.1
    GNU Make 4.2.1
    gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)

## Experiment

### Experiment 1

mod src/main.cc to

    #include <hello.h>

    const char* greeting()
    {
        return "how are you!";
    }

    int main()
    {
        hello();

        return 0;
    }

output of `hemo_demo` changes to:

    hello, how are you!

nm -DC ./src/hello_demo

    $ nm -DC ./src/hello_demo
                     w _ITM_deregisterTMCloneTable
                     w _ITM_registerTMCloneTable
                     U hello()
    0000000000001149 T greeting()
                     w __cxa_finalize
                     w __gmon_start__
                     U __libc_start_main

### Experiment 2

make `greeting()` function defined in `src/main.cc` in "Experiment 1" `static`:

    #include <hello.h>

    static const char* greeting()
    {
        return "how are you!";
    }

    int main()
    {
        hello();

        return 0;
    }

output of `hemo_demo` changes back to:

    hello, nice to meet you!

nm -DC ./src/hello_demo

    $ nm -DC ./src/hello_demo
                     w _ITM_deregisterTMCloneTable
                     w _ITM_registerTMCloneTable
                     U hello()
                     w __cxa_finalize
                     w __gmon_start__
                     U __libc_start_main

    $ nm -C ./src/hello_demo |grep greeting
    0000000000001149 t greeting()