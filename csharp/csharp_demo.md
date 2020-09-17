# c# demo

- [c# demo](#c-demo)
  - [DateTime](#datetime)
    - [How to: Display Milliseconds in Date and Time Values](#how-to-display-milliseconds-in-date-and-time-values)
  - [IO](#io)
    - [How to: Write text to a file](#how-to-write-text-to-a-file)
  - [Process](#process)
    - [Asynchronous read stderr](#asynchronous-read-stderr)

## DateTime

### [How to: Display Milliseconds in Date and Time Values](https://docs.microsoft.com/en-us/dotnet/standard/base-types/how-to-display-milliseconds-in-date-and-time-values)

    string dateString = "7/16/2008 8:32:45.126 AM";

    DateTime dateValue = DateTime.Parse(dateString);

    Console.WriteLine("Date and Time with Milliseconds: {0}", dateValue.ToString("MM/dd/yyyy hh:mm:ss.fff tt")); 

    // output:
    // Date and Time with Milliseconds: 07/16/2008 08:32:45.126 AM

## IO

### [How to: Write text to a file](https://docs.microsoft.com/en-us/dotnet/api/system.datetime.now?view=netframework-4.8)

    using (StreamWriter outputFile = new StreamWriter("hello_world.txt"))
    {
        outputFile.WriteLine("Hello World!");
    }

append to file

    using (StreamWriter outputFile = new StreamWriter("hello_world.txt", true))
    {
        outputFile.WriteLine("Hello World!");
    }

## Process

### Asynchronous read stderr

[Process.ErrorDataReceived Event](https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.process.errordatareceived?view=netframework-4.5)

[Process.BeginErrorReadLine Method](https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.process.beginerrorreadline?view=netframework-4.5#System_Diagnostics_Process_BeginErrorReadLine)
