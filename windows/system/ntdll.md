# ntdll

- [ntdll](#ntdll)
  - [NTDLL](#ntdll-1)
    - [Versions](#versions)
    - [API](#api)
      - [The Native API](#the-native-api)
      - [Loader Functions](#loader-functions)
      - [Loader Initialisation](#loader-initialisation)

## [NTDLL](https://www.geoffchappell.com/studies/windows/win32/ntdll/)

NTDLL is the user-mode face of the Windows kernel to support any number of application-level subsystems. In the Win32 subsystem, which accounts for far and away the greatest number of Windows executables in ordinary use, the lowest layer is provided by such modules as KERNEL32.DLL and ADVAPI32.DLL. Many functions that NTDLL exports are simply re-exported as KERNEL32 or ADVAPI32 functions. Put another way, some KERNEL32 and ADVAPI32 functions have no code in those DLLs but instead appear in the export directory of those DLLs only as forwards to NTDLL. For many more NTDLL functions, there is some KERNEL32 or ADVAPI32 function whose code in those DLLs just repackages the NTDLL function, e.g., to change the arguments slightly.

Strictly speaking then, NTDLL is not a Win32 component but a lower-level platform on which Win32 is built. Yet, as ever with Microsoft, the practice and theory are not wholly in sync. Rather many Win32 executables that Microsoft supplies with Windows cut past KERNEL32 and ADVAPI32 and import directly from NTDLL. These are admittedly very low-level executables but not all of them are integral to the Win32 subsystem. Many are of a general type, namely services, that Microsoft plainly does intend can be written by non-Microsoft programmers. It is not obviously satisfactory that when Microsoft’s programmers write such programs, they use NTDLL functions that are not documented for use by non-Microsoft programmers when writing similar programs.

For these notes, I have chosen to follow the practice rather than what looks to be the theoretical architecture, and I count NTDLL in the Win32 subsystem. Note, however, that where I document any functions of the [Native API](https://www.geoffchappell.com/studies/windows/win32/ntdll/api/native.htm), i.e., those functions whose names begin with **Nt** or **Zw**, I do so in the [Kernel](https://www.geoffchappell.com/studies/windows/km/index.htm) section even if the function is exported only from NTDLL.

### [Versions](https://geoffchappell.com/studies/windows/win32/ntdll/history/index.htm?tx=22)

### [API](https://geoffchappell.com/studies/windows/win32/ntdll/api/index.htm?tx=22)

#### [The Native API](https://geoffchappell.com/studies/windows/win32/ntdll/api/native.htm?tx=22)

#### [Loader Functions](https://geoffchappell.com/studies/windows/win32/ntdll/api/ldrapi/index.htm?tx=22;21)

As usual for NTDLL functions, none of the following are documented. For some, though nowhere near all, KERNEL32 exports a function that is essentially the NTDLL function but re-dressed in some way such as taking arguments in a different form. Such KERNEL32 functions are, of course, to be preferred in practice.

    LdrAddRefDll
    LdrEnumerateLoadedModules
    LdrGetDllHandle
    LdrGetDllHandleEx
    LdrGetFailureData
    LdrGetProcedureAddress
    LdrGetProcedureAddressEx
    LdrLoadDll
    LdrLockLoaderLock
    LdrQueryModuleServiceTags
    LdrQueryProcessModuleInformation
    LdrRegisterDllNotification
    LdrSetAppCompatDllRedirectionCallback
    LdrSetDllManifestProber
    LdrUnloadDll
    LdrUnlockLoaderLock
    LdrUnregisterDllNotification
    LdrVerifyImageMatchesChecksum
    LdrVerifyImageMatchesChecksumEx
    RtlGetUnloadEventTrace
    RtlGetUnloadEventTraceEx
    RtlIsThreadWithinLoaderCallout

#### [Loader Initialisation](https://geoffchappell.com/studies/windows/win32/ntdll/api/ldrinit/index.htm?tx=20,22;21)

As well as being the kernel’s public face in user mode, NTDLL does much that might on its own be regarded as system work. In particular, it does much of the work of preparing user-mode executables for execution and eventually of tearing them down. Much of this is internal, even deeply so, but a handful of functions that are involved in the loader’s initialisation and ending of executable images are exported.

    LdrInitShimEngineDynamic
    LdrQueryImageFileExecutionOptions
    LdrShutdownProcess
    LdrShutdownThread
    RtlGetNtVersionNumbers
    RtlSetUnhandledExceptionFilter
