# `C#`

- [`C#`](#c)
  - [Syntax](#syntax)
    - [IDisposable.Dispose Method](#idisposabledispose-method)
      - [Example shows how you can implement the Dispose method](#example-shows-how-you-can-implement-the-dispose-method)
    - [GC Class](#gc-class)
  - [Component Extensions for .NET and UWP](#component-extensions-for-net-and-uwp)
    - [Two runtimes, one set of extensions](#two-runtimes-one-set-of-extensions)
    - [Data Type Keywords](#data-type-keywords)
    - [ref new, gcnew (C++/CLI and C++/CX)](#ref-new-gcnew-ccli-and-ccx)
      - [All Runtimes](#all-runtimes)
      - [Windows Runtime](#windows-runtime)
      - [Common Language Runtime](#common-language-runtime)
    - [Ref classes and structs (C++/CX)](#ref-classes-and-structs-ccx)
      - [Memory management](#memory-management)
      - [Destructors](#destructors)
  - [Database](#database)
    - [DbProviderFactory](#dbproviderfactory)
  - [Dynamic Programming in the .NET Framework](#dynamic-programming-in-the-net-framework)
    - [Reflection in .NET](#reflection-in-net)
      - [Viewing Type Information](#viewing-type-information)
    - [Emitting Dynamic Methods and Assemblies](#emitting-dynamic-methods-and-assemblies)
    - [Dynamically Create a Class at Runtime](#dynamically-create-a-class-at-runtime)
  - [others](#others)
  - [Debug](#debug)
    - [WinDbg command](#windbg-command)
    - [tools](#tools)
      - [Sysinternals Process Utilities](#sysinternals-process-utilities)
      - [AsmSpy](#asmspy)
    - [Lib](#lib)
  - [Performace](#performace)
    - [GC](#gc)
  - [Parallel Programming](#parallel-programming)
  - [.Net Framework](#net-framework)
    - [.NET Framework Tools](#net-framework-tools)

## Syntax

[Lambda Expression and Delegates Tutorial With Easy Example C#](https://www.completecsharptutorial.com/linqtutorial/lambda-expression-delegates-tutorial-easy-example-csharp.php)

[ForEach to Trim string values in string array](https://stackoverflow.com/questions/14894503/foreach-to-trim-string-values-in-string-array)

### [IDisposable.Dispose Method](https://docs.microsoft.com/en-us/dotnet/api/system.idisposable.dispose?view=netframework-4.8)

Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.

#### Example shows how you can implement the Dispose method

    using System;
    using System.ComponentModel;

    // The following example demonstrates how to create
    // a resource class that implements the IDisposable interface
    // and the IDisposable.Dispose method.

    public class DisposeExample
    {
        // A base class that implements IDisposable.
        // By implementing IDisposable, you are announcing that
        // instances of this type allocate scarce resources.
        public class MyResource: IDisposable
        {
            // Pointer to an external unmanaged resource.
            private IntPtr handle;
            // Other managed resource this class uses.
            private Component component = new Component();
            // Track whether Dispose has been called.
            private bool disposed = false;

            // The class constructor.
            public MyResource(IntPtr handle)
            {
                this.handle = handle;
            }

            // Implement IDisposable.
            // Do not make this method virtual.
            // A derived class should not be able to override this method.
            public void Dispose()
            {
                Dispose(true);
                // This object will be cleaned up by the Dispose method.
                // Therefore, you should call GC.SupressFinalize to
                // take this object off the finalization queue
                // and prevent finalization code for this object
                // from executing a second time.
                GC.SuppressFinalize(this);
            }

            // Dispose(bool disposing) executes in two distinct scenarios.
            // If disposing equals true, the method has been called directly
            // or indirectly by a user's code. Managed and unmanaged resources
            // can be disposed.
            // If disposing equals false, the method has been called by the
            // runtime from inside the finalizer and you should not reference
            // other objects. Only unmanaged resources can be disposed.
            protected virtual void Dispose(bool disposing)
            {
                // Check to see if Dispose has already been called.
                if(!this.disposed)
                {
                    // If disposing equals true, dispose all managed
                    // and unmanaged resources.
                    if(disposing)
                    {
                        // Dispose managed resources.
                        component.Dispose();
                    }

                    // Call the appropriate methods to clean up
                    // unmanaged resources here.
                    // If disposing is false,
                    // only the following code is executed.
                    CloseHandle(handle);
                    handle = IntPtr.Zero;

                    // Note disposing has been done.
                    disposed = true;
                }
            }

            // Use interop to call the method necessary
            // to clean up the unmanaged resource.
            [System.Runtime.InteropServices.DllImport("Kernel32")]
            private extern static Boolean CloseHandle(IntPtr handle);

            // Use C# destructor syntax for finalization code.
            // This destructor will run only if the Dispose method
            // does not get called.
            // It gives your base class the opportunity to finalize.
            // Do not provide destructors in types derived from this class.
            ~MyResource()
            {
                // Do not re-create Dispose clean-up code here.
                // Calling Dispose(false) is optimal in terms of
                // readability and maintainability.
                Dispose(false);
            }
        }
        public static void Main()
        {
            // Insert code here to create
            // and use the MyResource object.
        }
    }

### [GC Class](https://docs.microsoft.com/en-us/dotnet/api/system.gc?view=netframework-4.8)

## [Component Extensions for .NET and UWP](https://docs.microsoft.com/en-us/cpp/extensions/component-extensions-for-runtime-platforms?view=vs-2019)

The C++ standard allows compiler vendors to provide **non-standard extensions** to the language. Microsoft provides extensions to help you connect native C++ code to code that runs on the .NET Framework or the Universal Windows Platform (UWP). The **.NET extensions are called C++/CLI** and produce code that executes in the .NET managed execution environment that is called the Common Language Runtime (CLR). The **UWP extensions are called C++/CX** and they produce native machine code.

### Two runtimes, one set of extensions

C++/CLI extends the ISO/ANSI C++ standard, and is defined under the Ecma C++/CLI Standard. For more information, see [.NET Programming with C++/CLI (Visual C++)](https://docs.microsoft.com/en-us/cpp/dotnet/dotnet-programming-with-cpp-cli-visual-cpp?view=vs-2019).

The C++/CX extensions are a subset of C++/CLI. Although the extension syntax is identical in most cases, the code that is generated depends on whether you specify the `/ZW` compiler option to target UWP, or the `/clr` option to target .NET. These switches are set automatically when you use Visual Studio to create a project.

### Data Type Keywords

The language extensions include **aggregate keywords**, which consist of two tokens separated by white space. The tokens might have one meaning when they are used separately, and another meaning when they are used together. For example, the word "ref" is an ordinary identifier, and the word "class" is a keyword that declares a native class. But when these words are combined to form ref class, the resulting aggregate keyword declares an entity that is known as a runtime class.

The extensions also include **context-sensitive keywords**. A keyword is treated as context-sensitive depending on the kind of statement that contains it, and its placement in that statement. For example, the token "property" can be an identifier, or it can declare a special kind of public class member.

### [ref new, gcnew (C++/CLI and C++/CX)](https://docs.microsoft.com/en-us/cpp/extensions/ref-new-gcnew-cpp-component-extensions?view=vs-2019)

The ref new aggregate keyword allocates an instance of a type that is garbage collected when the object becomes inaccessible, and that returns a handle ([^](https://docs.microsoft.com/en-us/cpp/extensions/handle-to-object-operator-hat-cpp-component-extensions?view=vs-2019)) to the allocated object.

#### All Runtimes

Memory for an instance of a type that is allocated by **`ref new`** is deallocated automatically.

A **`ref new`** operation throws `OutOfMemoryException` if it is unable to allocate memory.

#### Windows Runtime

Use **`ref new`** to allocate memory for Windows Runtime objects whose lifetime you want to administer automatically. The object is automatically deallocated when its reference count goes to zero, which occurs after the last copy of the reference has gone out of scope.

Compiler option: `/ZW`

#### Common Language Runtime

Memory for a managed type (reference or value type) is allocated by **`gcnew`**, and deallocated by using **garbage collection**.

Compiler option: `/clr`

### [Ref classes and structs (C++/CX)](https://docs.microsoft.com/en-us/cpp/cppcx/ref-classes-and-structs-c-cx?view=vs-2019)

The C++/CX supports user-defined **ref classes** and **ref structs**, and user-defined **value classes** and **value structs**. These data structures are the primary containers by which C++/CX supports the Windows Runtime type system. Their contents are emitted to metadata according to certain specific rules, and this enables them to be passed between Windows Runtime components and Universal Windows Platform apps that are written in C++ or other languages.

A ref class or ref struct has these essential features:

- It must be declared within a namespace, at namespace scope, and in that namespace it may have public or private accessibility. **Only public types are emitted to metadata**. Nested public class definitions are not permitted, including nested public [enum](https://docs.microsoft.com/en-us/cpp/cppcx/enums-c-cx?view=vs-2019) classes. For more information, see [Namespaces and Type Visibility](https://docs.microsoft.com/en-us/cpp/cppcx/namespaces-and-type-visibility-c-cx?view=vs-2019).

- It may contain as members `C++/CX` including ref classes, value classes, ref structs, value structs, or nullable value structs. It may also contain scalar types such as `float64`, `bool`, and so on. It may also contain standard C++ types such as `std::vector` or a custom class, as long as they are not public. C++/CX constructs may have `public`, `protected`, `internal`, `private`, or `protected private` accessibility. **All `public` or `protected` members are emitted to metadata**. Standard `C++` types must have `private`, `internal`, or `protected private` accessibility, which prevents them from being emitted to metadata.

- It may implement one or more interface classes or interface structs.

- It may inherit from one base class, and base classes themselves have additional restrictions. Inheritance in public ref class hierarchies has more restrictions than inheritance in private ref classes.

- It may not be declared as generic. If it has private accessibility, it may be a template.

- Its lifetime is managed by **automatic reference counting**.

#### Memory management

You allocate a ref class in dynamic memory by using the `ref new` keyword.

    MyRefClass^ myClass = ref new MyRefClass();

The handle-to-object operator ^ is known as a "hat" and is fundamentally a C++ smart pointer. The memory it points to is **automatically destroyed** when the last hat goes out of scope or is explicitly set to `nullptr`.

By definition, a ref class has reference semantics. When you assign a ref class variable, it's the handle that's copied, not the object itself. In the next example, after assignment, both `myClass` and `myClass2` point to the same memory location.

    MyRefClass^ myClass = ref new MyRefClass();
    MyRefClass^ myClass2 = myClass;

When a C++/CX ref class is instantiated, its memory is **zero-initialized** before its constructor is called; therefore it is not necessary to zero-initialize individual members, including properties. If the C++/CX class derives from a Windows Runtime C++ Library (WRL) class, only the C++/CX derived class portion is zero-initialized.

#### Destructors

In C++/CX, calling delete on a public destructor invokes the destructor regardless of the object's reference count. This behavior enables you to define a destructor that **performs custom cleanup of non-RAII resources** in a deterministic manner. However, even in this case, the object itself is not deleted from memory. The memory for the object is only freed when the reference count reaches zero.

If a class's destructor is not public, then it is only invoked when the reference count reaches zero. If you call delete on an object that has a private destructor, the compiler raises warning C4493, which says "delete expression has no effect as the destructor of \<type name\> does not have 'public' accessibility."

When you declare a public destructor, the compiler generates the code so that the ref class implements `Platform::IDisposable` and the destructor implements the `Dispose` method. `Platform::IDisposable` is the C++/CX projection of `Windows::Foundation::IClosable`. Never explicitly implement these interfaces.

## Database

### DbProviderFactory

## [Dynamic Programming in the .NET Framework](https://docs.microsoft.com/en-us/dotnet/framework/reflection-and-codedom/)

### [Reflection in .NET](https://docs.microsoft.com/en-us/dotnet/framework/reflection-and-codedom/reflection)

#### [Viewing Type Information](https://docs.microsoft.com/en-us/dotnet/framework/reflection-and-codedom/viewing-type-information)

### [Emitting Dynamic Methods and Assemblies](https://docs.microsoft.com/en-us/dotnet/framework/reflection-and-codedom/emitting-dynamic-methods-and-assemblies)

### [Dynamically Create a Class at Runtime](https://www.c-sharpcorner.com/UploadFile/87b416/dynamically-create-a-class-at-runtime/)

## others

[Modifying Existing .NET Assemblies](https://stackoverflow.com/questions/123540/modifying-existing-net-assemblies)

[How C# Reflection Works With Code Examples](https://stackify.com/what-is-c-reflection/)

[What is gcnew?](https://stackoverflow.com/questions/202459/what-is-gcnew)

[Understanding gcroot](https://stackoverflow.com/questions/4281834/understanding-gcroot)

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

### tools

#### [Sysinternals Process Utilities](https://docs.microsoft.com/en-us/sysinternals/downloads/process-utilities)

#### [AsmSpy](https://github.com/mikehadlow/AsmSpy)

### Lib

[microsoft/clrmd](https://github.com/microsoft/clrmd)

## Performace

### GC

[What is the meaning of “% Time in GC” performance counter](https://stackoverflow.com/questions/31570183/what-is-the-meaning-of-time-in-gc-performance-counter)

[Reasons for seeing high “% Time in GC” in Perf Mon](https://stackoverflow.com/questions/1132033/reasons-for-seeing-high-time-in-gc-in-perf-mon)

[GC Performance Counters](https://devblogs.microsoft.com/dotnet/gc-performance-counters/)

[Improving Managed Code Performance](https://docs.microsoft.com/en-us/previous-versions/msp-n-p/ff647790(v=pandp.10)?redirectedfrom=MSDN#scalenetchapt05_topic10)

## Parallel Programming

[Get list of threads](https://stackoverflow.com/questions/10315862/get-list-of-threads)

## .Net Framework

### [.NET Framework Tools](https://docs.microsoft.com/en-us/dotnet/framework/tools/)
