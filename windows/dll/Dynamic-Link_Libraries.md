# [Dynamic-Link Libraries](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-libraries)

- [Dynamic-Link Libraries](#dynamic-link-libraries)
  - [About Dynamic-Link Libraries](#about-dynamic-link-libraries)
    - [About Dynamic-Link Libraries](#about-dynamic-link-libraries-1)
      - [Types of Dynamic Linking](#types-of-dynamic-linking)
      - [DLLs and Memory Management](#dlls-and-memory-management)
    - [Advantages of Dynamic Linking](#advantages-of-dynamic-linking)
    - [Dynamic-Link Library Creation](#dynamic-link-library-creation)
    - [Dynamic-Link Library Entry-Point Function](#dynamic-link-library-entry-point-function)
    - [Load-Time Dynamic Linking](#load-time-dynamic-linking)
    - [Run-Time Dynamic Linking](#run-time-dynamic-linking)
    - [Dynamic-Link Library Search Order](#dynamic-link-library-search-order)
    - [Dynamic-Link Library Data](#dynamic-link-library-data)
    - [Dynamic-Link Library Redirection](#dynamic-link-library-redirection)
    - [Dynamic-Link Library Updates](#dynamic-link-library-updates)
    - [Dynamic-Link Library Security](#dynamic-link-library-security)
    - [AppInit DLLs and Secure Boot](#appinit-dlls-and-secure-boot)
      - [About AppInit_DLLs](#about-appinit_dlls)
      - [AppInit_DLLs and secure boot](#appinit_dlls-and-secure-boot)
      - [AppInit_DLLs certification requirement for Windows 8 desktop apps](#appinit_dlls-certification-requirement-for-windows-8-desktop-apps)
      - [Summary](#summary)
    - [Dynamic-Link Library Best Practices](#dynamic-link-library-best-practices)
  - [Using Dynamic-Link Libraries](#using-dynamic-link-libraries)
  - [Dynamic-Link Library Reference](#dynamic-link-library-reference)

A dynamic-link library (DLL) is a module that contains functions and data that can be used by another module (application or DLL).

A DLL can define two kinds of functions: exported and internal. The exported functions are intended to be called by other modules, as well as from within the DLL where they are defined. Internal functions are typically intended to be called only from within the DLL where they are defined. Although a DLL can export data, its data is generally used only by its functions. However, there is nothing to prevent another module from reading or writing that address.

DLLs provide a way to modularize applications so that their functionality can be updated and reused more easily. DLLs also help reduce memory overhead when several applications use the same functionality at the same time, because although each application receives its own copy of the DLL data, the applications share the DLL code.

The Windows application programming interface (API) is implemented as a set of DLLs, so any process that uses the Windows API uses dynamic linking.

## About Dynamic-Link Libraries

### [About Dynamic-Link Libraries](https://docs.microsoft.com/en-us/windows/win32/dlls/about-dynamic-link-libraries)

#### Types of Dynamic Linking

#### DLLs and Memory Management

### [Advantages of Dynamic Linking](https://docs.microsoft.com/en-us/windows/win32/dlls/advantages-of-dynamic-linking)

### [Dynamic-Link Library Creation](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-creation)

### [Dynamic-Link Library Entry-Point Function](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-entry-point-function)

### [Load-Time Dynamic Linking](https://docs.microsoft.com/en-us/windows/win32/dlls/load-time-dynamic-linking)

### [Run-Time Dynamic Linking](https://docs.microsoft.com/en-us/windows/win32/dlls/run-time-dynamic-linking)

### [Dynamic-Link Library Search Order](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order)

### [Dynamic-Link Library Data](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-data)

### [Dynamic-Link Library Redirection](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-redirection)

### [Dynamic-Link Library Updates](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-updates)

### [Dynamic-Link Library Security](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-security)

When an application dynamically loads a dynamic-link library without specifying a fully qualified path name, Windows attempts to locate the DLL by searching a well-defined set of directories in a particular order, as described in [Dynamic-Link Library Search Order](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order). If an attacker gains control of one of the directories on the DLL search path, it can place a malicious copy of the DLL in that directory. This is sometimes called a DLL preloading attack or a binary planting attack. If the system does not find a legitimate copy of the DLL before it searches the compromised directory, it loads the malicious DLL. If the application is running with administrator privileges, the attacker may succeed in local privilege elevation.

For example, suppose an application is designed to load a DLL from the user's current directory and fail gracefully if the DLL is not found. The application calls [LoadLibrary](https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadlibrarya) with just the name of the DLL, which causes the system to search for the DLL. Assuming safe DLL search mode is enabled and the application is not using an alternate search order, the system searches directories in the following order:

1. The directory from which the application loaded.

2. The system directory.

3. The 16-bit system directory.

4. The Windows directory.

5. The current directory.

6. The directories that are listed in the PATH environment variable.

Continuing the example, an attacker with knowledge of the application gains control of the current directory and places a malicious copy of the DLL in that directory. When the application issues the LoadLibrary call, the system searches for the DLL, finds the malicious copy of the DLL in the current directory, and loads it. The malicious copy of the DLL then runs within the application and gains the privileges of the user.

Developers can help safeguard their applications against DLL preloading attacks by following these guidelines:

...

The Process Monitor tool can be used to help identify DLL load operations that might be vulnerable. The Process Monitor tool can be downloaded from https://technet.microsoft.com/sysinternals/bb896645.aspx.

The following procedure describes how to use Process Monitor to examine DLL load operations in your application.

To use Process Monitor to examine DLL load operations in your application

1. Start Process Monitor.

2. In Process Monitor, include the following filters:

    Operation is CreateFile
    Operation is LoadImage
    Path contains .cpl
    Path contains .dll
    Path contains .drv
    Path contains .exe
    Path contains .ocx
    Path contains .scr
    Path contains .sys

3. Exclude the following filters:

    Process Name is procmon.exe
    Process Name is Procmon64.exe
    Process Name is System
    Operation begins with IRP_MJ_
    Operation begins with FASTIO_
    Result is SUCCESS
    Path ends with pagefile.sys

4. Attempt to start your application with the current directory set to a specific directory. For example, double-click a file with an extension whose file handler is assigned to your application.

5. Check Process Monitor output for paths that look suspicious, such as a call to the current directory to load a DLL. This kind of call might indicate a vulnerability in your application.

### [AppInit DLLs and Secure Boot](https://docs.microsoft.com/en-us/windows/win32/dlls/secure-boot-and-appinit-dlls)

#### About AppInit_DLLs

The AppInit_DLLs infrastructure provides an easy way to hook system APIs by allowing custom DLLs to be loaded into the address space of every interactive application. Applications and malicious software both use AppInit DLLs for the same basic reason, which is to hook APIs; after the custom DLL is loaded, it can hook a well-known system API and implement alternate functionality. Only a small set of modern legitimate applications use this mechanism to load DLLs, while a large set of malware use this mechanism to compromise systems. Even legitimate AppInit_DLLs can unintentionally cause system deadlocks and performance problems, therefore usage of AppInit_DLLs is not recommended.

#### AppInit_DLLs and secure boot

Windows 8 adopted UEFI and secure boot to improve the overall system integrity and to provide strong protection against sophisticated threats. When secure boot is enabled, the AppInit_DLLs mechanism is disabled as part of a no-compromise approach to protect customers against malware and threats.

Please note that secure boot is a UEFI protocol and not a Windows 8 feature. More info on UEFI and the secure boot protocol specification can be found at https://www.uefi.org.

#### AppInit_DLLs certification requirement for Windows 8 desktop apps

One of the certification requirements for Windows 8 desktop apps is that the app must not load arbitrary DLLs to intercept Win32 API calls using the AppInit_DLLs mechanism. For more detailed information about the certification requirements, refer to section 1.1 of [Certification requirements for Windows 8 desktop apps](https://docs.microsoft.com/en-us/windows/win32/win_cert/certification-requirements-for-windows-desktop-apps).

#### Summary

- The AppInit_DLLs mechanism is not a recommended approach for legitimate applications because it can lead to system deadlocks and performance problems.
- The AppInit_DLLs mechanism is disabled by default when secure boot is enabled.
- Using AppInit_DLLs in a Windows 8 desktop app is a Windows desktop app certification failure.

See the following whitepaper for info about AppInit_DLLs on Windows 7 and Windows Server 2008 R2: [AppInit DLLs in Windows 7 and Windows Server 2008 R2](https://docs.microsoft.com/en-us/previous-versions/windows/hardware/download/dn550976(v=vs.85)).

### [Dynamic-Link Library Best Practices](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-best-practices)

## [Using Dynamic-Link Libraries](https://docs.microsoft.com/en-us/windows/win32/dlls/using-dynamic-link-libraries)

## [Dynamic-Link Library Reference](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-reference)
