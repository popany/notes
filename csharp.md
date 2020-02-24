# C\#

## basic

[Lambda Expression and Delegates Tutorial With Easy Example C#](https://www.completecsharptutorial.com/linqtutorial/lambda-expression-delegates-tutorial-easy-example-csharp.php)

[ForEach to Trim string values in string array](https://stackoverflow.com/questions/14894503/foreach-to-trim-string-values-in-string-array)

## Database

### DbProviderFactory

## [Dynamic Programming in the .NET Framework](https://docs.microsoft.com/en-us/dotnet/framework/reflection-and-codedom/)

### [Reflection in .NET](https://docs.microsoft.com/en-us/dotnet/framework/reflection-and-codedom/reflection)

### [Emitting Dynamic Methods and Assemblies](https://docs.microsoft.com/en-us/dotnet/framework/reflection-and-codedom/emitting-dynamic-methods-and-assemblies)

## others

[Modifying Existing .NET Assemblies](https://stackoverflow.com/questions/123540/modifying-existing-net-assemblies)

[How C# Reflection Works With Code Examples](https://stackify.com/what-is-c-reflection/)

## Debug

[Using WinDbg to Analyze .NET Crash Dumps – Async Crash](https://stackify.com/using-windbg-to-analyze-net-crash-dumps-async-crash/)

[Must use, must know WinDbg commands, my most used](https://docs.microsoft.com/en-us/archive/blogs/benjaminperkins/must-use-must-know-windbg-commands-my-most-used)

[Download Debugging Tools for Windows](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/debugger-download-tools)

[How to debug .NET Deadlocks (C# Deadlocks in Depth – Part 3)](https://michaelscodingspot.com/how-to-debug-net-deadlocks-c-deadlocks-in-depth-part-3/)

> There are [several ways](https://michaelscodingspot.com/how-to-create-use-and-debug-net-application-crash-dumps-in-2019/#How-to-Create-Capture-a-Dump) to create a Dump. I used [Windows Systinternals ProcDump](https://docs.microsoft.com/en-us/sysinternals/downloads/procdump) command line tool with the command  `procdump.exe -ma [Process ID]` . This will create a full memory Dump (.dmp file), which is required to debug a .NET application.
>
> Load your Dump in WinDbg
>
> 1. Look for WinDbg.exe on your PC. It might be in those folders:
> `C:\Program Files (x86)\Windows Kits\10\Debuggers\x64`  
> `C:\Program Files (x86)\Windows Kits\10\Debuggers\x86`
> 2. Open the relevant `WinDbg.exe` that matches your program platform
> 3. In WinDbg, open your saved Dump (`Ctrl + D`)
> 4. Enable verbose symbol logging with  
> `!sym noisy`
> 5. Set Symbol search paths with  
>  `.sympath srv*https://msdl.microsoft.com/download/symbols`  
> `.sympath+ cache*C:\debug\symbols`  
> `.sympath+ C:\MyApp\bin\Debug`
> 6. Force reload Symbols  
> `.reload`  
> `ld*`  
> 7. Load the SOS extension  
> `.loadby sos clr`  
> 8. Load the SOSEX extension  
> `.load sosex`
>
> The first time you do this, MS symbols will load to your cache folder, which can take a while (15 minutes maybe).

[Debug multithreaded applications in Visual Studio](https://docs.microsoft.com/en-us/visualstudio/debugger/debug-multithreaded-applications-in-visual-studio?view=vs-2019)

[How to capture and debug .NET application crash dumps in Windows](https://keithbabinec.com/2018/06/12/how-to-capture-and-debug-net-application-crash-dumps-in-windows/)

> The program we will use to analyze this dump file is WinDbg. Its a free tool that comes packaged with the **Windows Driver Kit (WDK)** or the **Windows Software Development Kit (SDK)**. If you dont already have it installed and you just need `WinDbg`, you can [download one of those installers](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/) and uncheck all features except “debugging tools for windows”.
>
> For example, after I installed it from the Windows 10 SDK, the debug tools, including WinDBG, were under these directories:  
> `C:\Program Files (x86)\Windows Kits\10\Debuggers\x64`
> `C:\Program Files (x86)\Windows Kits\10\Debuggers\x86`

[Common WinDbg Commands (Thematically Grouped)](http://www.windbg.info/doc/1-common-cmds.html)

[Getting Started with Windows Debugging](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/getting-started-with-windows-debugging)

[Symbols for Windows debugging (WinDbg, KD, CDB, NTSD)](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/symbols)

[WinDbg cheat sheet](https://theartofdev.com/windbg-cheat-sheet/)

### WinDbg command

`~`  
all threads

`~<thread id>s`  
Set active thread

`!threads [-live] [-special]`  
all managed threads
