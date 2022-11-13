# [Executable and Linkable Format 101 Part 4: Dynamic Linking](https://www.intezer.com/blog/elf/executable-linkable-format-101-part-4-dynamic-linking/)

- [Executable and Linkable Format 101 Part 4: Dynamic Linking](#executable-and-linkable-format-101-part-4-dynamic-linking)
  - [Linking Overview](#linking-overview)

## Linking Overview

In order to understand dynamic linking, we must first define linking. Linking is the process of joining together multiple object files, to create a shared library or an executable.

When one object file references functions or variables—which do not exist within the file’s context—but rather in other object files (dependencies), they must be linked. Linkers allow the use of separate, independent sources of code by providing a way to merge the code together into a single file, so the developer will be spared of this low-level detail.

There are two linking types:

- Static linking: Completed at the end of the compilation process

- Dynamic linking: Completed at load time by the system
Static linking is fairly simple:














TODO elf eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee