# cmake options

- [cmake options](#cmake-options)
  - [`CMAKE_EXPORT_COMPILE_COMMANDS`](#cmake_export_compile_commands)
  - [`EXECUTABLE_OUTPUT_PATH`](#executable_output_path)
  - [`CMAKE_RUNTIME_OUTPUT_DIRECTORY`](#cmake_runtime_output_directory)
  - [`CMAKE_ARCHIVE_OUTPUT_DIRECTORY`](#cmake_archive_output_directory)
  - [`CMAKE_LIBRARY_OUTPUT_DIRECTORY`](#cmake_library_output_directory)

## `CMAKE_EXPORT_COMPILE_COMMANDS`

Enable/Disable output of compile commands during generation.

If enabled, generates a `compile_commands.json` file containing the exact compiler calls for all translation units of the project in machine-readable form.

## `EXECUTABLE_OUTPUT_PATH`

**Old** executable location variable.

The target property [`RUNTIME_OUTPUT_DIRECTORY`](https://cmake.org/cmake/help/latest/prop_tgt/RUNTIME_OUTPUT_DIRECTORY.html#prop_tgt:RUNTIME_OUTPUT_DIRECTORY) supersedes this variable for a target if it is set. Executable targets are otherwise placed in this directory.

## `CMAKE_RUNTIME_OUTPUT_DIRECTORY`

Where to put all the [`RUNTIME`](https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#runtime-output-artifacts) target files when built.

This variable is used to initialize the [`RUNTIME_OUTPUT_DIRECTORY`](https://cmake.org/cmake/help/latest/prop_tgt/RUNTIME_OUTPUT_DIRECTORY.html#prop_tgt:RUNTIME_OUTPUT_DIRECTORY) property on all the targets. See that target property for additional information.

## `CMAKE_ARCHIVE_OUTPUT_DIRECTORY`

Where to put all the [`ARCHIVE`](https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#archive-output-artifacts) target files when built.

This variable is used to initialize the [`ARCHIVE_OUTPUT_DIRECTORY`](https://cmake.org/cmake/help/latest/prop_tgt/ARCHIVE_OUTPUT_DIRECTORY.html#prop_tgt:ARCHIVE_OUTPUT_DIRECTORY) property on all the targets. See that target property for additional information.

## `CMAKE_LIBRARY_OUTPUT_DIRECTORY`

Where to put all the [`LIBRARY`](https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#library-output-artifacts) target files when built.

This variable is used to initialize the [`LIBRARY_OUTPUT_DIRECTORY`](https://cmake.org/cmake/help/latest/prop_tgt/LIBRARY_OUTPUT_DIRECTORY.html#prop_tgt:LIBRARY_OUTPUT_DIRECTORY) property on all the targets. See that target property for additional information.
