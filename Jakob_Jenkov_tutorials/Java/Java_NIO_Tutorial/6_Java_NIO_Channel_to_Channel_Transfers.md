# [Java NIO Channel to Channel Transfers](http://tutorials.jenkov.com/java-nio/channel-to-channel-transfers.html)

- [Java NIO Channel to Channel Transfers](#java-nio-channel-to-channel-transfers)
  - [transferFrom()](#transferfrom)
  - [transferTo()](#transferto)

In Java NIO you can transfer data directly from one channel to another, if one of the channels is a `FileChannel`. The `FileChannel` class has a `transferTo()` and a `transferFrom()` method which does this for you.

## transferFrom()

The `FileChannel.transferFrom()` method transfers data from a source channel into the `FileChannel`. Here is a simple example:

    RandomAccessFile fromFile = new RandomAccessFile("fromFile.txt", "rw");
    FileChannel      fromChannel = fromFile.getChannel();

    RandomAccessFile toFile = new RandomAccessFile("toFile.txt", "rw");
    FileChannel      toChannel = toFile.getChannel();

    long position = 0;
    long count    = fromChannel.size();

    toChannel.transferFrom(fromChannel, position, count);

The parameters `position` and `count`, tell where in the destination file to start writing (`position`), and how many bytes to transfer maximally (`count`). If the source channel has fewer than count bytes, less is transfered.

Additionally, some `SocketChannel` implementations may transfer only the data the `SocketChannel` has ready in its internal buffer here and now - even if the `SocketChannel` may later have more data available. Thus, it **may not transfer the entire data** requested (`count`) from the `SocketChannel` into `FileChannel`.

## transferTo()

The `transferTo()` method transfer from a `FileChannel` into some other channel. Here is a simple example:

    RandomAccessFile fromFile = new RandomAccessFile("fromFile.txt", "rw");
    FileChannel      fromChannel = fromFile.getChannel();

    RandomAccessFile toFile = new RandomAccessFile("toFile.txt", "rw");
    FileChannel      toChannel = toFile.getChannel();

    long position = 0;
    long count    = fromChannel.size();

    fromChannel.transferTo(position, count, toChannel);

Notice how similar the example is to the previous. The only real difference is the which `FileChannel` object the method is called on. The rest is the same.

The issue with `SocketChannel` is also present with the `transferTo()` method. The `SocketChannel` implementation may only transfer bytes from the `FileChannel` until the send buffer is full, and then stop.
