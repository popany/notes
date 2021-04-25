# spdlog

- [spdlog](#spdlog)
  - [github](#github)
  - [Install](#install)
    - [Windows](#windows)
      - [CMakeLists.txt](#cmakeliststxt)
  - [Use](#use)
    - [Define Macros (win32)](#define-macros-win32)
    - [Init Log](#init-log)
      - [reference](#reference)
  - [Document](#document)

## [github](https://github.com/gabime/spdlog)

## Install

For version v1.8.5

### Windows

    mkdir -p build
    cd build

    pushd
    Launch-VsDevShell.ps1
    popd

    cmake -G "Visual Studio 16 2019" -A Win32 --debug-trycompile -T v140 -DCMAKE_CONFIGURATION_TYPES="RelWithDebInfo" ..

    cmake --build . --config RelWithDebInfo
    cmake --install . --prefix c:\local

#### CMakeLists.txt

    list(APPEND CMAKE_PREFIX_PATH $ENV{SPDLOG_INSTALL_DIR}\\lib\\cmake\\spdlog)

    find_package(spdlog REQUIRED)

    add_executable(example_header_only example.cpp)
    target_link_libraries(example_header_only PRIVATE spdlog::spdlog_header_only)

## Use

### Define Macros (win32)

    #include "spdlog/spdlog.h"

    #define CC_(a,b) a##b // concatenate
    #define CC(a,b) CC_(a,b)
    #define CC3(a,b,c) CC(CC(a,b),c)
    #define TS_(a) #a // to string
    #define TS(a) TS_(a)
    #define FUNCTION_LINE_ CC3(__FUNCTION__,":",TS(__LINE__))
    #define FUNCTION_LINE CC3("[",FUNCTION_LINE_,"] ")
    #define LOG_FMT(fmt) CC(FUNCTION_LINE, fmt)

    #define LOG_DEBUG(fmt, ...) spdlog::debug(LOG_FMT(fmt), ##__VA_ARGS__)
    #define LOG_INFO(fmt, ...) spdlog::info(LOG_FMT(fmt), ##__VA_ARGS__)
    #define LOG_WARN(fmt, ...) spdlog::warn(LOG_FMT(fmt), ##__VA_ARGS__)
    #define LOG_ERROR(fmt, ...) spdlog::error(LOG_FMT(fmt), ##__VA_ARGS__)

### Init Log

    #include "spdlog/sinks/stdout_color_sinks.h"
    #include "spdlog/sinks/daily_file_sink.h"

    void loggerInit()
    {
        std::vector<spdlog::sink_ptr> sinks;
        sinks.push_back(std::make_shared<spdlog::sinks::stdout_color_sink_mt>());
        sinks.push_back(std::make_shared<spdlog::sinks::daily_file_sink_mt>("app.log", 0, 0));
        auto combined_logger = std::make_shared<spdlog::logger>("applog", begin(sinks), end(sinks));
        combined_logger->set_level(spdlog::level::debug);
        combined_logger->set_pattern("[%Y-%m-%d %H:%M:%S.%e][%^%l%$][pid %P][tid %t]%v");
        //register it if you need to access it globally
        spdlog::set_default_logger(combined_logger);
    }

#### reference

[Creating loggers with multiple sinks](https://spdlog.docsforge.com/v1.x/2.creating-loggers/#creating-loggers-with-multiple-sinks)

[Thread Safety](https://spdlog.docsforge.com/v1.x/1.1.thread-safety/)

[Default Logger](https://spdlog.docsforge.com/v1.x/default-logger/)

## [Document](https://spdlog.docsforge.com/)

[Custom Formatting](https://spdlog.docsforge.com/v1.x/3.custom-formatting/)
