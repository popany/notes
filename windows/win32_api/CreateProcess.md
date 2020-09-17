# CreateProcess

- [CreateProcess](#createprocess)
  - [CreateProcessA function](#createprocessa-function)
    - [Syntax](#syntax)
    - [Parameters](#parameters)
    - [Return value](#return-value)
    - [Remarks](#remarks)
    - [Security Remarks](#security-remarks)
    - [Examples](#examples)
      - [Creating Processes](#creating-processes)

## [CreateProcessA function](https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createprocessa)

Creates a new process and its primary thread. The new process runs in the security context of the calling process.

### Syntax

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

### Parameters

- `lpApplicationName`

  The lpApplicationName parameter can be NULL. In that case, the module name must be the first white space–delimited token in the lpCommandLine string. If you are using a long file name that contains a space, use quoted strings to indicate where the file name ends and the arguments begin; otherwise, the file name is ambiguous.

  To run a batch file, you must start the command interpreter; set `lpApplicationName` to `cmd.exe` and set `lpCommandLine` to the following arguments: `/c` plus the name of the batch file.

- `lpCommandLine`

  The `lpCommandLine` parameter can be NULL. In that case, the function uses the string pointed to by `lpApplicationName` as the command line.

  If both `lpApplicationName` and `lpCommandLine` are non-NULL, the null-terminated string pointed to by `lpApplicationName` specifies the module to execute, and the null-terminated string pointed to by `lpCommandLine` specifies the command line. The new process can use [`GetCommandLine`](https://docs.microsoft.com/en-us/windows/desktop/api/processenv/nf-processenv-getcommandlinea) to retrieve the entire command line. Console processes written in C can use the `argc` and `argv` arguments to parse the command line. Because `argv[0]` is the module name, C programmers generally repeat the module name as the first token in the command line.

- `lpProcessAttributes`

  A pointer to a [`SECURITY_ATTRIBUTES`](https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/aa379560(v=vs.85)) structure that determines whether the returned handle to the new process object can be inherited by child processes. If `lpProcessAttributes` is `NULL`, the handle cannot be inherited.

- `lpThreadAttributes`

  A pointer to a [`SECURITY_ATTRIBUTES`](https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/aa379560(v=vs.85)) structure that determines whether the returned handle to the new thread object can be inherited by child processes. If `lpThreadAttributes` is `NULL`, the handle cannot be inherited.

- `bInheritHandles`

  If this parameter is `TRUE`, each inheritable handle in the calling process is inherited by the new process. If the parameter is `FALSE`, the handles are not inherited. Note that inherited handles have the same value and access rights as the original handles. For additional discussion of inheritable handles, see Remarks.

- `dwCreationFlags`

  The flags that control the **priority** class and the **creation** of the process. For a list of values, see [Process Creation Flags](https://docs.microsoft.com/en-us/windows/desktop/ProcThread/process-creation-flags).

  This parameter also controls the new process's priority class, which is used to determine the scheduling priorities of the process's threads. For a list of values, see [GetPriorityClass](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/nf-processthreadsapi-getpriorityclass). If none of the priority class flags is specified, the priority class defaults to `NORMAL_PRIORITY_CLASS` unless the priority class of the creating process is `IDLE_PRIORITY_CLASS` or `BELOW_NORMAL_PRIORITY_CLASS`. In this case, the child process receives the default priority class of the calling process.

- `lpEnvironment`

  A pointer to the environment block for the new process. If this parameter is `NULL`, the new process uses the environment of the calling process.

  An environment block consists of a null-terminated block of null-terminated strings. Each string is in the following form:

      name=value\0

  Because the equal sign is used as a separator, it must not be used in the name of an environment variable.

  An environment block can contain either Unicode or ANSI characters. If the environment block pointed to by `lpEnvironment` contains Unicode characters, be sure that `dwCreationFlags` includes `CREATE_UNICODE_ENVIRONMENT`. If this parameter is NULL and the environment block of the parent process contains Unicode characters, you must also ensure that `dwCreationFlags` includes `CREATE_UNICODE_ENVIRONMENT`.

  The ANSI version of this function, `CreateProcessA` fails if the total size of the environment block for the process exceeds 32,767 characters.

  Note that an ANSI environment block is terminated by two zero bytes: one for the last string, one more to terminate the block. A Unicode environment block is terminated by four zero bytes: two for the last string, two more to terminate the block.

- lpCurrentDirectory

  The full path to the current directory for the process. The string can also specify a UNC path.

  If this parameter is `NULL`, the new process will have the same current drive and directory as the calling process. (This feature is provided primarily for shells that need to start an application and specify its initial drive and working directory.)

- lpStartupInfo

  A pointer to a [`STARTUPINFO`](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/ns-processthreadsapi-startupinfoa) or [`STARTUPINFOEX`](https://docs.microsoft.com/en-us/windows/desktop/api/winbase/ns-winbase-startupinfoexa) structure.

  To set extended attributes, use a `STARTUPINFOEX` structure and specify `EXTENDED_STARTUPINFO_PRESENT` in the `dwCreationFlags` parameter.

  **Handles in** `STARTUPINFO` or `STARTUPINFOEX` must be closed with [`CloseHandle`](https://docs.microsoft.com/en-us/windows/desktop/api/handleapi/nf-handleapi-closehandle) when they are no longer needed.

- `lpProcessInformation`

  A pointer to a [`PROCESS_INFORMATION`](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/ns-processthreadsapi-process_information) structure that receives identification information about the new process.

  **Handles in** `PROCESS_INFORMATION` must be closed with ['CloseHandle'](https://docs.microsoft.com/en-us/windows/desktop/api/handleapi/nf-handleapi-closehandle) when they are no longer needed.

### Return value

If the function succeeds, the return value is nonzero.

If the function fails, the return value is zero. To get extended error information, call [`GetLastError`](https://docs.microsoft.com/en-us/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror).

Note that the function returns before the process has finished initialization. If a required DLL cannot be located or fails to initialize, the process is terminated. To get the termination status of a process, call [`GetExitCodeProcess`](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/nf-processthreadsapi-getexitcodeprocess).

### Remarks

The process is assigned a **process identifier**. The identifier is valid until the process terminates. It can be used to **identify the process**, or specified in the [`OpenProcess`](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/nf-processthreadsapi-openprocess) function to open a handle to the process. The initial thread in the process is also assigned a **thread identifier**. It can be specified in the [`OpenThread`](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/nf-processthreadsapi-openthread) function to open a handle to the thread. The identifier is valid until the thread terminates and can be used to **uniquely identify the thread within the system**. These identifiers are returned in the [`PROCESS_INFORMATION`](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/ns-processthreadsapi-process_information) structure.

The name of the executable in the command line that the operating system provides to a process is not necessarily identical to that in the command line that the calling process gives to the `CreateProcess` function. The operating system may prepend a fully qualified path to an executable name that is provided without a fully qualified path.

The calling thread can use the [`WaitForInputIdle`](https://docs.microsoft.com/en-us/windows/desktop/api/winuser/nf-winuser-waitforinputidle) function to wait until the new process has **finished its initialization** and is **waiting for user input** with no input pending. This can be useful for **synchronization between parent and child processes**, because `CreateProcess` returns without waiting for the new process to finish its initialization. For example, the creating process would use `WaitForInputIdle` before trying to find a window associated with the new process.

The preferred way to shut down a process is by using the [`ExitProcess`](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/nf-processthreadsapi-exitprocess) function, because this function sends notification of approaching termination to all DLLs attached to the process. Other means of shutting down a process do not notify the attached DLLs. Note that when a thread calls ExitProcess, other threads of the process are terminated without an opportunity to execute any additional code (including the thread termination code of attached DLLs). For more information, see [`Terminating a Process`](https://docs.microsoft.com/en-us/windows/desktop/ProcThread/terminating-a-process).

A parent process can directly alter the environment variables of a child process during process creation. This is the only situation when a process can directly change the environment settings of another process. For more information, see [Changing Environment Variables](https://docs.microsoft.com/en-us/windows/desktop/ProcThread/changing-environment-variables).

If an application provides an environment block, the current directory information of the system drives is not automatically propagated to the new process. For example, there is an environment variable named =C: whose value is the current directory on drive C. An application must manually pass the current directory information to the new process. To do so, the application must explicitly create these environment variable strings, **sort them alphabetically** (because the system uses a sorted environment), and put them into the environment block. Typically, they will go at the front of the environment block, due to the environment block sort order.

One way to obtain the current directory information for a drive X is to make the following call: `GetFullPathName("X:", ...)`. That avoids an application having to scan the environment block. If the full path returned is X:, there is no need to pass that value on as environment data, since the root directory is the default current directory for drive X of a new process.

### Security Remarks

The first parameter, `lpApplicationName`, can be `NULL`, in which case the executable name must be in the white space–delimited string pointed to by `lpCommandLine`. If the executable or path name has a space in it, there is a risk that a different executable could be run because of the way the function parses spaces. The following example is dangerous because the function will attempt to run "Program.exe", if it exists, instead of "MyApp.exe"

    LPTSTR szCmdline = _tcsdup(TEXT("C:\\Program Files\\MyApp -L -S"));
    CreateProcess(NULL, szCmdline, /* ... */);

If a malicious user were to create an application called "Program.exe" on a system, any program that incorrectly calls CreateProcess using the Program Files directory will run this application instead of the intended application.

To avoid this problem, do not pass `NULL` for `lpApplicationName`. If you do pass NULL for `lpApplicationName`, use quotation marks around the executable path in `lpCommandLine`, as shown in the example below.

    LPTSTR szCmdline[] = _tcsdup(TEXT("\"C:\\Program Files\\MyApp\" -L -S"));
    CreateProcess(NULL, szCmdline, /*...*/);

### Examples

#### [Creating Processes](https://docs.microsoft.com/en-us/windows/win32/procthread/creating-processes)
