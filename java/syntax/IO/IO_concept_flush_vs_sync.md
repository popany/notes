# [I/O concept flush vs sync](https://stackoverflow.com/questions/4072878/i-o-concept-flush-vs-sync)

- [I/O concept flush vs sync](#io-concept-flush-vs-sync)

In Java, the `flush()` method is used in output streams and writers to ensure that buffered data is written out. However, according to the Javadocs:

> If the intended destination of this stream is an abstraction provided by the underlying operating system, for example a file, then flushing the stream guarantees only that bytes previously written to the stream are passed to the operating system for writing; it does not guarantee that they are actually written to a physical device such as a disk drive.

On the other hand, `FileDescriptor.sync()` can be used to ensure that data buffered by the OS is written to the physical device (disk). This is the same as the `sync` call in Linux / POSIX.

If your Java application really needs to ensure that data is physically written to disk, you may need to `flush` and `sync`, e.g.:

    FileOutputStream out = new FileOutputStream(filename);
    
    [...]
    
    out.flush();
    out.getFD().sync();
