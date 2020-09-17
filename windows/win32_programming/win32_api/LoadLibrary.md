# LoadLibrary

- [LoadLibrary](#loadlibrary)
  - [LoadLibraryA function](#loadlibrarya-function)
    - [Syntax](#syntax)

## [LoadLibraryA function](https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadlibrarya)

Loads the specified module into the address space of the calling process. The specified module may cause other modules to be loaded.

For additional load options, use the [`LoadLibraryEx`](https://docs.microsoft.com/en-us/windows/desktop/api/libloaderapi/nf-libloaderapi-loadlibraryexa) function.

### Syntax

    HMODULE LoadLibraryA(
      LPCSTR lpLibFileName
    );







