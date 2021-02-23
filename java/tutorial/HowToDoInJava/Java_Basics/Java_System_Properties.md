# [Java System Properties](https://howtodoinjava.com/java/basics/java-system-properties/)

- [Java System Properties](#java-system-properties)
  - [1. Java System Properties List](#1-java-system-properties-list)
    - [JRE System Properties](#jre-system-properties)
    - [IO System Properties](#io-system-properties)
    - [User Properties](#user-properties)
    - [OS Properties](#os-properties)
  - [2. Getting System Property](#2-getting-system-property)
    - [Example 1: Java example to get the list of all system properties](#example-1-java-example-to-get-the-list-of-all-system-properties)
    - [Example 2: Java example to a system property value by its key](#example-2-java-example-to-a-system-property-value-by-its-key)
  - [3. Set System Property](#3-set-system-property)
    - [Example 3: How to set system property in java using command line](#example-3-how-to-set-system-property-in-java-using-command-line)
    - [Example 4: How to set system property using Java code](#example-4-how-to-set-system-property-using-java-code)

Java maintains a set of system properties for its operations. Each java system property is a key-value (String-String) pair. For example, one such system property is “java.version”=”1.7.0_09“.

Please note that access to system properties can be restricted by the Java security manager and policy file. By default, Java programs have unrestricted access to all the system properties.

We can retrieve all the system properties via `System.getProperties()` or we can also retrieve individual property via `System.getProperty(key)` method.

## 1. Java System Properties List

### JRE System Properties

|||
|-|-|
`java.home`|JRE home directory, e.g., “C:\Program Files\Java\jdk1.7.0_09\jre“.
`java.library.path`|JRE library search path for search native libraries. It is usually but not necessarily taken from the environment variable PATH.
`java.class.path`|JRE classpath e.g., '.' (dot – used for current working directory).
`java.ext.dirs`|JRE extension library path(s), e.g, “C:\Program Files\Java\jdk1.7.0_09\jre\lib\ext;C:\Windows\Sun\Java\lib\ext“.
`java.version`|JDK version, e.g., 1.7.0_09.
`java.runtime.version`|JRE version, e.g. 1.7.0_09-b05.
|||

### IO System Properties

|||
|-|-|
`file.separator`|symbol for file directory separator such as 'd:\test\test.java'. The default is '\' for windows or '/' for Unix/Mac.
`path.separator`|symbol for separating path entries, e.g., in `PATH` or `CLASSPATH`. The default is ';' for windows or ':' for Unix/Mac.
`line.separator`|symbol for end-of-line (or new line). The default is "\r\n" for windows or "\n" for Unix/Mac OS X.
|||

### User Properties

|||
|-|-|
`user.name`|the user’s name.
`user.home`|the user’s home directory.
`user.dir`|the user’s current working directory.
|||

### OS Properties

|||
|-|-|
`os.name`|the OS’s name, e.g., “Windows 7“.
`os.version`|the OS’s version, e.g., “6.1“.
`os.arch`|the OS’s architecture, e.g., “x86“.
|||

## 2. Getting System Property

As discussed earlier, You can get the list of all the system properties via `System.getProperties()` or also retrieve individual property via `System.getProperty(key)`.

### Example 1: Java example to get the list of all system properties

    import java.util.Properties;
    
    public class PrintSystemProperties 
    {
       public static void main(String[] a) 
       {
          // List all System properties
          Properties pros = System.getProperties();
          pros.list(System.out);
       }
    }

### Example 2: Java example to a system property value by its key

    import java.util.Properties;
    public class PrintSystemProperties 
    {
       public static void main(String[] a) 
       {
          // List all System properties
          Properties pros = System.getProperties();
     
          // Get a particular System property given its key
          // Return the property value or null
          System.out.println(System.getProperty("java.home"));
          System.out.println(System.getProperty("java.library.path"));
          System.out.println(System.getProperty("java.ext.dirs"));
          System.out.println(System.getProperty("java.class.path"));
       }
    }

## 3. Set System Property

In Java, you can set a custom system property either **from the command line** or **from the application code** itself.

### Example 3: How to set system property in java using command line

In given example, the application will be able to access the property with key `custom_key`. It’s value will be available as `custom_value`.

    java -Dcustom_key="custom_value" application_launcher_class

### Example 4: How to set system property using Java code

Similar to above example, after executing this code, the application will be able to access the property with key `custom_key`. It’s value will be available as `custom_value`.

    System.setProperty("custom_key", "custom_value");
