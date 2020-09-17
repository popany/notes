# GetProcAddress 

- [GetProcAddress](#getprocaddress)
  - [GetProcAddress function](#getprocaddress-function)
    - [Syntax](#syntax)
    - [Parameters](#parameters)
    - [Return value](#return-value)
    - [Remarks](#remarks)
    - [Examples](#examples)
      - [Using Run-Time Dynamic Linking](#using-run-time-dynamic-linking)

## [GetProcAddress function](https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getprocaddress)

Retrieves the address of an exported function or variable from the specified dynamic-link library (DLL).

### Syntax

    FARPROC GetProcAddress(
      HMODULE hModule,
      LPCSTR  lpProcName
    );

### Parameters

- `hModule`

  A handle to the `DLL` module that contains the function or variable. The [`LoadLibrary`](https://docs.microsoft.com/en-us/windows/desktop/api/libloaderapi/nf-libloaderapi-loadlibrarya), [`LoadLibraryEx`](https://docs.microsoft.com/en-us/windows/desktop/api/libloaderapi/nf-libloaderapi-loadlibraryexa), [`LoadPackagedLibrary`](https://docs.microsoft.com/en-us/windows/desktop/api/winbase/nf-winbase-loadpackagedlibrary), or [`GetModuleHandle`](https://docs.microsoft.com/en-us/windows/desktop/api/libloaderapi/nf-libloaderapi-getmodulehandlea) function returns this handle.

The `GetProcAddress` function does not retrieve addresses from modules that were loaded using the `LOAD_LIBRARY_AS_DATAFILE` flag. For more information, see `LoadLibraryEx`.

`lpProcName`

  The function or variable name, or the function's ordinal value. If this parameter is an ordinal value, it must be in the low-order word; the high-order word must be zero.

### Return value

If the function succeeds, the return value is the address of the exported function or variable.

If the function fails, the return value is `NULL`. To get extended error information, call [`GetLastError`](https://docs.microsoft.com/en-us/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror).

### Remarks

The spelling and case of a function name pointed to by `lpProcName` must be identical to that in the EXPORTS statement of the source DLL's module-definition (.def) file. The exported names of functions may differ from the names you use when calling these functions in your code. This difference is hidden by macros used in the SDK header files. For more information, see Conventions for Function Prototypes.

The `lpProcName` parameter can identify the DLL function by specifying an ordinal value associated with the function in the EXPORTS statement. `GetProcAddress` verifies that the specified ordinal is in the range 1 through the highest ordinal value exported in the `.def` file. The function then uses the ordinal as an index to read the function's address from a function table.

If the `.def` file does not number the functions consecutively from 1 to N (where N is the number of exported functions), an error can occur where `GetProcAddress` returns an invalid, non-NULL address, even though there is no function with the specified ordinal.

### Examples

#### [Using Run-Time Dynamic Linking](https://docs.microsoft.com/en-us/windows/win32/dlls/using-run-time-dynamic-linking)
