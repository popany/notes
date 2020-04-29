# Visual Studio

- [Visual Studio](#visual-studio)
  - [DLL](#dll)
    - [Create C/C++ DLLs in Visual Studio](#create-cc-dlls-in-visual-studio)
      - [Differences between dynamic linking and static linking](#differences-between-dynamic-linking-and-static-linking)
      - [Differences between applications and DLLs](#differences-between-applications-and-dlls)
      - [Advantages of using DLLs](#advantages-of-using-dlls)
    - [Walkthrough: Create and use your own Dynamic Link Library (C++)](#walkthrough-create-and-use-your-own-dynamic-link-library-c)
  - [Install Build Tools into a container](#install-build-tools-into-a-container)
  - [C/C++ projects and build systems in Visual Studio](#cc-projects-and-build-systems-in-visual-studio)
    - [MSBuild on the command line - C++](#msbuild-on-the-command-line---c)
      - [How to: Modify the Target Framework and Platform Toolset](#how-to-modify-the-target-framework-and-platform-toolset)
        - [Platform toolset](#platform-toolset)
  - [MSBuild](#msbuild)
    - [MSBuild Overview](#msbuild-overview)
      - [Use MSBuild at a command prompt](#use-msbuild-at-a-command-prompt)
      - [Project file](#project-file)
        - [Properties](#properties)
        - [Items](#items)
        - [Tasks](#tasks)
        - [Targets](#targets)
      - [Build logs](#build-logs)
      - [Use MSBuild in Visual Studio](#use-msbuild-in-visual-studio)
      - [Multitargeting](#multitargeting)
    - [Walkthrough: Use MSBuild](#walkthrough-use-msbuild)
      - [Create an MSBuild project](#create-an-msbuild-project)
        - [To create a project file](#to-create-a-project-file)
      - [Examine the project file](#examine-the-project-file)
        - [To examine the project file](#to-examine-the-project-file)
      - [Targets and tasks](#targets-and-tasks)
      - [Add a target and a task](#add-a-target-and-a-task)
        - [To add a target and a task](#to-add-a-target-and-a-task)
      - [Build the target](#build-the-target)
        - [To build the target](#to-build-the-target)
      - [Build properties](#build-properties)
      - [Examine a property value](#examine-a-property-value)
        - [To examine a property value](#to-examine-a-property-value)
        - [Conditional properties](#conditional-properties)
        - [Reserved properties](#reserved-properties)
        - [Environment variables](#environment-variables)
      - [Set properties from the command line](#set-properties-from-the-command-line)
        - [To set a property value from the command line](#to-set-a-property-value-from-the-command-line)
      - [Special characters](#special-characters)
        - [To use special characters in the Message task](#to-use-special-characters-in-the-message-task)
      - [Build items](#build-items)
      - [Examine item type values](#examine-item-type-values)
        - [To examine item type values](#to-examine-item-type-values)
        - [To display item type values one per line](#to-display-item-type-values-one-per-line)
        - [Include, Exclude, and wildcards](#include-exclude-and-wildcards)
          - [To include and exclude items](#to-include-and-exclude-items)
      - [Item metadata](#item-metadata)
        - [To examine item metadata](#to-examine-item-metadata)
        - [Well-known metadata](#well-known-metadata)
          - [To examine well-known metadata](#to-examine-well-known-metadata)
        - [Metadata transformations](#metadata-transformations)
          - [To transform items using metadata](#to-transform-items-using-metadata)
    - [MSBuild concepts](#msbuild-concepts)
      - [Targets](#targets-1)
        - [Target build order](#target-build-order)
          - [Initial targets](#initial-targets)
          - [Default targets](#default-targets)
          - [First target](#first-target)
          - [Target dependencies](#target-dependencies)
          - [BeforeTargets and AfterTargets](#beforetargets-and-aftertargets)
          - [Determine the target build order](#determine-the-target-build-order)
        - [Build specific targets in solutions by using MSBuild.exe](#build-specific-targets-in-solutions-by-using-msbuildexe)
          - [To build a specific target of a specific project in a solution](#to-build-a-specific-target-of-a-specific-project-in-a-solution)
        - [Build Incrementally](#build-incrementally)
    - [MSBuild reference](#msbuild-reference)
      - [MSBuild command-line reference](#msbuild-command-line-reference)
    - [Practice](#practice)
      - [Build a solution](#build-a-solution)
      - [Build a specific project](#build-a-specific-project)
      - [Specifying the Configuration for MSBuild](#specifying-the-configuration-for-msbuild)
      - [Specifying the Platform for MSBuild](#specifying-the-platform-for-msbuild)
      - [Rebuilding project](#rebuilding-project)
      - [Cleaning Solution/Project](#cleaning-solutionproject)
      - [Write Log to `msbuild.log`](#write-log-to-msbuildlog)
  - [Inside the Visual Studio SDK](#inside-the-visual-studio-sdk)
    - [Projects](#projects)
      - [Project Types](#project-types)
        - [Managing Configuration Options](#managing-configuration-options)
          - [Configuration options overview](#configuration-options-overview)
          - [Solution Configuration](#solution-configuration)
          - [Project Configuration for Building](#project-configuration-for-building)
    - [Solutions](#solutions)
      - [Solutions overview](#solutions-overview)
      - [Solution (.sln) file](#solution-sln-file)
  - [Additional MSVC Build Tools](#additional-msvc-build-tools)
    - [LIB.EXE](#libexe)
    - [EDITBIN.EXE](#editbinexe)
    - [DUMPBIN.EXE](#dumpbinexe)
    - [DUMPBIN options](#dumpbin-options)
    - [NMAKE](#nmake)
    - [ERRLOOK](#errlook)
    - [XDCMake](#xdcmake)
    - [BSCMAKE.EXE](#bscmakeexe)
  - [Other Practice](#other-practice)
    - [Set Platform toolset version for msbuild](#set-platform-toolset-version-for-msbuild)

## DLL

### [Create C/C++ DLLs in Visual Studio](https://docs.microsoft.com/en-us/cpp/build/dlls-in-visual-cpp?view=vs-2019)

In Windows, a dynamic-link library (DLL) is a **kind of executable file** that acts as a **shared library** of functions and resources. Dynamic linking is an operating system capability. It enables an executable to call functions or use resources stored in a separate file. These functions and resources can be compiled and deployed separately from the executables that use them.

A DLL isn't a stand-alone executable. DLLs run in the context of the applications that call them. The operating system loads the DLL into an application's memory space. It's done either when the application is loaded (**implicit linking**), or on demand at runtime (**explicit linking**). DLLs also make it easy to share functions and resources across executables. Multiple applications can access the contents of a single copy of a DLL in memory at the same time.

#### Differences between dynamic linking and static linking

Static linking copies all the object code in a static library into the executables that use it when they're built. Dynamic linking includes only the information needed by Windows at run time to locate and load the DLL that contains a data item or function. When you create a DLL, you also create an **import library** that contains this information. When you build an executable that calls the DLL, the **linker uses the exported symbols in the import library** to store this information for the Windows loader. When the loader loads a DLL, the DLL is mapped into the memory space of your application. **If present**, a special function in the DLL, **`DllMain`**, is called to do any initialization the DLL requires.

#### Differences between applications and DLLs

Even though DLLs and applications are both executable modules, they differ in several ways. The most obvious difference is that **you can't run a DLL**. From the system's point of view, there are two fundamental differences between applications and DLLs:

- An application can have multiple instances of itself running in the system simultaneously. A **DLL can have only one instance**.

- An application can be loaded as a process. It can own things such as a stack, threads of execution, global memory, file handles, and a message queue. A **DLL can't own these things**.

#### Advantages of using DLLs

Dynamic linking to code and resources offers several advantages over static linking:

- Dynamic linking **saves memory and reduces swapping**. Many processes can use a DLL simultaneously, sharing a single copy of the read-only parts of a DLL in memory. In contrast, every application that is built by using a statically linked library has a complete copy of the library code that Windows must load into memory.

- Dynamic linking **saves disk space and bandwidth**. Many applications can share a single copy of the DLL on disk. In contrast, each application built by using a static link library has the library code linked into its executable image. That uses more disk space, and takes more bandwidth to transfer.

- **Maintenance, security fixes, and upgrades can be easier**. When your applications use common functions in a DLL, you can implement bug fixes and deploy updates to the DLL. When DLLs are updated, the applications that use them don't need to be recompiled or relinked. They can make use of the new DLL as soon as it's deployed. In contrast, when you make fixes in statically linked object code, you must relink and redeploy every application that uses it.

- You can use DLLs to **provide after-market support**. For example, a display driver DLL can be modified to support a display that wasn't available when the application was shipped.

- You can use **explicit linking** to discover and load DLLs at runtime. For example, application extensions that add new functionality to your app without rebuilding or redeploying it.

- Dynamic linking makes it easier to support applications written in **different programming languages**. Programs written in different programming languages can call the same DLL function as long as the programs follow the function's **calling convention**. The programs and the DLL function must be compatible in the following ways: The order in which the function expects its arguments to be pushed onto the stack. Whether the function or the application is responsible for cleaning up the stack. And, whether any arguments are passed in registers.

- Dynamic linking provides a mechanism to extend the **Microsoft Foundation Class library (MFC)** classes. You can derive classes from the existing MFC classes and place them in an MFC extension DLL for use by MFC applications.

- Dynamic linking makes creation of international versions of your application easier. DLLs are a convenient way to supply locale-specific resources, which make it much easier to create international versions of an application. Instead of shipping many localized versions of your application, you can place the strings and images for each language in a separate resource DLL. Then your application can load the appropriate resources for that locale at runtime.

A potential disadvantage to using DLLs is that the application **isn't self-contained**. It depends on the existence of a separate DLL module: one that you must **deploy or verify yourself as part of your installation**.

### [Walkthrough: Create and use your own Dynamic Link Library (C++)](https://docs.microsoft.com/en-us/cpp/build/walkthrough-creating-and-using-a-dynamic-link-library-cpp?view=vs-2019)

    // MathLibrary.h - Contains declarations of math functions
    #pragma once

    #ifdef MATHLIBRARY_EXPORTS
    #define MATHLIBRARY_API __declspec(dllexport)
    #else
    #define MATHLIBRARY_API __declspec(dllimport)
    #endif

    // The Fibonacci recurrence relation describes a sequence F
    // where F(n) is { n = 0, a
    //               { n = 1, b
    //               { n > 1, F(n-2) + F(n-1)
    // for some initial integral values a and b.
    // If the sequence is initialized F(0) = 1, F(1) = 1,
    // then this relation produces the well-known Fibonacci
    // sequence: 1, 1, 2, 3, 5, 8, 13, 21, 34, ...

    // Initialize a Fibonacci relation sequence
    // such that F(0) = a, F(1) = b.
    // This function must be called before any other function.
    extern "C" MATHLIBRARY_API void fibonacci_init(
        const unsigned long long a, const unsigned long long b);

    // Produce the next value in the sequence.
    // Returns true on success and updates current value and index;
    // false on overflow, leaves current value and index unchanged.
    extern "C" MATHLIBRARY_API bool fibonacci_next();

    // Get the current value in the sequence.
    extern "C" MATHLIBRARY_API unsigned long long fibonacci_current();

    // Get the position of the current value in the sequence.
    extern "C" MATHLIBRARY_API unsigned fibonacci_index();

This header file declares some functions to produce a generalized Fibonacci sequence, given two initial values. A call to `fibonacci_init(1, 1)` generates the familiar Fibonacci number sequence.

Notice the preprocessor statements at the top of the file. The new project template for a DLL project adds `PROJECTNAME_EXPORTS` to the defined preprocessor macros. In this example, Visual Studio defines `MATHLIBRARY_EXPORTS` when your MathLibrary DLL project is built.

When the `MATHLIBRARY_EXPORTS` macro is defined, the `MATHLIBRARY_API` macro sets the `__declspec(dllexport)` modifier on the function declarations. This modifier tells the compiler and linker to **export a function or variable** from the DLL for use by other applications. When `MATHLIBRARY_EXPORTS` is undefined, for example, when the header file is included by a client application, `MATHLIBRARY_API` applies the `__declspec(dllimport)` modifier to the declarations. This modifier **optimizes the import of the function or variable** in an application. For more information, see [dllexport](https://docs.microsoft.com/en-us/cpp/cpp/dllexport-dllimport?view=vs-2019), [dllimport](https://docs.microsoft.com/en-us/cpp/cpp/dllexport-dllimport?view=vs-2019).

## [Install Build Tools into a container](https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2019)

## [C/C++ projects and build systems in Visual Studio](https://docs.microsoft.com/en-us/cpp/build/projects-and-build-systems-cpp?view=vs-2019)

### [MSBuild on the command line - C++](https://docs.microsoft.com/en-us/cpp/build/msbuild-visual-cpp?view=vs-2019)

#### [How to: Modify the Target Framework and Platform Toolset](https://docs.microsoft.com/en-us/cpp/build/how-to-modify-the-target-framework-and-platform-toolset?view=vs-2019)

##### Platform toolset

The platform toolset consists of the C++ compiler (cl.exe) and linker (link.exe), along with the C/C++ standard libraries. Since Visual Studio 2015, the major version of the toolset has remained at 14, which means that projects compiled with Visual Studio 2019 or Visual Studio 2017 are ABI-backwards-compatible with projects compiled with Visual Studio 2015. The minor version has updated by 1 for each version since Visual Studio 2015:

- Visual Studio 2015: v140
- Visual Studio 2017: v141
- Visual Studio 2019: v142

## MSBuild

### [MSBuild Overview](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild?view=vs-2019)

The **Microsoft Build Engine** is a platform for building applications. This engine, which is also known as MSBuild, provides an XML schema for a project file that controls how the build platform processes and builds software. Visual Studio uses MSBuild, but MSBuild doesn't depend on Visual Studio. By invoking `msbuild.exe` on your project or solution file, you can orchestrate and build products in environments where Visual Studio isn't installed.

Visual Studio uses MSBuild to load and build managed projects. The project files in Visual Studio (`.csproj`, `.vbproj`, .`vcxproj`, and others) contain MSBuild XML code that executes when you build a project by using the IDE. Visual Studio projects import all the necessary settings and build processes to do typical development work, but you can extend or modify them from within Visual Studio or by using an XML editor.

For information about MSBuild for C++, see [MSBuild (C++)](https://docs.microsoft.com/en-us/cpp/build/msbuild-visual-cpp).

The following examples illustrate when you might run builds by invoking MSBuild from the command line instead of the Visual Studio IDE.

- Visual Studio isn't installed. ([Download MSBuild without Visual Studio](https://visualstudio.microsoft.com/downloads/?q=build+tools).)

- You want to use the 64-bit version of MSBuild. This version of MSBuild is usually unnecessary, but it allows MSBuild to access more memory.

- You want to run a build in multiple processes. However, you can use the IDE to achieve the same result on projects in `C++` and `C#`.

- You want to modify the build system. For example, you might want to enable the following actions:

  - Preprocess files before they reach the compiler.

  - Copy the build outputs to a different place.

  - Create compressed files from build outputs.

  - Do a post-processing step. For example, you might want to stamp an assembly with a different version.

You can write code in the Visual Studio IDE but run builds by using MSBuild. As another alternative, you can build code in the IDE on a development computer but run MSBuild from the command line to build code that's integrated from multiple developers. You can also use the [.NET Core command-line interface (CLI)](https://docs.microsoft.com/en-us/dotnet/core/tools/), which uses MSBuild, to build .NET Core projects.

#### Use MSBuild at a command prompt

To run MSBuild at a command prompt, pass a project file to `MSBuild.exe`, together with the appropriate command-line options. Command-line options let you set properties, execute specific targets, and set other options that control the build process. For example, you would use the following command-line syntax to build the file `MyProj.proj` with the Configuration property set to `Debug`.

    MSBuild.exe MyProj.proj -property:Configuration=Debug

For more information about MSBuild command-line options, see [Command-line reference](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-command-line-reference?view=vs-2019).

#### Project file

MSBuild uses an XML-based project file format that's straightforward and extensible. The MSBuild project file format lets developers describe the items that are to be built, and also how they are to be built for different operating systems and configurations. In addition, the project file format lets developers author reusable build rules that can be factored into separate files so that builds can be performed consistently across different projects in the product.

The following sections describe some of the basic elements of the MSBuild project file format. For a tutorial about how to create a basic project file, see Walkthrough: [Creating an MSBuild project file from scratch](https://docs.microsoft.com/en-us/visualstudio/msbuild/walkthrough-creating-an-msbuild-project-file-from-scratch?view=vs-2019).

##### Properties

Properties represent key/value pairs that can be used to configure builds. Properties are declared by creating an element that has the name of the property as a child of a [`PropertyGroup`](https://docs.microsoft.com/en-us/visualstudio/msbuild/propertygroup-element-msbuild?view=vs-2019) element. For example, the following code creates a property named `BuildDir` that has a value of Build.

    <PropertyGroup>
        <BuildDir>Build</BuildDir>
    </PropertyGroup>

You can define a property conditionally by placing a `Condition` attribute in the element. The contents of conditional elements are ignored unless the condition evaluates to `true`. In the following example, the `Configuration` element is defined if it hasn't yet been defined.

    <Configuration  Condition=" '$(Configuration)' == '' ">Debug</Configuration>

Properties can be referenced throughout the project file by using the syntax `$(<PropertyName>)`. For example, you can reference the properties in the previous examples by using `$(BuildDir)` and `$(Configuration)`.

For more information about properties, see [MSBuild properties](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-properties?view=vs-2019).

##### Items

Items are inputs into the build system and typically represent files. Items are grouped into **item types** based on user-defined **item names**. These item types can be used as parameters for tasks, which use the individual items to perform the steps of the build process.

Items are declared in the project file by creating an element that has the name of the **item type** as a child of an [ItemGroup](https://docs.microsoft.com/en-us/visualstudio/msbuild/itemgroup-element-msbuild?view=vs-2019) element. For example, the following code creates an item type named `Compile`, which includes two files.

    <ItemGroup>
        <Compile Include = "file1.cs"/>
        <Compile Include = "file2.cs"/>
    </ItemGroup>

Item types can be referenced throughout the project file by using the syntax `@(<ItemType>)`. For example, the item type in the example would be referenced by using `@(Compile)`.

In MSBuild, element and attribute names are case-sensitive. However, property, item, and metadata names are not. The following example creates the item type `Compile`, `comPile`, or any other case variation, and gives the item type the value "`one.cs`;`two.cs`".

    <ItemGroup>
        <Compile Include="one.cs" />
        <comPile Include="two.cs" />
    </ItemGroup>

Items can be declared by using wildcard characters and may contain additional metadata for more advanced build scenarios. For more information about items, see [Items](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-items?view=vs-2019).

##### Tasks

Tasks are units of executable code that MSBuild projects use to perform build operations. For example, a task might **compile input files** or **run an external tool**. Tasks can be reused, and they can be shared by different developers in different projects.

The execution logic of a task is written in managed code and mapped to MSBuild by using the [UsingTask](https://docs.microsoft.com/en-us/visualstudio/msbuild/usingtask-element-msbuild?view=vs-2019) element. You can write your own task by authoring a managed type that implements the [ITask](https://docs.microsoft.com/en-us/dotnet/api/microsoft.build.framework.itask) interface. For more information about how to write tasks, see [Task writing](https://docs.microsoft.com/en-us/visualstudio/msbuild/task-writing?view=vs-2019).

MSBuild includes common tasks that you can modify to suit your requirements. Examples are [Copy](https://docs.microsoft.com/en-us/visualstudio/msbuild/copy-task?view=vs-2019), which copies files, [MakeDir](https://docs.microsoft.com/en-us/visualstudio/msbuild/makedir-task?view=vs-2019), which creates directories, and [Csc](https://docs.microsoft.com/en-us/visualstudio/msbuild/csc-task?view=vs-2019), which compiles Visual C# source code files. For a list of available tasks together with usage information, see [Task reference](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-task-reference?view=vs-2019).

A task is executed in an MSBuild project file by creating an element that has the name of the task as a child of a [Target](https://docs.microsoft.com/en-us/visualstudio/msbuild/target-element-msbuild?view=vs-2019) element. Tasks typically accept parameters, which are passed as attributes of the element. Both MSBuild properties and items can be used as parameters. For example, the following code calls the [MakeDir](https://docs.microsoft.com/en-us/visualstudio/msbuild/makedir-task?view=vs-2019) task and passes it the value of the `BuildDir` property that was declared in the earlier example.

    <Target Name="MakeBuildDirectory">
        <MakeDir  Directories="$(BuildDir)" />
    </Target>

For more information about tasks, see [Tasks](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-tasks?view=vs-2019).

##### Targets

Targets **group tasks together** in a particular order and expose sections of the project file as entry points into the build process. Targets are often grouped into **logical sections** to increase readability and to allow for expansion. Breaking the build steps into targets lets you call one piece of the build process from other targets without copying that section of code into every target. For example, if several entry points into the build process require references to be built, you can create a target that builds references and then run that target from every entry point where it's required.

Targets are declared in the project file by using the [Target](https://docs.microsoft.com/en-us/visualstudio/msbuild/target-element-msbuild?view=vs-2019) element. For example, the following code creates a target named `Compile`, which then calls the [Csc](https://docs.microsoft.com/en-us/visualstudio/msbuild/csc-task?view=vs-2019) task that has the item list that was declared in the earlier example.

    <Target Name="Compile">
        <Csc Sources="@(Compile)" />
    </Target>

In more advanced scenarios, targets can be used to describe relationships among one another and perform dependency analysis so that whole sections of the build process can be skipped if that target is up-to-date. For more information about targets, see [Targets](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-targets?view=vs-2019).

#### Build logs

You can log build errors, warnings, and messages to the console or another output device. For more information, see [Obtaining build logs](https://docs.microsoft.com/en-us/visualstudio/msbuild/obtaining-build-logs-with-msbuild?view=vs-2019) and [Logging in MSBuild](https://docs.microsoft.com/en-us/visualstudio/msbuild/logging-in-msbuild?view=vs-2019).

#### Use MSBuild in Visual Studio

Visual Studio uses the MSBuild project file format to store build information about managed projects. Project settings that are added or changed by using the Visual Studio interface are reflected in the .*proj file that's generated for every project. Visual Studio uses a hosted instance of MSBuild to build managed projects. This means that a managed project can be built in Visual Studio or at a command prompt (even if Visual Studio isn't installed), and the results will be identical.

For a tutorial about how to use MSBuild in Visual Studio, see [Walkthrough: Using MSBuild](https://docs.microsoft.com/en-us/visualstudio/msbuild/walkthrough-using-msbuild?view=vs-2019).

#### Multitargeting

By using Visual Studio, you can compile an application to run on any one of several versions of .NET Framework. For example, you can compile an application to run on .NET Framework 2.0 on a 32-bit platform, and you can compile the same application to run on .NET Framework 4.5 on a 64-bit platform. The ability to compile to more than one framework is named multitargeting.

These are some of the benefits of multitargeting:

- You can develop applications that target earlier versions of .NET Framework, for example, versions 2.0, 3.0, and 3.5.

- You can target frameworks other than .NET Framework, for example, Silverlight.

- You can target a framework profile, which is a predefined subset of a target framework.

- If a service pack for the current version of .NET Framework is released, you could target it.

- Multitargeting guarantees that an application uses only the functionality that's available in the target framework and platform.

For more information, see [Multitargeting](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-multitargeting-overview?view=vs-2019).

### [Walkthrough: Use MSBuild](https://docs.microsoft.com/en-us/visualstudio/msbuild/walkthrough-using-msbuild?view=vs-2019)

MSBuild is the build platform for Microsoft and Visual Studio. This walkthrough introduces you to the building blocks of MSBuild and shows you how to write, manipulate, and debug MSBuild projects. You will learn about:

- Creating and manipulating a project file.

- How to use build properties

- How to use build items.

You can run MSBuild from Visual Studio, or from the Command Window. In this walkthrough, you create an MSBuild project file using Visual Studio. You edit the project file in Visual Studio, and use the Command Window to build the project and examine the results.

#### Create an MSBuild project

The Visual Studio project system is based on MSBuild. This makes it easy to create a new project file using Visual Studio. In this section, you create a Visual C# project file.

##### To create a project file

1. Open Visual Studio and create a project.

   Press **Esc** to close the start window. Type **Ctrl + Q** to open the search box, type **winforms**, then choose **Create a new Windows Forms App (.NET Framework)**. In the dialog box that appears, choose **Create**.

   In the **Name** box, type `BuildApp`. Enter a Location for the solution, for example, `D:\`. Accept the defaults for **Solution**, **Solution Name (BuildApp)**, and **Framework**.

2. Click **OK** or **Create** to create the project file.

#### Examine the project file

In the previous section, you used Visual Studio to create a Visual C# project file. The project file is represented in **Solution Explorer** by the project node named BuildApp. You can use the Visual Studio code editor to examine the project file.

##### To examine the project file

1. In **Solution Explorer**, click the project node **BuildApp**.

2. In the **Properties** browser, notice that the **Project File** property is `BuildApp.csproj`. All project files are named with the suffix `proj`. If you had created a Visual Basic project, the project file name would be `BuildApp.vbproj`.

3. Right-click the project node, then click Unload Project.

4. Right-click the project node again, then click Edit **BuildApp.csproj**.

   The project file appears in the code editor.

#### Targets and tasks

Project files are XML-formatted files with the root node [Project](https://docs.microsoft.com/en-us/visualstudio/msbuild/project-element-msbuild?view=vs-2019).

    <?xml version="1.0" encoding="utf-8"?>
    <Project ToolsVersion="15.0"  xmlns="http://schemas.microsoft.com/developer/msbuild/2003">

You must specify the xmlns namespace in the Project element. If `ToolsVersion` is present in a new project, it must be "15.0".

The work of building an application is done with [Target](https://docs.microsoft.com/en-us/visualstudio/msbuild/target-element-msbuild?view=vs-2019) and [Task](https://docs.microsoft.com/en-us/visualstudio/msbuild/task-element-msbuild?view=vs-2019) elements.

- A task is the smallest unit of work, in other words, the "atom" of a build. Tasks are independent executable components which may have inputs and outputs. There are no tasks currently referenced or defined in the project file. You add tasks to the project file in the sections below. For more information, see the [Tasks](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-tasks?view=vs-2019) topic.

- A target is a named sequence of tasks. For more information, see the [Targets](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-targets?view=vs-2019) topic.

The default target is not defined in the project file. Instead, it is specified in imported projects. The [Import](https://docs.microsoft.com/en-us/visualstudio/msbuild/import-element-msbuild?view=vs-2019) element specifies imported projects. For example, in a C# project, the default target is imported from the file `Microsoft.CSharp.targets`.

    <Import Project="$(MSBuildToolsPath)\Microsoft.CSharp.targets" />

Imported files are effectively inserted into the project file wherever they are referenced.

MSBuild keeps track of the targets of a build, and guarantees that each target is built no more than once.

#### Add a target and a task

Add a target to the project file. Add a task to the target that prints out a message.

##### To add a target and a task

1. Add these lines to the project file, just after the Import statement:

       <Target Name="HelloWorld">
       </Target>

2. Add lines to the HelloWorld target, so that the resulting section looks like this:

       <Target Name="HelloWorld">
         <Message Text="Hello"></Message>  <Message Text="World"></Message>
       </Target>

3. Save the project file.

The Message task is one of the many tasks that ships with MSBuild. For a complete list of available tasks and usage information, see [Task reference](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-task-reference?view=vs-2019).

The Message task takes the string value of the Text attribute as input and displays it on the output device. The HelloWorld target executes the Message task twice: first to display "Hello", and then to display "World".

#### Build the target

Run MSBuild from the **Developer Command Prompt** for Visual Studio to build the HelloWorld target defined above. Use the -target or -t command line switch to select the target.

##### To build the target

1. Open the Command Window.

   (Windows 10) In the search box on the taskbar, start typing the name of the tool, such as dev or developer command prompt. This brings up a list of installed apps that match your search pattern.

   If you need to find it manually, the file is          `LaunchDevCmd.bat` in the `<visualstudio installation folder><version>\Common7\Tools` folder.

2. From the command window, navigate to the folder containing the project file, in this case, `D:\BuildApp\BuildApp`.

3. Run msbuild with the command switch `-t:HelloWorld`. This selects and builds the `HelloWorld` target:

       msbuild buildapp.csproj -t:HelloWorld

4. Examine the output in the Command window. You should see the two lines "Hello" and "World":

#### Build properties

Build properties are name-value pairs that guide the build. Several build properties are already defined at the top of the project file:

    <PropertyGroup>
    ...
      <ProductVersion>10.0.11107</ProductVersion>
      <SchemaVersion>2.0</SchemaVersion>
      <ProjectGuid>{30E3C9D5-FD86-4691-A331-80EA5BA7E571}</ProjectGuid>
      <OutputType>WinExe</OutputType>
    ...
    </PropertyGroup>

All properties are child elements of `PropertyGroup` elements. The **name** of the property is the name of the child element, and the **value** of the property is the text element of the child element. For example,

    <TargetFrameworkVersion>v15.0</TargetFrameworkVersion>

defines the property named `TargetFrameworkVersion`, giving it the string value "`v15.0`".

Build properties may be **redefined** at any time. If

    <TargetFrameworkVersion>v3.5</TargetFrameworkVersion>

appears later in the project file, or in a file imported later in the project file, then `TargetFrameworkVersion` takes the new value "`v3.5`".

#### Examine a property value

To get the value of a property, use the following syntax, where `PropertyName` is the name of the property:

    $(PropertyName)

Use this syntax to examine some of the properties in the project file.

##### To examine a property value

1. From the code editor, replace the `HelloWorld` target with this code:

       <Target Name="HelloWorld">
         <Message Text="Configuration is $(Configuration)" />
         <Message Text="MSBuildToolsPath is $(MSBuildToolsPath)" />
       </Target>

2. Save the project file.

3. From the Command Window, enter and execute this line:

       msbuild buildapp.csproj -t:HelloWorld

4. Examine the output.

##### Conditional properties

Many properties like Configuration are defined conditionally, that is, the Condition attribute appears in the property element. Conditional properties are **defined or redefined** only if the condition evaluates to "true". Note that undefined properties are given the default value of an empty string. For example,

    <Configuration   Condition=" '$(Configuration)' == '' ">Debug</Configuration>

means "If the Configuration property has not been defined yet, define it and give it the value 'Debug'".

Almost all MSBuild elements can have a Condition attribute. For more discussion about using the Condition attribute, see [Conditions](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-conditions?view=vs-2019).

##### Reserved properties

MSBuild reserves some property names to store information about the project file and the MSBuild binaries. `MSBuildToolsPath` is an example of a reserved property. Reserved properties are referenced with the `$` notation like any other property. For more information, see [How to: Reference the name or location of the project file](https://docs.microsoft.com/en-us/visualstudio/msbuild/how-to-reference-the-name-or-location-of-the-project-file?view=vs-2019) and [MSBuild reserved and well-known properties](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-reserved-and-well-known-properties?view=vs-2019).

##### Environment variables

You can reference **environment variables** in project files the **same way as build properties**. For example, to use the `PATH` environment variable in your project file, use `$(Path)`. If the project contains a property definition that has the same name as an environment variable, the property in the project **overrides** the value of the environment variable. For more information, see [How to: Use environment variables in a build](https://docs.microsoft.com/en-us/visualstudio/msbuild/how-to-use-environment-variables-in-a-build?view=vs-2019).

#### Set properties from the command line

Properties may be defined on the command line using the `-property` or `-p` command line switch. Property values received from the command line **override** property values set in the project file and environment variables.

##### To set a property value from the command line

1. From the Command Window, enter and execute this line:

       msbuild buildapp.csproj -t:HelloWorld -p:Configuration=Release

2. Examine the output.

MSBuild creates the Configuration property and gives it the value "Release".

#### Special characters

Certain characters have special meaning in MSBuild project files. Examples of these characters include semicolons (;) and asterisks (*). In order to use these special characters as literals in a project file, they must be specified by using the syntax `%<xx>`, where `<xx>` represents the ASCII hexadecimal value of the character.

Change the Message task to show the value of the Configuration property with special characters to make it more readable.

##### To use special characters in the Message task

1. From the code editor, replace both Message tasks with this line:

       <Message Text="%24(Configuration) is %22$(Configuration)%22" />

2. Save the project file.

3. From the Command Window, enter and execute this line:

       msbuild buildapp.csproj -t:HelloWorld

4. Examine the output. You should see this line:

       $(Configuration) is "Debug"

For more information, see [MSBuild special characters](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-special-characters?view=vs-2019).

#### Build items

An item is a piece of information, typically a file name, that is used as an **input to the build system**. For example, a collection of items representing source files might be **passed to a task** named Compile to compile them into an assembly.

All items are child elements of `ItemGroup` elements. The **item name** is the name of the child element, and the **item value is the value of the `Include` attribute** of the child element. The values of items with the same name are collected into item types of that name. For example,

    <ItemGroup>
        <Compile Include="Program.cs" />
        <Compile Include="Properties\AssemblyInfo.cs" />
    </ItemGroup>

defines an **item group** containing two items. The item type Compile has two values: `Program.cs` and `Properties\AssemblyInfo.cs`.

The following code creates the same item type by declaring both files in one Include attribute, separated by a semicolon.

    <ItemGroup>
        <Compile Include="Program.cs;Properties\AssemblyInfo.cs" />
    </ItemGroup>

For more information, see [Items](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-items?view=vs-2019).

Note: File paths are relative to the folder containing the MSBuild project file.

#### Examine item type values

To get the values of an item type, use the following syntax, where `ItemType` is the name of the item type:

    @(ItemType)

Use this syntax to examine the `Compile` item type in the project file.

##### To examine item type values

1. From the code editor, replace the HelloWorld target task with this code:

       <Target Name="HelloWorld">
         <Message Text="Compile item type contains @(Compile)" />
       </Target>

2. Save the project file.

3. From the Command Window, enter and execute this line:

       msbuild buildapp.csproj -t:HelloWorld

4. Examine the output.

The values of an item type are separated with semicolons by default.

To change the separator of an item type, use the following syntax, where ItemType is the item type and Separator is a string of one or more separating characters:

    @(ItemType, Separator)

Change the Message task to use carriage returns and line feeds (`%0A%0D`) to display Compile items one per line.

##### To display item type values one per line

1. From the code editor, replace the Message task with this line:

       <Message Text="Compile item type contains @(Compile, '%0A%0D')" />

2. Save the project file.

3. From the Command Window, enter and execute this line:

       msbuild buildapp.csproj -t:HelloWorld

4. Examine the output.

##### Include, Exclude, and wildcards

You can use the wildcards "*", "**", and "?" with the Include attribute to add items to an item type. For example,

    <Photos Include="images\*.jpeg" />

adds all files with the file extension `.jpeg` in the images folder to the Photos **item type**, while

    <Photos Include="images\**\*.jpeg" />

adds all files with the file extension `.jpeg` in the images **folder**, and all its **subfolders**, to the Photos item type. For more examples, see [How to: Select the files to build](https://docs.microsoft.com/en-us/visualstudio/msbuild/how-to-select-the-files-to-build?view=vs-2019).

Notice that as items are declared they are added to the item type. For example,

    <Photos Include="images\*.jpeg" />
    <Photos Include="images\*.gif" />

creates an item type named Photo containing all files in the images folder with a file extension of **either `.jpeg` or `.gif`**. This is equivalent to the following line:

    <Photos Include="images\*.jpeg;images\*.gif" />

You can **exclude** an item from an item type with the Exclude attribute. For example,

    <Compile Include="*.cs" Exclude="*Designer*">

adds all files with the file extension `.cs` to the Compile item type, except for files whose names contain the string Designer. For more examples, see [How to: Exclude files from the build](https://docs.microsoft.com/en-us/visualstudio/msbuild/how-to-exclude-files-from-the-build?view=vs-2019).

The Exclude attribute only affects the items added by the Include attribute in the item element that **contains them both**. For example,

    <Compile Include="*.cs" />
    <Compile Include="*.res" Exclude="Form1.cs">

would **not exclude** the file `Form1.cs`, which was added in the preceding item element.

###### To include and exclude items

1. From the code editor, replace the Message task with this line:

       <Message Text="XFiles item type contains @(XFiles)" />

2. Add this item group just after the Import element:

       <ItemGroup>
         <XFiles Include="*.cs;properties/*.resx" Exclude="*Designer*" />
       </ItemGroup>

3. Save the project file.

4. From the Command Window, enter and execute this line:

       msbuild buildapp.csproj -t:HelloWorld

5. Examine the output.

#### Item metadata

Items may contain metadata in addition to the information gathered from the `Include` and `Exclude` attributes. This metadata can be used by tasks that require more information about items than just the item value.

Item metadata is declared in the project file by creating an element with the name of the metadata as a **child element of the item**. An item can have **zero or more** metadata values. For example, the following `CSFile` item has `Culture` metadata with a value of "`Fr`":

    <ItemGroup>
        <CSFile Include="main.cs">
            <Culture>Fr</Culture>
        </CSFile>
    </ItemGroup>

To get the metadata value of an item type, use the following syntax, where `ItemType` is the name of the item type and `MetaDataName` is the name of the metadata:

    %(ItemType.MetaDataName)

##### To examine item metadata

1. From the code editor, replace the Message task with this line:

       <Message Text="Compile.DependentUpon: %(Compile.DependentUpon)" />

2. Save the project file.

3. From the Command Window, enter and execute this line:

       msbuild buildapp.csproj -t:HelloWorld

4. Examine the output.

Notice how the phrase "Compile.DependentUpon" appears several times. The use of metadata with this syntax within a target causes "**batching**". Batching means that the tasks within the **target are executed once for each unique metadata value**. This is the MSBuild script equivalent of the common "**for loop**" programming construct. For more information, see [Batching](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-batching?view=vs-2019).

##### Well-known metadata

Whenever an item is added to an item list, that item is **assigned** some well-known metadata. For example, `%(Filename)` returns the file name of any item. For a complete list of well-known metadata, see [Well-known item metadata](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-well-known-item-metadata?view=vs-2019).

###### To examine well-known metadata

1. From the code editor, replace the Message task with this line:

       <Message Text="Compile Filename: %(Compile.Filename)" />

2. Save the project file.

3. From the Command Window, enter and execute this line:

       msbuild buildapp.csproj -t:HelloWorld

4. Examine the output.

By comparing the two examples above, you can see that while not every item in the Compile item type has DependentUpon metadata, all items have the well-known Filename metadata.

##### Metadata transformations

Item lists can be transformed into new item lists. To transform an item list, use the following syntax, where `<ItemType>` is the name of the item type and `<MetadataName>` is the name of the metadata:

    @(ItemType -> '%(MetadataName)')

For example, an item list of source files can be transformed into a collection of object files using an expression like `@(SourceFiles -> '%(Filename).obj')`. For more information, see [Transforms](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-transforms?view=vs-2019).

###### To transform items using metadata

1. From the code editor, replace the Message task with this line:

       <Message Text="Backup files: @(Compile->'%(filename).bak')" />

2. Save the project file.

3. From the Command Window, enter and execute this line:

       msbuild buildapp.csproj -t:HelloWorld

4. Examine the output.

Notice that metadata expressed in this syntax does not cause batching.

### [MSBuild concepts](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-concepts?view=vs-2019)

#### [Targets](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-targets?view=vs-2019)

##### [Target build order](https://docs.microsoft.com/en-us/visualstudio/msbuild/target-build-order?view=vs-2019)

Targets must be ordered if the input to one target depends on the output of another target. You can use these attributes to specify the order in which targets are run:

- `InitialTargets`. This **`Project` attribute** specifies the targets that will run first, even if targets are specified on the **command line** or in the `DefaultTargets` attribute.

- `DefaultTargets`. This Project attribute specifies which targets are run if a target is not specified explicitly on the command line.

- `DependsOnTargets`. This Target attribute specifies targets that must run before this target can run.

- `BeforeTargets` and `AfterTargets`. These Target attributes specify that this target should run before or after the specified targets (MSBuild 4.0).

A target is **never run twice** during a build, even if a subsequent target in the build depends on it. Once a target has been run, its contribution to the build is complete.

Targets may have a **`Condition` attribute**. If the specified condition evaluates to `false`, the target isn't executed and has no effect on the build. For more information about conditions, see [Conditions](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-conditions?view=vs-2019).

###### Initial targets

The `InitialTargets` attribute of the [Project](https://docs.microsoft.com/en-us/visualstudio/msbuild/project-element-msbuild?view=vs-2019) element specifies targets that will run first, **even if** targets are specified on the **command line** or in the **`DefaultTargets` attribute**. Initial targets are typically used for error checking.

The value of the `InitialTargets` attribute can be a **semicolon-delimited**, ordered list of targets. The following example specifies that the Warm target runs, and then the Eject target runs.

    <Project InitialTargets="Warm;Eject" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">

Imported projects may have their own `InitialTargets` attributes. All initial targets are aggregated together and run in order.

For more information, see [How to: Specify which target to build first](https://docs.microsoft.com/en-us/visualstudio/msbuild/how-to-specify-which-target-to-build-first?view=vs-2019).

###### Default targets

The `DefaultTargets` attribute of the Project element specifies which target or targets are built if a target **isn't specified explicitly** in a **command line**.

The value of the `DefaultTargets` attribute can be a **semicolon-delimited**, ordered list of default targets. The following example specifies that the `Clean` target runs, and then the `Build` target runs.

    <Project DefaultTargets="Clean;Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">

You can **override** the default targets by using the `-target` switch on the command line. The following example specifies that the `Build` target runs, and then the `Report` target runs. When you specify targets in this way, any default targets are ignored.

    msbuild -target:Build;Report

If both initial targets and default targets are specified, and if no command-line targets are specified, MSBuild runs the initial targets first, and then runs the default targets.

`Imported` projects may have their own `DefaultTargets` attributes. The **first** `DefaultTargets` attribute encountered determines which default targets will run.

For more information, see [How to: Specify which target to build first](https://docs.microsoft.com/en-us/visualstudio/msbuild/how-to-specify-which-target-to-build-first?view=vs-2019).

###### First target

If there are no initial targets, default targets, or command-line targets, then MSBuild runs the first target it encounters in the project file or any imported project files.

###### Target dependencies

Targets can describe dependency relationships with each other. The `DependsOnTargets` attribute indicates that a target depends on other targets. For example,

    <Target Name="Serve" DependsOnTargets="Chop;Cook" />

tells MSBuild that the Serve target depends on the Chop target and the Cook target. MSBuild runs the Chop target, and then runs the Cook target before it runs the Serve target.

###### BeforeTargets and AfterTargets

In MSBuild 4.0, you can specify target order by using the `BeforeTargets` and `AfterTargets` attributes.
Consider the following script.

    <Project DefaultTargets="Compile;Link" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
        <Target Name="Compile">
            <Message Text="Compiling" />
        </Target>
        <Target Name="Link">
            <Message Text="Linking" />
        </Target>
    </Project>

To create an intermediate target Optimize that runs after the Compile target, but before the Link target, add the following target anywhere in the Project element.

    <Target Name="Optimize"
        AfterTargets="Compile" BeforeTargets="Link">
        <Message Text="Optimizing" />
    </Target>

###### Determine the target build order

MSBuild determines the target build order as follows:

1. `InitialTargets` targets are run.

2. Targets specified on the command line by the **`-target`** switch are run. If you specify no targets on the command line, then the **`DefaultTargets`** targets are run. If neither is present, then the **first target** encountered is run.

3. The `Condition` attribute of the target is evaluated. If the `Condition` attribute is present and evaluates to `false`, the target isn't executed and has no further effect on the build.

    Other targets that list the conditional target in `BeforeTargets` or `AfterTargets` **still execute** in the prescribed order.

4. Before the target is executed or skipped, its `DependsOnTargets` targets are run, unless the `Condition` attribute is applied to the target and evaluates to `false`.

    Note: A target is considered **skipped** if it is not executed because its output items are up-to-date (see [incremental build](https://docs.microsoft.com/en-us/visualstudio/msbuild/incremental-builds?view=vs-2019)). This check is done just before executing the tasks inside target, and does not affect the order of execution of targets.

5. Before the target is executed or skipped, any other target that lists the target in a `BeforeTargets` attribute is run.

6. Before the target is executed, its **`Inputs` attribute** and **`Outputs` attribute** are **compared**. If MSBuild determines that any output files are out of date with respect to the corresponding input file or files, then MSBuild executes the target. Otherwise, MSBuild skips the target.

7. After the target is executed or skipped, any other target that lists it in an `AfterTargets` attribute is run.

##### [Build specific targets in solutions by using MSBuild.exe](https://docs.microsoft.com/en-us/visualstudio/msbuild/how-to-build-specific-targets-in-solutions-by-using-msbuild-exe?view=vs-2019)

You can use MSBuild.exe to build **specific targets** of **specific projects** in a **solution**.

###### To build a specific target of a specific project in a solution

1. At the command line, type MSBuild.exe `<SolutionName>`.sln, where `<SolutionName>` corresponds to the file name of the solution that contains the target that you want to execute.

2. Specify the target after the `-target:` switch in the format `<ProjectName>:<TargetName>`. If the project name contains any of the characters `%`, `$`, `@`, `;`, `.`, `(`, `)`, or `'`, replace them with an `_` in the specified target name.

Example

The following example executes the `Rebuild` target of the `NotInSlnFolder` project, and then executes the `Clean` target of the `InSolutionFolder` project, which is located in the `NewFolder` solution folder.

    msbuild SlnFolders.sln -target:NotInSlnfolder:Rebuild;NewFolder\InSolutionFolder:Clean

Troubleshooting

If you would like to examine the options available to you, you can use a **debugging option** provided by MSBuild to do so. Set the environment variable `MSBUILDEMITSOLUTION=1` and build your solution. This will produce an MSBuild file named `<SolutionName>.sln.metaproj` that shows MSBuild's internal view of the solution at build time. You can inspect this view to determine what targets are available to build.

Do not build with this environment variable set unless you need this internal view. This setting can cause problems building projects in your solution.

##### [Build Incrementally](https://docs.microsoft.com/en-us/visualstudio/msbuild/how-to-build-incrementally?view=vs-2015&redirectedfrom=MSDN)

### [MSBuild reference](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-reference?view=vs-2019)

#### [MSBuild command-line reference](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-command-line-reference?view=vs-2019)

When you use MSBuild.exe to build a project or solution file, you can include several **switches** to specify various aspects of the process.

Every switch is available in two forms: `-switch` and `/switch`. The documentation only shows the `-switch` form. Switches are **not case-sensitive**. If you run MSBuild from a shell other than the Windows command prompt, lists of arguments to a switch (separated by semicolons or commas) might need single or double quotes to ensure that lists are passed to MSBuild instead of interpreted by the shell.

Syntax

    MSBuild.exe [Switches] [ProjectFile]

- Arguments

  - ProjectFile

    Builds the targets in the **project file** that you specify. If you don't specify a project file, MSBuild **searches** the current working directory for a file name **extension** that ends in `proj` and uses that file. You can also specify a Visual Studio **solution file** for this argument.

- Switches

  - `-detailedSummary` or `-ds`

    Show detailed information at the end of the build log about the configurations that were built and how they were scheduled to nodes.

  - `-graphBuild[:True or False]` or `-graph[:True or False]`

    Causes MSBuild to construct and build a project graph. Constructing a graph involves identifying project references to form dependencies. Building that graph involves attempting to build project references prior to the projects that reference them, differing from traditional MSBuild scheduling.

  - `-property:name=value` or `-p:name=value`

    Set or override the specified **project-level** properties, where name is the property name and value is the property value. Specify each property separately, or use a semicolon or comma to separate multiple properties, as the following example shows:

        -property:WarningLevel=2;OutDir=bin\Debug

  - `-target:targets` or -t:targets

    Build the specified targets in the project. Specify each target separately, or use a semicolon or comma to separate **multiple targets**, as the following example shows:

          -target:PrepareResources;Compile

    If you specify any targets by using this switch, they are run instead of any targets in the `DefaultTargets` attribute in the project file. For more information, see Target build order and [How to: Specify which target to build first](https://docs.microsoft.com/en-us/visualstudio/msbuild/how-to-specify-which-target-to-build-first?view=vs-2019).

    A target is a group of tasks. For more information, see [Targets](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-targets?view=vs-2019).

  - `-verbosity:level` or `-v:level`

    Specifies the amount of information to display in the **build log**. Each logger displays events based on the verbosity level that you set for that logger.

    You can specify the following verbosity levels: `q[uiet]`, `m[inimal]`, `n[ormal]` (default), `d[etailed]`, and `diag[nostic]`.

    The following setting is an example: `-verbosity:quiet`

- Switches for loggers

  - `-fileLogger[number]` or `-fl[number]`

    **Log the build output to a single file** in the current directory. If you don't specify number, the output file is named `msbuild.log`. If you specify number, the output file is named `msbuild<n>.log`, where `<n>` is number. Number can be a digit from 1 to 9.

    You can use the `-fileLoggerParameters` switch to specify the **location of the file** and other parameters for the fileLogger.

Example

The following example builds the rebuild target of the `MyProject.proj` project.

    MSBuild.exe MyProject.proj -t:rebuild

Example

You can use MSBuild.exe to perform more complex builds. For example, you can use it to build specific targets of specific projects in a solution. The following example rebuilds the project `NotInSolutionFolder` and cleans the project `InSolutionFolder`, which is in the `NewFolder` solution folder.

    msbuild SlnFolders.sln -t:NotInSolutionfolder:Rebuild;NewFolder\InSolutionFolder:Clean

### Practice

#### Build a solution

    msbuild  NameOfYourSoution.sln

#### Build a specific project

    msbuild NameOfYourProject.csproj

#### Specifying the Configuration for MSBuild

    msbuild NameOfYourProject.csproj -p:Configuration=Release

#### Specifying the Platform for MSBuild

    msbuild NameOfYourProject.sln -p:Configuration=Release -p:Platform=x64

#### Rebuilding project

    msbuild NameOfYourProject.csproj -t:rebuild

#### Cleaning Solution/Project

    msbuild NameOfYourSolution.sln -t:clean

#### Write Log to `msbuild.log`

    msbuild  NameOfYourSoution.sln -fl

## [Inside the Visual Studio SDK](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/inside-the-visual-studio-sdk?view=vs-2019)

### [Projects](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/projects?view=vs-2019)

In Visual Studio, projects are the **containers** that developers use to organize **source code files** and **other resources** that appear in Solution Explorer. Typically, projects are files (for example, a .csproj file for a C# project) that store references to source code files and resources like bitmap files. Projects let you **organize**, **build**, **debug**, and **deploy** source code, references to Web services and databases, and other resources. VSPackages can extend the Visual Studio project system in three main ways: **project types**, **project subtypes**, and **custom tools**.

#### [Project Types](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/project-types?view=vs-2019)

Visual Studio includes several project types for languages such as Visual C# and Visual Basic. Visual Studio also lets you create your own project types.

##### [Managing Configuration Options](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/managing-configuration-options?view=vs-2019)

When you create a new project type, you must manage project and solution configuration settings that determine how your project will be **built**, **packaged**, **deployed**, and **run**. The following topics discuss project and solution configuration.

###### [Configuration options overview](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/configuration-options-overview?view=vs-2019)

Projects in Visual Studio can support multiple configurations that can be **built**, **debugged**, **run**, and/or **deployed**. A **configuration is a build type** described with a **named set of properties**, typically **compiler switches** and **file locations**. By default, new solutions contain two configurations, Debug and Release. These configurations can be applied using their default settings, or modified to meet your specific solution and/or project requirements. Some packages can be built in two ways: as an ActiveX editor or as an in-place component. Projects do not need to support multiple configurations, however. If there is only one configuration available, that configuration is **mapped into all of the solution configurations**.

Configurations typically consist of two parts: the **configuration name** (such as Debug or Release) and the **platform settings**. A configuration's platform name identifies the environment that the configuration targets, such as an API set or operating system platform. Users of Visual Studio cannot create a platform; they must choose from the selections a project VSPackage allows. When a user installs a VSPackage, the delivery platform created during development of the package can surface any platform name desired based on any criteria set by the package creator. The user can then select from the list of platforms made available through the VSPackage when the property pages are instantiated.

Platform names are optional since not all projects support the concept of platforms. When a configuration lacks a platform name, the string N/A is displayed in the UI.

Each **solution has its own set of configurations**, **only one of which can be active at a time**. A solution configuration is a set of no more than one configuration from each project. The "no more than" stipulation is due to the option to **exclude a project from a solution configuration**. Users can create their own custom solution configurations.

Changing the active configuration for a solution **selects the set of project configurations** that is built, run, debugged, or deployed in that solution. For example, if you change the active solution configuration from Release to Debug, all projects within that solution are automatically built with the projects' configuration indicated in the solution's debug configuration. The projects' configurations are also named Debug unless the user has made manual changes in the environment's Configuration Manager.

The **solution configuration properties** stored for each project include the **project name**, **project configuration name**, **flags** to indicate whether or not to build or to deploy, and **platform name**. For more information, see [Solution configuration](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solution-configuration?view=vs-2019).

The user can view and set solution configuration parameters by selecting the solution in the hierarchy (Solution Explorer) and opening the property pages. Similarly, you can view and set project configuration parameters by selecting a project in Solution Explorer and opening the property pages for that project.

The user can also build one project using release configuration settings and all the rest with debug configuration settings if necessary. For more information, see [Project configuration for building](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/project-configuration-for-building?view=vs-2019).

###### [Solution Configuration](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solution-configuration?view=vs-2019)

Solution configurations store solution-level properties. They **direct the behavior** of the **Start (F5) key** and **Build commands**. By default, these commands build and start the debug configuration. Both commands execute in the **context of a solution configuration**. This means that the user can expect F5 to start and build whatever the active solution is configured through the settings. The environment is designed to optimize for solutions rather than projects when it comes to building and running.

Here is how you can implement the solution configurations supported by your project type:

- Project

   Displays the names of projects found in the current solution.

- Configuration

   To provide the list of configurations supported by your project type and displayed in the property pages, implement [IVsCfgProvider2](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivscfgprovider2).

   The Configuration column displays the name of the project configuration to build in this solution configuration, and lists all of the project configurations when you click the arrow button. The environment calls the [GetCfgNames](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivscfgprovider2.getcfgnames) method to fill out this list. If the [GetCfgProviderProperty](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivscfgprovider2.getcfgproviderproperty) method indicates that the project supports configuration editing, New or Edit selections are also displayed under the Configuration heading. Each of these selections launch dialog boxes that call methods of the `IVsCfgProvider2` interface to edit the project's configurations.

   If a project does not support configurations, the Configuration column displays None and is disabled.

- Platform

   Displays the platform the selected project configuration builds for, and lists all of the available platforms for the project when you click the arrow button. The environment calls the [GetPlatformNames](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivscfgprovider2.getplatformnames) method to fill out this list. If the [GetCfgProviderProperty](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivscfgprovider2.getcfgproviderproperty) method indicates that the project supports platform editing, New or Edit selections are also displayed under the Platform heading. Each of these selections launch dialog boxes that call IVsCfgProvider2 methods to edit the project's available platforms.

   If a project does not support platforms, the platform column for that project displays None and is disabled.

- Build

   Specifies whether or not the project is built by the current solution configuration. **Unselected projects are not built when the solution-level build commands are invoked despite any project dependencies they contain**. Projects not selected to be built are **still** included in debugging, running, packaging, and deployment of the solution.

- Deploy

   Specifies whether or not the project will be deployed when the Start or Deploy commands are used with the selected solution build configuration. The check box for this field will be available if the project supports deploying by implementing the [IVsDeployableProjectCfg](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivsdeployableprojectcfg) interface on its [IVsProjectCfg2](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivsprojectcfg2) object.

   Once a new solution configuration is added, the user can select it from the Solution Configuration drop-down list box on the standard toolbar to build and/or start that configuration.

###### [Project Configuration for Building](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/project-configuration-for-building?view=vs-2019)

The list of solution configurations for a given solution is managed by the Solution Configurations dialog box.

A user can create additional solution configurations, each with its own unique name. When the user creates a new solution configuration, the IDE defaults to the corresponding configuration name in the projects, or Debug if no corresponding name exists. The user can change the selection to meet specific requirements if necessary. The only exception to this behavior is when the project supports a configuration that matches the name of the new solution configuration. For example, assume a solution contains Project1 and Project2. Project1 has project configurations Debug, Retail, and MyConfig1. Project2 has project configurations Debug, Retail, and MyConfig2.

If the user creates a new solution configuration named MyConfig2, Project1 binds its Debug configuration to the solution configuration by default. Project2 also binds its MyConfig2 configuration to the solution configuration by default.

**Project dependencies and build order** are **solution configuration independent**: that is, you can only set up one dependency tree for all of the projects in the solution. Right-clicking the solution or project and selecting either the **Project Dependencies** or **Project Build Order** option opens the Project Dependencies dialog box. It can also be opened from the Project menu.

Project dependencies determine the order in which projects build. Use the Build Order tab on the dialog box to view the exact order in which projects within a solution will build, and use the Dependencies tab to modify the build order.

Visual Studio build processes include the typical **compile** and **link** operations that are invoked with a single Build command. Two other build processes can also be supported: a **clean** operation to delete all output items from a previous build, and an **up-to-date check** to determine if an output item in a configuration has changed.

### Solutions

#### [Solutions overview](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solutions-overview?view=vs-2019)

A solution is a **grouping of one or more projects** that work together to create an application. The project and status information pertaining to the solution are stored in two different solution files. The [solution (.sln) file](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solution-dot-sln-file?view=vs-2019) is text-based and can be placed under source code control and shared between users. The [solution user option (.suo) file](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solution-user-options-dot-suo-file?view=vs-2019) is binary. As a result, the `.suo` file cannot be placed under source code control and contains user-specific information.

Any [VSPackage](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solutions-overview?view=vs-2019) can write to either type of solution file. Because of the nature of the files, there are two different interfaces implemented to write to them. The [IVsPersistSolutionProps](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivspersistsolutionprops) interface writes text information to the .sln file and the [IVsPersistSolutionOpts](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivspersistsolutionopts) interface writes binary streams to the .suo file.

Note: A project does not have to explicitly write an entry for itself into the solution file; the environment handles that for the project. Therefore, unless you want to add additional content specifically to the solution file, you do not need to register your VSPackage in this way.

When a solution is opened, the following process takes place.

1. The environment reads the solution.

2. If the environment finds a `CLSID`, it loads the corresponding VSPackage.

3. If a VSPackage is loaded, the environment calls `QueryInterface` for [IVsPackage](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivspackage) interface for the interface that the VSPackage requires.

   - When reading from an .sln file, the environment calls `QueryInterface` for `IVsPersistSolutionProps`.

   - When reading from an .suo file, the environment calls `QueryInterface` for `IVsPersistSolutionOpts`.

   Specific information relating to the use of these files can be found in [Solution (.Sln) File](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solution-dot-sln-file?view=vs-2019) and [Solution User Options (.Suo) File](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solution-user-options-dot-suo-file?view=vs-2019).

Note: If you want to create a new solution configuration consisting of two projects' configurations and excluding a third from the build, you need to use the Property Pages UI or automation. You can't change the solution build manager configurations and their properties directly, but you can manipulate the solution build manager using the `SolutionBuild` class from DTE in the automation model. For more information about configuring solutions, see [Solution Configuration](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solution-configuration?view=vs-2019).

#### [Solution (.sln) file](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solution-dot-sln-file?view=vs-2019)

A solution is a structure for organizing projects in Visual Studio. The solution maintains the state information for projects in two files:

- .sln file (text-based, shared)

- .suo file (binary, user-specific solution options)

For more information about .suo files, see [Solution User Options (.Suo) File](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solution-user-options-dot-suo-file?view=vs-2019).

If your VSPackage is loaded as a result of being referenced in the .sln file, the environment calls [ReadSolutionProps](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivspersistsolutionprops.readsolutionprops) to read in the .sln file.

The `.sln` file contains text-based information the environment uses to find and load the name-value parameters for the persisted data and the project VSPackages it references. When a user opens a solution, the environment cycles through the **`preSolution`**, **`Project`**, and **`postSolution`** information in the `.sln` file to load the solution, projects within the solution, and any persisted information attached to the solution.

Each project's file contains additional information read by the environment to populate the hierarchy with that project's items. The hierarchy data persistence is controlled by the project. The data is not normally stored in the `.sln` file, although you can intentionally write project information to the `.sln` file if you choose to do so. For more information about persistence, see [Project Persistence](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/project-persistence?view=vs-2019) and [Opening and Saving Project Items](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/opening-and-saving-project-items?view=vs-2019).

- File header

  The header of a .sln file looks like this:

      Microsoft Visual Studio Solution File, Format Version 12.00
      # Visual Studio Version 16
      VisualStudioVersion = 16.0.28701.123
      MinimumVisualStudioVersion = 10.0.40219.1

  - `Microsoft Visual Studio Solution File, Format Version 12.00`

    Standard header that defines the file format version.

  - `# Visual Studio Version 16`

    The major version of Visual Studio that (most recently) saved this solution file. This information controls the version number in the solution icon.

  - `VisualStudioVersion = 16.0.28701.123`

    The full version of Visual Studio that (most recently) saved the solution file. If the solution file is saved by a newer version of Visual Studio that has the same major version, this value is not updated so as to lessen churn in the file.

  - `MinimumVisualStudioVersion = 10.0.40219.1`

    The minimum (oldest) version of Visual Studio that can open this solution file.

- File body

  The body of an `.sln` file consists of several sections labeled `GlobalSection`, like this:

      Project("{F184B08F-C81C-45F6-A57F-5ABD9991F28F}") = "Project1", "Project1.vbproj", "{8CDD8387-B905-44A8-B5D5-07BB50E05BEA}"
      EndProject
      Global
        GlobalSection(SolutionNotes) = postSolution
        EndGlobalSection
        GlobalSection(SolutionConfiguration) = preSolution
             ConfigName.0 = Debug
             ConfigName.1 = Release
        EndGlobalSection
        GlobalSection(ProjectDependencies) = postSolution
        EndGlobalSection
        GlobalSection(ProjectConfiguration) = postSolution
         {8CDD8387-B905-44A8-B5D5-07BB50E05BEA}.Debug.ActiveCfg = Debug|x86
         {8CDD8387-B905-44A8-B5D5-07BB50E05BEA}.Debug.Build.0 = Debug|x86
         {8CDD8387-B905-44A8-B5D5-07BB50E05BEA}.Release.ActiveCfg = Release|x86
         {8CDD8387-B905-44A8-B5D5-07BB50E05BEA}.Release.Build.0 = Release|x86
        EndGlobalSection
        GlobalSection(ExtensibilityGlobals) = postSolution
        EndGlobalSection
        GlobalSection(ExtensibilityAddIns) = postSolution
        EndGlobalSection
      EndGlobal

  To load a solution, the environment performs the following sequence of tasks:

  1. The environment reads the Global section of the .sln file and processes all sections marked `preSolution`. In this example file, there is one such statement:

         GlobalSection(SolutionConfiguration) = preSolution
              ConfigName.0 = Debug
              ConfigName.1 = Release

     When the environment reads the `GlobalSection('name')` tag, it maps the name to a VSPackage using the registry. The key name should exist in the registry under `[HKLM\<Application ID Registry Root>\SolutionPersistence\AggregateGUIDs]`. The keys' default value is the Package GUID (REG_SZ) of the VSPackage that wrote the entries.

  2. The environment loads the VSPackage, calls `QueryInterface` on the VSPackage for the [IVsPersistSolutionProps](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivspersistsolutionprops) interface, and calls the [ReadSolutionProps](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivspersistsolutionprops.readsolutionprops) method with the data in the section so the VSPackage can store the data. The environment repeats this process for each `preSolution` section.

  3. The environment iterates through the project persistence blocks. In this case, there is one project.

         Project("{F184B08F-C81C-45F6-A57F-5ABD9991F28F}") = "Project1",
         "Project1.vbproj", "{8CDD8387-B905-44A8-B5D5-07BB50E05BEA}"
         EndProject

     This statement contains the unique **project GUID** and the **project type GUID**. This information is used by the environment to **find the project file** or files belonging to the solution, and the VSPackage required for each project. The project GUID is passed to [IVsProjectFactory](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivsprojectfactory) to load the specific VSPackage related to the project, then the project is loaded by the VSPackage. In this case, the VSPackage that is loaded for this project is Visual Basic.

     Each project can persist a **unique project instance ID** so that it can be accessed as needed by other projects in the solution. Ideally, if the solution and projects are under source code control, the **path to the project should be relative to the path to the solution**. When the solution is first loaded, the project files cannot be on the user's machine. By having the project file stored on the server relative to the solution file, it is relatively simple for the project file to be found and copied to the user's machine. It then copies and loads the rest of the files needed for the project.

  4. Based on the information contained in the **project section** of the `.sln` file, the environment loads each project file. The project itself is then responsible for populating the **project hierarchy** and loading any **nested projects**.

  5. After all sections of the `.sln` file are processed, the solution is displayed in Solution Explorer and is ready for modification by the user.

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

## Other Practice

### Set Platform toolset version for msbuild

- Set the environment variable `VisualStudioVersion` to 12.0 tells MSBuild to use the Visual Studio 2013 (V120) toolset.

- Pass the `/p:VisualStudioVersion=14.0` option to MSBuild to use Visual Studio 2015 (V140) toolset.
