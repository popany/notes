# conan

- [conan](#conan)
  - [conan-io/cmake-conan](#conan-iocmake-conan)

## [conan-io/cmake-conan](https://github.com/conan-io/cmake-conan)

    include(conan.cmake)
    conan_cmake_run(CONANFILE conanfile.txt
                    BASIC_SETUP NO_OUTPUT_DIRS)

Pass to `conan_basic_setup(NO_OUTPUT_DIRS)` so `conanbuildinfo.cmake` does not change the output directories (lib, bin).






