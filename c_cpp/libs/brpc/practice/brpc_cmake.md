# brpc cmake

- [brpc cmake](#brpc-cmake)
  - [Use `ExternalProject_Add`](#use-externalproject_add)
    - [brpc.cmake](#brpccmake)
    - [Pass a list of prefix paths to ExternalProject_Add in CMAKE_ARGS](#pass-a-list-of-prefix-paths-to-externalproject_add-in-cmake_args)

## Use `ExternalProject_Add`

### [brpc.cmake](https://gitcode.net/paddlepaddle/Serving/-/blob/develop/cmake/external/brpc.cmake)

    # Copyright (c) 2016 PaddlePaddle Authors. All Rights Reserved.
    #
    # Licensed under the Apache License, Version 2.0 (the "License");
    # you may not use this file except in compliance with the License.
    # You may obtain a copy of the License at
    #
    # http://www.apache.org/licenses/LICENSE-2.0
    #
    # Unless required by applicable law or agreed to in writing, software
    # distributed under the License is distributed on an "AS IS" BASIS,
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    # See the License for the specific language governing permissions and
    # limitations under the License.
    
    INCLUDE(ExternalProject)
    set(BRPC_CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-narrowing")
    set(BRPC_CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-narrowing")
    set(BRPC_CMAKE_CPP_FLAGS "${CMAKE_CPP_FLAGS} -Wno-narrowing")
    
    find_package(OpenSSL REQUIRED) 
    
    message(STATUS "ssl:" ${OPENSSL_SSL_LIBRARY})
    message(STATUS "crypto:" ${OPENSSL_CRYPTO_LIBRARY})
    
    ADD_LIBRARY(ssl SHARED IMPORTED GLOBAL)
    SET_PROPERTY(TARGET ssl PROPERTY IMPORTED_LOCATION ${OPENSSL_SSL_LIBRARY})
    
    ADD_LIBRARY(crypto SHARED IMPORTED GLOBAL)
    SET_PROPERTY(TARGET crypto PROPERTY IMPORTED_LOCATION ${OPENSSL_CRYPTO_LIBRARY})
    
    SET(BRPC_SOURCES_DIR ${THIRD_PARTY_PATH}/brpc)
    SET(BRPC_INSTALL_DIR ${THIRD_PARTY_PATH}/install/brpc)
    SET(BRPC_INCLUDE_DIR "${BRPC_INSTALL_DIR}/include" CACHE PATH "brpc include directory." FORCE)
    SET(BRPC_LIBRARIES "${BRPC_INSTALL_DIR}/lib/libbrpc.a" CACHE FILEPATH "brpc library." FORCE)
    
    INCLUDE_DIRECTORIES(${BRPC_INCLUDE_DIR})
    
    # Reference https://stackoverflow.com/questions/45414507/pass-a-list-of-prefix-paths-to-externalproject-add-in-cmake-args
    set(prefix_path "${THIRD_PARTY_PATH}/install/gflags|${THIRD_PARTY_PATH}/install/leveldb|${THIRD_PARTY_PATH}/install/snappy|${THIRD_PARTY_PATH}/install/gtest|${THIRD_PARTY_PATH}/install/protobuf|${THIRD_PARTY_PATH}/install/zlib|${THIRD_PARTY_PATH}/install/glog")
    
    if(WITH_LITE)
        set(BRPC_REPO "https://github.com/apache/incubator-brpc")
        set(BRPC_TAG "1.0.0-rc01")
    else()
        set(BRPC_REPO "https://github.com/apache/incubator-brpc")
        set(BRPC_TAG "1.0.0-rc01")
    endif()
    
    # If minimal .a is need, you can set  WITH_DEBUG_SYMBOLS=OFF
    ExternalProject_Add(
        extern_brpc
        ${EXTERNAL_PROJECT_LOG_ARGS}
        # TODO(gongwb): change to de newst repo when they changed.
        GIT_REPOSITORY  ${BRPC_REPO}
        GIT_TAG         ${BRPC_TAG}
        PREFIX          ${BRPC_SOURCES_DIR}
        UPDATE_COMMAND  ""
        CMAKE_ARGS      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                        -DCMAKE_CXX_FLAGS=${BRPC_CMAKE_CXX_FLAGS}
                        -DCMAKE_C_FLAGS=${BRPC_CMAKE_C_FLAGS}
                        -DCMAKE_CPP_FLAGS=${BRPC_CMAKE_CPP_FLAGS}
                        -DCMAKE_INSTALL_PREFIX=${BRPC_INSTALL_DIR}
                        -DCMAKE_INSTALL_LIBDIR=${BRPC_INSTALL_DIR}/lib
                        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
                        -DCMAKE_BUILD_TYPE=${THIRD_PARTY_BUILD_TYPE}
                        -DCMAKE_PREFIX_PATH=${prefix_path}
                        -DWITH_GLOG=ON
                        -DIOBUF_WITH_HUGE_BLOCK=ON
                        -DBRPC_WITH_RDMA=${WITH_BRPC_RDMA}
                        ${EXTERNAL_OPTIONAL_ARGS}
        LIST_SEPARATOR |
        CMAKE_CACHE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${BRPC_INSTALL_DIR}
                         -DCMAKE_INSTALL_LIBDIR:PATH=${BRPC_INSTALL_DIR}/lib
                         -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
                         -DCMAKE_BUILD_TYPE:STRING=${THIRD_PARTY_BUILD_TYPE}
    )
    # ADD_DEPENDENCIES(extern_brpc protobuf ssl crypto leveldb gflags glog gtest snappy)
    ADD_DEPENDENCIES(extern_brpc protobuf ssl crypto leveldb gflags glog snappy)
    ADD_LIBRARY(brpc STATIC IMPORTED GLOBAL)
    SET_PROPERTY(TARGET brpc PROPERTY IMPORTED_LOCATION ${BRPC_LIBRARIES})
    ADD_DEPENDENCIES(brpc extern_brpc)
    
    add_definitions(-DBRPC_WITH_GLOG)
    
    LIST(APPEND external_project_dependencies brpc)

### [Pass a list of prefix paths to ExternalProject_Add in CMAKE_ARGS](https://stackoverflow.com/questions/45414507/pass-a-list-of-prefix-paths-to-externalproject-add-in-cmake-args)

After some more searching I've found on [this page](https://public.kitware.com/Bug/view.php?id=16137) that the `LIST_SEPARATOR` parameter of `ExternalProject_Add` does the trick. Unfortunately the documentation about the use of this parameter isn't very meaningful.

Here is the solution for my problem:

    set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} 
       ${CMAKE_SOURCE_DIR}/MyProject/cmake_packages
       ${CMAKE_SOURCE_DIR}/OtherProjects/cmake_packages)
    
    # Create a list with an alternate separator e.g. pipe symbol
    string(REPLACE ";" "|" CMAKE_PREFIX_PATH_ALT_SEP "${CMAKE_PREFIX_PATH}")
    
    ExternalProject_Add(MyProject
       DOWNLOAD_COMMAND ""
       SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/source
       BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/MyProjectBuild
       INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/MyProjectInstall
       LIST_SEPARATOR | # Use the alternate list separator
       CMAKE_ARGS 
                  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/MyProjectInstall
                  -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ALT_SEP}
       )
