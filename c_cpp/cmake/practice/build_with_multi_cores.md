# Build with Multi Cores

- [Build with Multi Cores](#build-with-multi-cores)
  - [Visual Studio IDE](#visual-studio-ide)
  - [Reference](#reference)

## Visual Studio IDE

    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MP")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP" )

## Reference

[CMake: building with all your cores](https://blog.kitware.com/cmake-building-with-all-your-cores/)
