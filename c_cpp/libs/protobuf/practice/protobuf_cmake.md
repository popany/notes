# protobuf

- [protobuf](#protobuf)
  - [Use ExternalProject_Addk](#use-externalproject_addk)

## Use ExternalProject_Addk

reference: [CMakeLists.txt](https://chromium.googlesource.com/external/github.com/grpc/grpc/+/HEAD/examples/cpp/helloworld/cmake_externalproject/CMakeLists.txt)

    # Builds protobuf project from the git submodule.
    ExternalProject_Add(protobuf
      PREFIX protobuf
      SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../../third_party/protobuf/cmake"
      CMAKE_CACHE_ARGS
            -Dprotobuf_BUILD_TESTS:BOOL=OFF
            -Dprotobuf_WITH_ZLIB:BOOL=OFF
            -Dprotobuf_MSVC_STATIC_RUNTIME:BOOL=OFF
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/protobuf
    )
