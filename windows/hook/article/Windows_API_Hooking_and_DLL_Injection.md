# [Windows API Hooking and DLL Injection](https://dzone.com/articles/windows-api-hooking-and-dll-injection)

- [Windows API Hooking and DLL Injection](#windows-api-hooking-and-dll-injection)
  - [Overview](#overview)
  - [Hooking internals](#hooking-internals)
    - [Injection](#injection)
    - [Hook Engine](#hook-engine)
  - [Sample Implementation](#sample-implementation)
    - [Hook Library](#hook-library)
    - [Injector](#injector)

This article is devoted to an approach for setting up local Windows API hooks. This article will also provide you with a DLL (dynamic link library) injection example: we will demonstrate how you can easily hook the system network adapter enumerator API call to manipulate the returned network adapter info.  

## Overview

Hooking covers a range of techniques for altering or augmenting the behavior of an operating system, application, or other software components by intercepting API function calls, messages, or events passed between software components. Code that handles such interception is called a hook.

At Plexteq, we develop complex networking and security applications for which we use low-level techniques such as hooking and injection. We would like to share our experience in this domain.

Some of the software applications that utilize hooks are tools for programming (e.g. debugging), antimalware, application security solutions, and monitoring tools.  Malicious software often uses hooks as well; for example, to hide from the list of running processes or to intercept keypress events in order to steal sensitive inputs such as passwords, credit card data, etc.

There are two main ways to modify the behavior of an executable:

- through a **source modification** approach, which involves modifying an executable binary prior to application start through reverse engineering and patching. Executable signing is utilized to defend against this, preventing code that isn’t properly signed from being loaded.

- through **runtime modification**, which is implemented by the operating system’s APIs. Microsoft Windows provides appropriate harnesses for hooking the dialogs, buttons, menus, keyboard, mouse events, and various system calls.

API hooks can be divided into the following types:

- Local hooks: these influence only specific applications.
- Global hooks: these affect all system processes.

In this article, we'll go over the hook technique for Windows that belongs to the local type done through a runtime modification using C/C++ and native APIs.

## Hooking internals

### Injection

Local hooks implemented with the runtime modification approach have to be executed within the address space of the target program. A program that manipulates a target process and makes it load hook is called an **injector**. In our example, we imply that the hook setup code is contained within an external DLL resource that is an **injection object**.

The overall flow for preparing the hook to be loaded and executed requires the injector to follow these steps:

- Obtain the target process handle.
- Allocate memory within a target process and write the external DLL path into it (here we mean writing the dynamic library path that contains the hook).
- Create a thread inside the target process that would load the library and set up the hook.

In our example, we imply the hook setup code is located in [`DllMain`](https://dzone.com/articles/windows-api-hooking-and-dll-injection) function of the external DLL so it will be automatically executed upon a successful library load.

Microsoft Windows API provides several system calls that are suitable for implementing the injector. Let’s go through the steps and figure out the best way to implement them.

---
**Note that the approach below won’t work for processes that don’t use kernel32.dll as in the samples below we heavily rely on API functions exported by it.**

---

Suppose the target process is not running yet, and we would like to inject our hook right after the target program starts. To make this happen, the injector should first run the target process by making an API call to [`CreateProcess`](https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createprocessa).

    BOOL CreateProcessA(
      LPCSTR                lpApplicationName,
      LPSTR                 lpCommandLine,
      LPSECURITY_ATTRIBUTES lpProcessAttributes,
      LPSECURITY_ATTRIBUTES lpThreadAttributes,
      BOOL                  bInheritHandles,
      DWORD                 dwCreationFlags,
      LPVOID                lpEnvironment,
      LPCSTR                lpCurrentDirectory,
      LPSTARTUPINFOA        lpStartupInfo,
      LPPROCESS_INFORMATION lpProcessInformation
    );

To make our hook set right after our target process starts, the injector has to suspend the target by passing a CREATE_SUSPENDED flag (dwCreationFlags) and then, after injecting the hook, resume the target process by calling the [`ResumeThread`](https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-resumethread) API function.

Here’s an example of how to start a process in a suspended state:

    STARTUPINFO             startupInfo;
    PROCESS_INFORMATION     processInformation;
    // starting a new process
    if (!CreateProcess(targetPath, NULL, NULL, NULL, FALSE, CREATE_SUSPENDED, NULL, NULL, &startupInfo, &processInformation))
    {
        PrintError(TEXT("CreateProcess failed"));
        return FALSE;
    }

Allocating and writing memory in the target process is performed using a combination of system calls [`VirtualAllocEx`](https://docs.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualallocex) and [`WriteProcessMemory`](https://docs.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-writeprocessmemory).

The injector should first allocate memory with VirtualAllocEx.

    LPVOID VirtualAllocEx(
      HANDLE hProcess,
      LPVOID lpAddress,
      SIZE_T dwSize,
      DWORD  flAllocationType,
      DWORD  flProtect
    );

And then write data to it with `WriteProcessMemory`.

    BOOL WriteProcessMemory(
      HANDLE  hProcess,
      LPVOID  lpBaseAddress,
      LPCVOID lpBuffer,
      SIZE_T  nSize,
      SIZE_T  *lpNumberOfBytesWritten
    );

Here’s an example of allocating and writing memory to a target process:

    // lpcwszDll is a string that contains path to a DLL hook
    nLength = wcslen(lpcwszDll) * sizeof(WCHAR);
    // allocate mem for dll name
    lpRemoteString = VirtualAllocEx(processInformation.hProcess, NULL, nLength + 1, MEM_COMMIT, PAGE_READWRITE);
    if (!lpRemoteString)
    {
        PrintError(TEXT("Failed to allocate memory in the target process"));
        // close process handle
        CloseHandle(processInformation.hProcess);
        return FALSE;
    }
    // write DLL hook name
    if (!WriteProcessMemory(processInformation.hProcess, lpRemoteString, lpcwszDll, nLength, NULL)) {
        PrintError(TEXT("Failed to write memory to the target process"));
        // free allocated memory
        VirtualFreeEx(processInformation.hProcess, lpRemoteString, 0, MEM_RELEASE);
        // close process handle
        CloseHandle(processInformation.hProcess);
        return FALSE;
    }

The next step is to create a thread inside the target process that loads the library with the hook. Microsoft Windows API provides a [`CreateRemoteThread`](https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createremotethread) API call for that purpose:

    HANDLE CreateRemoteThread(
      HANDLE                 hProcess,
      LPSECURITY_ATTRIBUTES  lpThreadAttributes,
      SIZE_T                 dwStackSize,
      LPTHREAD_START_ROUTINE lpStartAddress,
      LPVOID                 lpParameter,
      DWORD                  dwCreationFlags,
      LPDWORD                lpThreadId
    );

So `CreateRemoteThread` creates a new thread with state parameters `dwCreationFlags` in the target remote process specified by a `hProcess` handle. The newly created thread will execute a function pointed by `lpStartAddress` and pass `lpParameter` to it as a first argument.

Our plan now is to use this API function to start a thread and make it load our DLL, which we will accomplish by:

- Passing a pointer to the Windows API function [`LoadLibrary`](https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadlibrarya) as a `lpStartAddress`.
- Passing a pointer to the DLL hook (the one we initialized using `VirtualAllocEx` and `WriteProcessMemory`) as a `lpParameter`.

To find a pointer to the `LoadLibrary` function in a target process, we will use [`GetProcAddress`](https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getprocaddress).

    FARPROC GetProcAddress(
      HMODULE hModule,
      LPCSTR  lpProcName
    );

where hModule is a reference to a DLL that exports the LoadLibrary. HMODULE pointer could be obtained with the help of [`GetModuleHandle`](https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulehandlea).

    HMODULE GetModuleHandleA(
      LPCSTR lpModuleName
    );

Here’s an example of loading a DLL with the hook into the target process:

    LPVOID lpLoadLibraryW = NULL;
    lpLoadLibraryW = GetProcAddress(GetModuleHandle(L"KERNEL32.DLL"), "LoadLibraryW");
    if (!lpLoadLibraryW)
    {
        PrintError(TEXT("GetProcAddress failed"));
        // close process handle
        CloseHandle(processInformation.hProcess);
        return FALSE;
    }
    // call LoadLibraryW
    HANDLE hThread = CreateRemoteThread(processInformation.hProcess, NULL, NULL,
                                        (LPTHREAD_START_ROUTINE)lpLoadLibraryW,
                                        lpRemoteString, NULL, NULL);
    if (!hThread) {
        PrintError(TEXT("CreateRemoteThread failed"));
  
        // close process handle
        CloseHandle(processInformation.hProcess);
        return FALSE; 
    } else {
        WaitForSingleObject(hThread, 4000);
        //resume suspended process
        ResumeThread(processInformation.hThread);
    }

These are all the necessary steps for injecting the hook library. If the injection went well, the hook library is loaded in the target process, and the `DllMain` function is executed so that we can set any hooks we want.

### Hook Engine

To implement the hooking itself, we recommend using one of the many already existing solutions. There are a lot of them available as open-source, free, or partially free solutions. For example, Microsoft Detour, a powerful hooking engine, has support for the x86 architecture in a free version (it requires a paid subscription for hooking on x64). Another popular engine is [`NtHookEngine`](https://ntcore.com/files/nthookengine.htm), which supports both x86 and x64 and has a well-designed and very straightforward API. Actually, this engine exports just three simple-to-use functions:

    BOOL (__cdecl *HookFunction)(ULONG_PTR OriginalFunction, ULONG_PTR NewFunction);
    VOID (__cdecl *UnhookFunction)(ULONG_PTR Function);
    ULONG_PTR (__cdecl *GetOriginalFunction)(ULONG_PTR Hook);

- `HookFunction` - sets a hook. This one may be used to hook any function that exists in the current process's virtual address space.

- `UnhookFunction` - removes a specific hook.

- `GetOriginalFunction` - returns a pointer to the original function. This is very useful when the original function needs to be called inside a hook function.

## Sample Implementation

To demonstrate the injection and hooking in action, we’ve developed a test project that consists of an injector, hook library, and simple target. All [`sources`](https://github.com/JohnyKl/hooks_example) can be found on [`GitHub`](https://github.com/JohnyKl/hooks_example).

### Hook Library

Our library hooks the [`GetAdaptersInfo`](https://docs.microsoft.com/en-us/windows/win32/api/iphlpapi/nf-iphlpapi-getadaptersinfo) method and fakes the network adaptor name and its MAC-address values.

    void HooksManager::hookFunctions() {
 
        if (HookFunction == NULL 
            || UnhookFunction == NULL 
            || GetOriginalFunction == NULL) { 
            return;
        }
 
        hLibrary = LoadLibrary(L"Iphlpapi.dll");
        if (hLibrary == NULL) { 
            return;
        }
  
        HookFunction((ULONG_PTR)GetProcAddress(hLibrary, "GetAdaptersInfo"),
                     (ULONG_PTR)FakeGetAdaptersInfo);
    }

So eventually we hook `GetAdaptersInfo` with `FakeGetAdaptersInfo`. Inside the `FakeGetAdaptersInfo`, we use `GetOriginalFunction` to get the actual adapter info. Next, we replace the first adapter info with fake values.

    DWORD FakeGetAdaptersInfo(PIP_ADAPTER_INFO pAdapterInfo, PULONG pOutBufLen)
    {
        DWORD(*OriginalGetAdaptersInfo)(PIP_ADAPTER_INFO pAdapterInfo, PULONG pOutBufLen);
        OriginalGetAdaptersInfo = (DWORD(*)(PIP_ADAPTER_INFO pAdapterInfo, PULONG pOutBufLen)) HooksManager::GetOriginalFunction((ULONG_PTR)FakeGetAdaptersInfo);
        DWORD result = OriginalGetAdaptersInfo(pAdapterInfo, pOutBufLen);
        std::string fakeAdapterName = "{11111111-2222-3333-4444-555555555555}";
        std::string fakeAdapterDescription = "Fake Adapter 0001";
        if (pAdapterInfo != NULL)
        {
            strcpy_s(pAdapterInfo->AdapterName, sizeof(pAdapterInfo->AdapterName), fakeAdapterName.c_str());
            strcpy_s(pAdapterInfo->Description, sizeof(pAdapterInfo->Description), fakeAdapterDescription.c_str());
            for (int i = 0; i < sizeof(pAdapterInfo->Address); i++)
            {
                pAdapterInfo->Address[i] = (BYTE)i;
            }
        }
        return result;
    }

### Injector

The injector in this example can be built for either x86 or x64 architectures; however, keep in mind that an injector built for x86 won’t run in an x64 environment. 

---
**Because hooks run in the context of an application, they must match the "bitness" of the application.**

---

Our injector runs the target application by itself, and that’s why it doesn’t search for the target process ID in the active process lists.

Finally, the injector code:

    BOOL WINAPI InjectDll(__in LPCWSTR lpcwszDll, __in LPCWSTR targetPath)
    {
        SIZE_T nLength;
        LPVOID lpLoadLibraryW = NULL;
        LPVOID lpRemoteString;
        STARTUPINFO             startupInfo;
        PROCESS_INFORMATION     processInformation;
        memset(&startupInfo, 0, sizeof(startupInfo));
        startupInfo.cb = sizeof(STARTUPINFO);
        if (!CreateProcess(targetPath, NULL, NULL, NULL, FALSE,
            CREATE_SUSPENDED, NULL, NULL, &startupInfo, &processInformation))
        {
            PrintError(TEXT("Target process is failed to start"));
            return FALSE;
        }
        lpLoadLibraryW = GetProcAddress(GetModuleHandle(L"KERNEL32.DLL"), "LoadLibraryW");
        if (!lpLoadLibraryW)
        {
            PrintError(TEXT("GetProcAddress failed"));
        
            // close process handle
            CloseHandle( processInformation.hProcess);
            return FALSE;
        }
        nLength = wcslen(lpcwszDll) * sizeof(WCHAR);
        // allocate mem for dll name
        lpRemoteString = VirtualAllocEx(processInformation.hProcess, NULL, nLength + 1, MEM_COMMIT, PAGE_READWRITE);
        if (!lpRemoteString)
        {
            PrintError(TEXT("VirtualAllocEx failed"));
            // close process handle
            CloseHandle(processInformation.hProcess);
            return FALSE;
        }
        // write dll name
        if (!WriteProcessMemory(processInformation.hProcess, lpRemoteString, lpcwszDll, nLength, NULL)) {
            PrintError(TEXT("WriteProcessMemory failed"));
        
            // free allocated memory
            VirtualFreeEx(processInformation.hProcess, lpRemoteString, 0, MEM_RELEASE);
            // close process handle
            CloseHandle(processInformation.hProcess);
            return FALSE;
        }
        // call loadlibraryw
        HANDLE hThread = CreateRemoteThread(processInformation.hProcess, NULL, NULL, (LPTHREAD_START_ROUTINE)lpLoadLibraryW, lpRemoteString, NULL, NULL);
        if (!hThread) {
            PrintError(TEXT("CreateRemoteThread failed"));
        }
        else {
            WaitForSingleObject(hThread, 4000);
            //resume suspended process
            ResumeThread(processInformation.hThread);
        }
        //  free allocated memory
        VirtualFreeEx(processInformation.hProcess, lpRemoteString, 0, MEM_RELEASE);
        // close process handle
        CloseHandle(processInformation.hProcess);
        return TRUE;
    }
