# cmake options

- [cmake options](#cmake-options)
  - [`CMAKE_EXPORT_COMPILE_COMMANDS`](#cmake_export_compile_commands)
  - [`EXECUTABLE_OUTPUT_PATH`](#executable_output_path)

## `CMAKE_EXPORT_COMPILE_COMMANDS`

Enable/Disable output of compile commands during generation.

If enabled, generates a `compile_commands.json` file containing the exact compiler calls for all translation units of the project in machine-readable form.

## `EXECUTABLE_OUTPUT_PATH`

**Old** executable location variable.

The target property [`RUNTIME_OUTPUT_DIRECTORY`](https://cmake.org/cmake/help/latest/prop_tgt/RUNTIME_OUTPUT_DIRECTORY.html#prop_tgt:RUNTIME_OUTPUT_DIRECTORY) supersedes this variable for a target if it is set. Executable targets are otherwise placed in this directory.

