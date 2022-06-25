# Add Header Only Lib

- [Add Header Only Lib](#add-header-only-lib)
  - [Exemple cpp-stub](#exemple-cpp-stub)

## Exemple cpp-stub

    add_library(cpp_stub INTERFACE)
    target_include_directories(cpp_stub
        INTERFACE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        ${CMAKE_CURRENT_SOURCE_DIR}/src_linux)
