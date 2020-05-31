# win32 programming

- [win32 programming](#win32-programming)
  - [Do not display the Windows Error Reporting dialog](#do-not-display-the-windows-error-reporting-dialog)
  - [Debug](#debug)
    - [Debug Interface Access SDK](#debug-interface-access-sdk)
    - [PDB Files: What Every Developer Must Know](#pdb-files-what-every-developer-must-know)
    - [Sourcepack (indexing PDB files with source archive file)](#sourcepack-indexing-pdb-files-with-source-archive-file)
    - [Pdb Files: The Glue Between The Binary File And Source Code](#pdb-files-the-glue-between-the-binary-file-and-source-code)
    - [microsoft-pdb](#microsoft-pdb)
  - [Library](#library)
    - [Static library](#static-library)
      - [What is inside .lib file of Static library, Statically linked dynamic library and dynamically linked dynamic library?](#what-is-inside-lib-file-of-static-library-statically-linked-dynamic-library-and-dynamically-linked-dynamic-library)
  - [Compile Options](#compile-options)

## Do not display the Windows Error Reporting dialog

    SetErrorMode(SEM_NOGPFAULTERRORBOX)

[Error Mode](https://docs.microsoft.com/en-us/windows/win32/debug/error-mode?redirectedfrom=MSDN)

## Debug

### [Debug Interface Access SDK](https://docs.microsoft.com/en-us/visualstudio/debugger/debug-interface-access/debug-interface-access-sdk?view=vs-2019)

The Microsoft Debug Interface Access Software Development Kit (DIA SDK) provides access to debug information stored in program database (.pdb) files generated by Microsoft postcompiler tools. Because the format of the .pdb file generated by the postcompiler tools undergoes constant revision, exposing the format is impractical. Using the DIA API, you can develop applications that search for and browse debug information stored in a .pdb file. Such applications could, for example, report stack trace-back information and analyze performance data.

### [PDB Files: What Every Developer Must Know](https://www.wintellect.com/pdb-files-what-every-developer-must-know/)

### [Sourcepack (indexing PDB files with source archive file)](https://www.codeproject.com/Articles/245824/Sourcepack-indexing-PDB-files-with-source-archive)

### [Pdb Files: The Glue Between The Binary File And Source Code](https://vineelkovvuri.com/posts/pdb-files-the-glue-between-the-binary-file-and-source-code/)

### [microsoft-pdb](https://github.com/Microsoft/microsoft-pdb)

## Library

### Static library

#### [What is inside .lib file of Static library, Statically linked dynamic library and dynamically linked dynamic library?](https://stackoverflow.com/questions/3250467/what-is-inside-lib-file-of-static-library-statically-linked-dynamic-library-an)

For a static library, the `.lib` file contains all the code and data for the library. The linker then identifies the bits it needs and puts them in the final executable.

For a dynamic library, the `.lib` file contains a list of the exported functions and data elements from the library, and information about which DLL they came from. When the linker builds the final executable then if any of the functions or data elements from the library are used then the linker adds a reference to the DLL (causing it to be automatically loaded by Windows), and adds entries to the executable's import table so that a call to the function is redirected into that DLL.

You don't need a .lib file to use a dynamic library, but without one you cannot treat functions from the DLL as normal functions in your code. Instead you must manually call LoadLibrary to load the DLL (and FreeLibrary when you're done), and GetProcAddress to obtain the address of the function or data item in the DLL. You must then cast the returned address to an appropriate pointer-to-function in order to use it.

## Compile Options

- MD for dynamic-release
- MDd for dynamic-debug
- MT for static-release
- MTd for static-debug



