# Visual Studio

- [Visual Studio](#visual-studio)
  - [MSBuild](#msbuild)
  - [Additional MSVC Build Tools](#additional-msvc-build-tools)
    - [LIB.EXE](#libexe)
    - [EDITBIN.EXE](#editbinexe)
    - [DUMPBIN.EXE](#dumpbinexe)
    - [DUMPBIN options](#dumpbin-options)
    - [NMAKE](#nmake)
    - [ERRLOOK](#errlook)
    - [XDCMake](#xdcmake)
    - [BSCMAKE.EXE](#bscmakeexe)

[Install Build Tools into a container](https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2019)

## [MSBuild](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild?view=vs-2019)

## [Additional MSVC Build Tools](https://docs.microsoft.com/en-us/cpp/build/reference/c-cpp-build-tools?view=vs-2019)

### [LIB.EXE](https://docs.microsoft.com/en-us/cpp/build/reference/lib-reference?view=vs-2019)

LIB.EXE is used to create and manage a library of Common Object File Format (COFF) object files. It can also be used to create export files and import libraries to reference exported definitions.

### [EDITBIN.EXE](https://docs.microsoft.com/en-us/cpp/build/reference/editbin-reference?view=vs-2019)

EDITBIN.EXE is used to modify COFF binary files.

### [DUMPBIN.EXE](https://docs.microsoft.com/en-us/cpp/build/reference/dumpbin-reference?view=vs-2019)

DUMPBIN.EXE displays information (such as a symbol table) about COFF binary files.

### DUMPBIN options

Only the [/HEADERS](https://docs.microsoft.com/en-us/cpp/build/reference/headers?view=vs-2019) DUMPBIN option is available for use on files produced with the [/GL](https://docs.microsoft.com/en-us/cpp/build/reference/gl-whole-program-optimization?view=vs-2019) compiler option.

- [/CLRHEADER](https://docs.microsoft.com/en-us/cpp/build/reference/clrheader?view=vs-2019)

  Display CLR-specific information.    

  One way to determine whether an image was built for the common language runtime is to use `dumpbin /CLRHEADER`

- [/DEPENDENTS](https://docs.microsoft.com/en-us/cpp/build/reference/dependents?view=vs-2019)

  Dumps the names of the DLLs from which the image imports functions. You can use the list to determine which DLLs to redistribute with your app, or find the name of a missing dependency.

- [/HEADERS](https://docs.microsoft.com/en-us/cpp/build/reference/headers?view=vs-2019)

  This option displays the file header and the header for each section. When used with a library, it displays the header for each member object.

- [/IMPORTS](https://docs.microsoft.com/en-us/cpp/build/reference/imports-dumpbin?view=vs-2019)

    /IMPORTS[:file]

  This option displays the list of DLLs (both statically linked and [delay loaded](https://docs.microsoft.com/en-us/cpp/build/reference/linker-support-for-delay-loaded-dlls?view=vs-2019)) that are imported to an executable file or DLL and all the individual imports from each of these DLLs.

  The optional `file` specification allows you to specify that the imports for only that DLL will be displayed. For example:

    dumpbin /IMPORTS:msvcrt.dll

- [/PDBPATH](https://docs.microsoft.com/en-us/cpp/build/reference/pdbpath?view=vs-2019)

    /PDBPATH[:VERBOSE] filename

  - `filename`

    The name of the .dll or .exe file for which you want to find the matching .pdb file.

  - `:VERBOSE`

    (Optional) Reports all directories where an attempt was made to locate the `.pdb` file.

  `/PDBPATH` will search your computer along the same paths that the debugger would search for a `.pdb` file and will report which, if any, `.pdb` files correspond to the file specified in filename.

  When using the Visual Studio debugger, you may experience a problem due to the fact that the debugger is using a `.pdb` file for a different version of the file you are debugging.

  /PDBPATH will search for .pdb files along the following paths:

  - Check the location where the executable resides.

  - Check the location of the PDB written into the executable. This is usually the location at the time the image was linked.

  - Check along the search path configured in the Visual Studio IDE.

  - Check along the paths in the `_NT_SYMBOL_PATH` and `_NT_ALT_SYMBOL_PATH` environment variables.

  - Check in the Windows directory.

### [NMAKE](https://docs.microsoft.com/en-us/cpp/build/reference/nmake-reference?view=vs-2019)

NMAKE reads and executes makefiles.

### [ERRLOOK](https://docs.microsoft.com/en-us/cpp/build/reference/value-edit-control?view=vs-2019)

ERRLOOK, the Error Lookup utility, retrieves a system error message or module error message based on the value entered.

### [XDCMake](https://docs.microsoft.com/en-us/cpp/build/reference/xdcmake-reference?view=vs-2019`)

XDCMake. A tool for processing source code files that contain documentation comments marked up with XML tags.

### [BSCMAKE.EXE](https://docs.microsoft.com/en-us/cpp/build/reference/bscmake-reference?view=vs-2019)

BSCMAKE.EXE (provided for backward compatibility only) builds a browse information file (.bsc) that contains information about the symbols (classes, functions, data, macros, and types) in your program. You view this information in browse windows within the development environment. (A .bsc file can also be built in the development environment.)



