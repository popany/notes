# spdlog

- [spdlog](#spdlog)
  - [github](#github)
  - [Install](#install)
    - [Windows](#windows)

## [github](https://github.com/gabime/spdlog)

## Install

### Windows

    mkdir -p build
    cd build

    pushd
    Launch-VsDevShell.ps1
    popd

    cmake -G "Visual Studio 16 2019" -A Win32 --debug-trycompile -T v140 -DCMAKE_CONFIGURATION_TYPES="RelWithDebInfo" ..

    cmake --build . --config RelWithDebInfo
    cmake --install . --prefix c:\local