# Java

- [Java](#java)
  - [Java Tutorial](#java-tutorial)
    - [Java - Packages](#java---packages)
      - [Creating a Package](#creating-a-package)
      - [The import Keyword](#the-import-keyword)
      - [The Directory Structure of Packages](#the-directory-structure-of-packages)
      - [Set `CLASSPATH` System Variable](#set-classpath-system-variable)
  - [Packaging Programs in JAR Files](#packaging-programs-in-jar-files)
    - [Using JAR Files: The Basics](#using-jar-files-the-basics)
      - [Creating a JAR File](#creating-a-jar-file)
      - [Viewing the Contents of a JAR File](#viewing-the-contents-of-a-jar-file)
      - [Extracting the Contents of a JAR File](#extracting-the-contents-of-a-jar-file)
      - [Updating a JAR File](#updating-a-jar-file)
      - [Running JAR-Packaged Software](#running-jar-packaged-software)
        - [Applets Packaged in JAR Files](#applets-packaged-in-jar-files)
        - [JAR Files as Applications](#jar-files-as-applications)
    - [Working with Manifest Files: The Basics](#working-with-manifest-files-the-basics)
      - [Understanding the Default Manifest](#understanding-the-default-manifest)
      - [Modifying a Manifest File](#modifying-a-manifest-file)
      - [Setting an Application's Entry Point](#setting-an-applications-entry-point)
        - [Setting an Entry Point with the JAR Tool](#setting-an-entry-point-with-the-jar-tool)
      - [Adding Classes to the JAR File's ClasspathAdding Classes to the JAR File's Classpath](#adding-classes-to-the-jar-files-classpathadding-classes-to-the-jar-files-classpath)
      - [Setting Package Version Information](#setting-package-version-information)
      - [Sealing Packages within a JAR File](#sealing-packages-within-a-jar-file)
        - [Sealing JAR Files](#sealing-jar-files)
      - [Enhancing Security with Manifest Attributes](#enhancing-security-with-manifest-attributes)
    - [Signing and Verifying JAR Files](#signing-and-verifying-jar-files)
    - [Using JAR-related APIs](#using-jar-related-apis)
  - [IDE](#ide)

## [Java Tutorial](https://www.tutorialspoint.com/java/index.htm)

### Java - Packages

Packages are used in Java in order to **prevent naming conflicts**, to **control access**, to make **searching/locating and usage** of classes, interfaces, enumerations and annotations easier, etc.

A Package can be defined as a **grouping of related types** (classes, interfaces, enumerations and annotations) providing **access protection** and **namespace management**.

Some of the existing packages in Java are −

* `java.lang` − bundles the fundamental classes

* `java.io` − classes for input, output functions are bundled in this package

Programmers can define their own packages to **bundle group of classes/interfaces**, etc. It is a good practice to group related classes implemented by you so that a programmer can easily determine that the classes, interfaces, enumerations, and annotations are related.

Since the package creates a new namespace there won't be any name conflicts with names in other packages. Using packages, it is easier to provide access control and it is also easier to locate the related classes.

#### Creating a Package

While creating a package, you should choose a name for the package and include a **package statement** along with that name **at the top of every source file** that contains the classes, interfaces, enumerations, and annotation types that you want to **include in the package**.

The package statement should be the **first line** in the source file. There **can be only one package statement** in each source file, and it **applies to all types in the file**.

If a package statement is not used then the class, interfaces, enumerations, and annotation types will be placed in the current **default package**.

To **compile** the Java programs **with package statements**, you have to use `-d` option as shown below.

    javac -d Destination_folder file_name.java

Then a folder with the given package name is created in the specified destination, and the **compiled class files will be placed in that folder**.

#### The import Keyword

If a class wants to use another class in the same package, the package name need not be used. Classes in the same package find each other without any special syntax.

**Note** − A class file can contain any number of import statements. The import statements must appear **after the package statement** and **before the class declaration**.

#### The Directory Structure of Packages

Two major results occur when a class is placed in a package −

* The **name of the package becomes a part of the name of the class**, as we just discussed in the previous section.

* The name of the package **must match the directory structure** where the corresponding bytecode resides.

Here is simple way of managing your files in Java −

Put the **source code** for a class, interface, enumeration, or annotation type in a **text file whose name** is the simple **name of the type** and whose extension is `.java`.

    For example −
    // File Name :  Car.java
    package vehicle;

    public class Car {
       // Class implementation.   
    }

Now, put the **source file in a directory** whose name **reflects the name of the package** to which the class belongs −

    ....\vehicle\Car.java

Now, the qualified class name and pathname would be as follows −

    * Class name → vehicle.Car

    * Path name → vehicle\Car.java (in windows)

In general, a company uses its reversed Internet domain name for its package names.

**Example** − A company's Internet domain name is apple.com, then all its package names would start with com.apple. Each component of the package name corresponds to a subdirectory.

**Example** − The company had a com.apple.computers package that contained a Dell.java source file, it would be contained in a series of subdirectories like this −

    ....\com\apple\computers\Dell.java

At the time of compilation, the **compiler creates a different output file for each** class, interface and enumeration defined in it. The base name of the output file is the name of the type, and its extension is `.class`.
For example −

    // File Name: Dell.java
    package com.apple.computers;

    public class Dell {
    }

    class Ups {
    }

Now, compile this file as follows using -d option −

    $javac -d . Dell.java

The files will be compiled as follows −

    .\com\apple\computers\Dell.class
    .\com\apple\computers\Ups.class

You can import all the classes or interfaces defined in `\com\apple\computers\` as follows −

    import com.apple.computers.*;

Like the `.java` source files, the compiled `.class` files should be in a **series of directories** that **reflect the package name**. However, the path to the `.class` files does not have to be the same as the path to the `.java` source files. You can **arrange your source and class directories separately**, as −

    <path-one>\sources\com\apple\computers\Dell.java

    <path-two>\classes\com\apple\computers\Dell.class

By doing this, it is possible to give access to the classes directory to other programmers without revealing your sources. You also need to manage source and class files in this manner so that the **compiler** and the **Java Virtual Machine** (**JVM**) can find all the types your program uses.

The full path to the classes directory, `<path-two>\classes`, is called the **class path**, and is set with the `CLASSPATH` system variable. Both the compiler and the JVM **construct the path** to your `.class` files by adding the package name to the class path.

Say `<path-two>\classes` is the class path, and the package name is com.apple.computers, then the compiler and JVM will look for `.class` files in `<path-two>\classes\com\apple\computers`.

A class path may **include several paths**. Multiple paths should be separated by a semicolon (Windows) or colon (Unix). By default, the compiler and the JVM search the **current directory** and the JAR file containing the Java platform classes so that these directories are automatically in the class path.

#### Set `CLASSPATH` System Variable

To display the current `CLASSPATH` variable, use the following commands in Windows and UNIX (Bourne shell) −

* In Windows → C:\> set CLASSPATH

* In UNIX → % echo $CLASSPATH

To delete the current contents of the `CLASSPATH` variable, use −

* In Windows → C:\> set CLASSPATH =
* In UNIX → % unset CLASSPATH; export CLASSPATH

To set the `CLASSPATH` variable −

* In Windows → set CLASSPATH = C:\users\jack\java\classes
* In UNIX → % CLASSPATH = /home/jack/java/classes; export CLASSPATH

## [Packaging Programs in JAR Files](https://docs.oracle.com/javase/tutorial/deployment/jar/index.html)

The **Java Archive** (**JAR**) file format enables you to **bundle multiple files** into a single archive file. Typically a JAR file contains the **class files** and **auxiliary resources** associated with **applets** and **applications**.

The JAR file format provides many benefits:

* Security: You can digitally **sign** the contents of a JAR file. Users who recognize your signature can then optionally grant your software security privileges it wouldn't otherwise have.

* Decreased download time: If your applet is bundled in a JAR file, the applet's class files and associated resources can be downloaded to a browser in a single HTTP transaction without the need for opening a new connection for each file.

* Compression: The JAR format allows you to compress your files for efficient storage.

* Packaging for extensions: The extensions framework provides a means by which you can add functionality to the Java core platform, and the JAR file format defines the packaging for extensions. By using the JAR file format, you can turn your software into extensions as well.

* Package Sealing: Packages stored in JAR files can be optionally sealed so that the package can enforce version consistency. Sealing a package within a JAR file means that all classes defined in that package must be found in the same JAR file.

* Package Versioning: A JAR file can hold data about the files it contains, such as **vendor** and **version** information.

* Portability: The mechanism for handling JAR files is a standard part of the Java platform's core API.

### Using JAR Files: The Basics

JAR files are packaged with the **ZIP file format**, so you can use them for tasks such as lossless data compression, archiving, decompression, and archive unpacking. These tasks are among the most common uses of JAR files, and you can realize many JAR file benefits using only these basic features.

Even if you want to take advantage of advanced functionality provided by the JAR file format such as electronic signing, you'll first need to become familiar with the fundamental operations.

To perform basic tasks with JAR files, you use the **Java Archive Tool** provided as part of the **Java Development Kit** (JDK). Because the Java Archive tool is invoked by using the `jar` command, this tutorial refers to it as 'the Jar tool'.

#### Creating a JAR File

The basic format of the command for creating a JAR file is:

    jar cf jar-file input-file(s)

The options and arguments used in this command are:

* The `c` option indicates that you want to create a JAR file.

* The `f` option indicates that you want the output to go to a file rather than to stdout.

* `jar-file` is the name that you want the resulting JAR file to have. You can use any filename for a JAR file. By convention, JAR filenames are given a `.jar` extension, though this is not required.

* The `input-file(s)` argument is a **space-separated list** of one or more files that you want to include in your JAR file. The input-file(s) argument can contain the **wildcard `*` symbol**. If any of the "input-files" are directories, the contents of those directories are added to the JAR archive **recursively**.

The `c` and `f` options can appear in **either order**, but there must **not be any space** between them.

This command will generate a compressed JAR file and place it in the current directory. The command will also generate a **default manifest file** for the JAR archive.

Note:

The metadata in the JAR file, such as the entry names, comments, and contents of the manifest, must be **encoded in UTF8**.

#### Viewing the Contents of a JAR File

The basic format of the command for viewing the contents of a JAR file is:

    jar tf jar-file

Let's look at the options and argument used in this command:

* The `t` option indicates that you want to **view the table of contents** of the JAR file.

* The `f` option indicates that the JAR file whose contents are to be viewed is specified on the command line.

* The `jar-file` argument is the path and name of the JAR file whose contents you want to view.

The `t` and `f` options can appear in either order, but there must not be any space between them.

This command will display the JAR file's table of contents to stdout.

You can optionally add the **verbose option**, `v`, to produce additional information about file sizes and last-modified dates in the output.

#### Extracting the Contents of a JAR File

The basic command to use for extracting the contents of a JAR file is:

    jar xf jar-file [archived-file(s)]

Let's look at the options and arguments in this command:

* The `x` option indicates that you want to extract files from the JAR archive.

* The `f` options indicates that the JAR file from which files are to be extracted is specified on the command line, rather than through `stdin`.

* The `jar-file` argument is the filename (or path and filename) of the JAR file from which to extract files.

* archived-file(s) is an optional argument consisting of a **space-separated list** of the files **to be extracted** from the archive. If this argument is not present, the Jar tool will extract all the files in the archive.

As usual, the order in which the `x` and `f` options appear in the command doesn't matter, but there must not be a space between them.

When extracting files, the Jar tool makes copies of the desired files and writes them to the current directory, reproducing the directory structure that the files have in the archive. The original JAR file remains unchanged.

#### Updating a JAR File

The Jar tool provides a u option which you can use to update the contents of an existing JAR file by modifying its manifest or by adding files.

The basic command for adding files has this format:

    jar uf jar-file input-file(s)

In this command:

* The `u` option indicates that you want to update an existing JAR file.

* The `f` option indicates that the JAR file to update is specified on the command line.

* `jar-file` is the existing JAR file that is **to be updated**.

* `input-file(s)` is a space-delimited list of one or more files that you **want to add** to the JAR file.

Any files already in the archive having the same pathname as a file being added will be **overwritten**.

When creating a new JAR file, you can optionally use the `-C` option to indicate a change of directory. For more information, see the Creating a JAR File section.

#### Running JAR-Packaged Software

Now that you have learned how to create JAR files, how do you actually run the code you packaged? Consider these scenarios:

* Your JAR file contains an **applet** that is to be run inside a **browser**.

* Your JAR file contains an **application** that is to be started from the **command line**.

* Your JAR file contains **code** that you want to use as an **extension**.

This section will cover the first two situations. A separate trail in the tutorial on the [extension mechanism](https://docs.oracle.com/javase/tutorial/ext/index.html) covers the use of JAR files as extensions.

##### Applets Packaged in JAR Files

To start any applet from an `HTML` file for running inside a browser, you use the **applet tag**. For more information, see the [Java Applets](https://docs.oracle.com/javase/tutorial/deployment/applet/index.html) lesson. If the applet is bundled as a JAR file, the only thing you need to do differently is to use the archive parameter to specify the relative path to the JAR file.

As an example, use the `TicTacToe` demo applet. The **applet tag** in the `HTML` file that displays the applet can be marked up like this:

    <applet code=TicTacToe.class 
            width="120" height="120">
    </applet>

If the `TicTacToe` demo was packaged in a JAR file named `TicTacToe.jar`, you can modify the applet tag with the addition of an archive parameter:

    <applet code=TicTacToe.class 
            archive="TicTacToe.jar"
            width="120" height="120">
    </applet>

The **archive parameter** specifies the relative path to the JAR file that contains `TicTacToe.class`. For this example it is assumed that the JAR file and the `HTML` file are in the same directory. If they are not, you must include the JAR file's **relative path** in the archive parameter's value. For example, if the JAR file was one directory below the `HTML` file in a directory called `applets`, the applet tag would look like this:

    <applet code=TicTacToe.class 
            archive="applets/TicTacToe.jar"
            width="120" height="120">
    </applet>

##### JAR Files as Applications

You can run JAR packaged applications with the **Java launcher** (java command). The basic command is:

    java -jar jar-file

The `-jar` flag tells the launcher that the application is packaged in the JAR file format. You **can only specify one** JAR file, which must **contain all of the application-specific code**.

Before you execute this command, make sure that the **runtime environment** has information about **which class** within the JAR file is the application's **entry point**.

To indicate which class is the application's entry point, you must add a **`Main-Class` header** to the JAR file's **manifest**. The header takes the form:

    Main-Class: classname

The header's value, `classname`, is the name of the class that is the application's entry point.

For more information, see the [Setting an Application's Entry Point](https://docs.oracle.com/javase/tutorial/deployment/jar/appman.html) section.

When the `Main-Class` is set in the manifest file, you can run the application from the command line:

    java -jar app.jar

To run the application from the JAR file that is in another directory, you must specify the path of that directory:

    java -jar path/app.jar

### Working with Manifest Files: The Basics

JAR files support a wide range of functionality, including **electronic signing**, **version control**, **package sealing**, and others. What gives a JAR file this versatility? The answer is the JAR file's **manifest**.

The manifest is a **special file** that can contain **information about the files** packaged in a JAR file. By tailoring this "meta" information that the manifest contains, you enable the JAR file to serve a variety of purposes.

#### Understanding the Default Manifest

When you create a JAR file, it automatically receives a **default manifest file**. There can be **only one manifest file** in an archive, and it always has the pathname

    META-INF/MANIFEST.MF

When you create a JAR file, the default manifest file simply contains the following:

    Manifest-Version: 1.0
    Created-By: 1.7.0_06 (Oracle Corporation)

These lines show that a manifest's entries take the form of **"header: value" pairs**. The name of a header is separated from its value by a colon. The default manifest conforms to version `1.0` of the manifest specification and was created by the `1.7.0_06` version of the JDK.

The manifest can also contain **information about the other files** that are packaged in the archive. Exactly what file information should be recorded in the manifest **depends on how you intend to use** the JAR file. The default manifest **makes no assumptions** about what information it should record about other files.

Digest information is not included in the default manifest. To learn more about digests and signing, see the [Signing and Verifying JAR Files](https://docs.oracle.com/javase/tutorial/deployment/jar/signindex.html) lesson.

#### Modifying a Manifest File

You use the `m` command-line option to add custom information to the manifest **during creation** of a JAR file. This section describes the `m` option.

The Jar tool automatically puts a default manifest with the pathname `META-INF/MANIFEST.MF` into any JAR file you create. You can enable special JAR file functionality, such as [package sealing](https://docs.oracle.com/javase/tutorial/deployment/jar/sealman.html), by modifying the default manifest. Typically, modifying the default manifest involves **adding special-purpose headers** to the manifest that allow the JAR file to perform a particular desired function.

To modify the manifest, you must first prepare a **text file** containing the information you wish to add to the manifest. You then use the Jar tool's `m` option to add the information in your file to the manifest.

**Warning**: The text file from which you are creating the manifest must end with a **new line or carriage return**. The last line will not be parsed properly if it does not end with a new line or carriage return.

The basic command has this format:

    jar cfm jar-file manifest-addition input-file(s)

Let's look at the options and arguments used in this command:

* The `c` option indicates that you want to create a JAR file.

* The `m` option indicates that you want to **merge information** from an existing file **into the manifest file** of the JAR file you're creating.

* The `f` option indicates that you want the output to go to a file (the JAR file you're creating) rather than to standard output.

* `manifest-addition` is the name (or path and name) of the existing text file whose contents you want to add to the contents of JAR file's manifest.

* `jar-file` is the name that you want the resulting JAR file to have.

* The `input-file(s)` argument is a space-separated list of one or more files that you want to be placed in your JAR file.

The `m` and `f` options must be in the **same order** as the corresponding arguments.

**Note**: The contents of the manifest must be **encoded in UTF-8**.

#### Setting an Application's Entry Point

If you have an application bundled in a JAR file, you need some way to indicate which class within the JAR file is your application's entry point. You provide this information with the **`Main-Class` header** in the manifest, which has the general form:

    Main-Class: classname

The value `classname` is the name of the class that is your application's entry point.

Recall that the entry point is a class having a method with signature `public static void main(String[] args)`.

After you have set the `Main-Class` header in the manifest, you then **run the JAR file** using the following form of the java command:

    java -jar JAR-name

The main method of the class specified in the `Main-Class` header is executed.

##### Setting an Entry Point with the JAR Tool

The `e` flag (for 'entrypoint') creates or overrides the manifest's `Main-Class` attribute. It can be used while **creating** or **updating** a JAR file. Use it to specify the application entry point without editing or creating the manifest file.

For example, this command creates `app.jar` where the `Main-Class` attribute value in the manifest is set to MyApp:

    jar cfe app.jar MyApp MyApp.class

You can directly invoke this application by running the following command:

    java -jar app.jar

If the entrypoint class name is in a package it may use a '.' (dot) character as the delimiter. For example, if `Main.class` is in a package called foo the entry point can be specified in the following ways:

    jar cfe Main.jar foo.Main foo/Main.class

#### Adding Classes to the JAR File's ClasspathAdding Classes to the JAR File's Classpath

You may need to **reference classes in other JAR files** from within a JAR file.

For example, in a typical situation an applet is bundled in a JAR file whose **manifest references a different JAR file** (or several different JAR files) that serves as utilities for the purposes of that applet.

You **specify classes to include** in the `Class-Path` header field in the manifest file of an applet or application. The `Class-Path` header takes the following form:

    Class-Path: jar1-name jar2-name directory-name/jar3-name

By using the `Class-Path` header in the manifest, you can avoid having to specify a long `-classpath` flag when invoking Java to run the your application.

**Note**: The `Class-Path` header points to classes or JAR files on the **local network**, not JAR files within the JAR file or classes accessible over Internet protocols. To load classes in **JAR files within a JAR file** into the class path, you must **write custom code** to load those classes. For example, if `MyJar.jar` contains another JAR file called `MyUtils.jar`, you cannot use the `Class-Path` header in `MyJar.jar`'s manifest to load classes in `MyUtils.jar` into the class path.

#### Setting Package Version Information

You may need to include package version information in a JAR file's manifest.

One set of such headers can be assigned to **each package**. The **`versioning` headers** should appear directly beneath the **`Name` header** for the package. This example shows all the `versioning` headers:

    Name: java/util/
    Specification-Title: Java Utility Classes
    Specification-Version: 1.2
    Specification-Vendor: Example Tech, Inc.
    Implementation-Title: java.util
    Implementation-Version: build57
    Implementation-Vendor: Example Tech, Inc.

For more information about package `version` headers, see the [Package Versioning specification](https://docs.oracle.com/javase/8/docs/technotes/guides/versioning/spec/versioning2.html#wp89936).

#### Sealing Packages within a JAR File

**Packages within JAR files** can be optionally sealed, which **means that all classes defined in that package must be archived in the same JAR file**. You might want to seal a package, for example, to ensure version consistency among the classes in your software.

You **seal a package** in a JAR file by adding the **`Sealed` header** in the manifest, which has the general form:

    Name: myCompany/myPackage/
    Sealed: true

The value `myCompany/myPackage/` is the **name of the package** to seal.

Note that the package name **must end with a "/"**.

##### Sealing JAR Files

If you want to guarantee that all classes in a package come **from the same code source**, use **JAR sealing**. A sealed JAR specifies that **all packages defined by that JAR are sealed** unless overridden on a per-package basis.

To seal a JAR file, use the `Sealed` manifest header with the value true. For example,

    Sealed: true

specifies that all packages in this archive are sealed unless explicitly overridden for particular packages with the Sealed attribute in a manifest entry.

#### Enhancing Security with Manifest Attributes

### Signing and Verifying JAR Files

### Using JAR-related APIs

## IDE

idea
