# Zero-copy

- [Zero-copy](#zero-copy)
  - [wikipedia - Zero-copy](#wikipedia---zero-copy)
    - [Principle](#principle)
    - [Hardware implementations](#hardware-implementations)

## wikipedia - [Zero-copy](https://en.wikipedia.org/wiki/Zero-copy)

"Zero-copy" describes computer operations in which the CPU does not perform the task of copying data from one memory area to another. This is frequently used to save CPU cycles and memory bandwidth when transmitting a file over a network.

### Principle

Zero-copy versions of operating system elements, such as device drivers, file systems, and network protocol stacks, greatly increase the performance of certain application programs and more efficiently utilize system resources. Performance is enhanced by allowing the CPU to move on to other tasks while data copies proceed in parallel in another part of the machine. Also, zero-copy operations reduce the number of time-consuming mode switches between user space and kernel space. System resources are utilized more efficiently since using a sophisticated CPU to perform extensive copy operations, which is a relatively simple task, is wasteful if other simpler system components can do the copying.

As an example, reading a file and then sending it over a network the traditional way requires two data copies and two context switches per read/write cycle. One of those data copies uses the CPU. Sending the same file via zero copy reduces the context switches to two and eliminates all CPU data copies.[[1]](https://www.linuxjournal.com/article/6345?page=0,0)

Zero-copy protocols are especially important for high-speed networks in which the capacity of a network link approaches or exceeds the CPU's processing capacity. In such a case the CPU spends nearly all of its time copying transferred data, and thus becomes a bottleneck which limits the communication rate to below the link's capacity. A rule of thumb used in the industry is that roughly one CPU clock cycle is needed to process one bit of incoming data.

### Hardware implementations

An early implementation was IBM OS/360 where a program can instruct the channel subsystem to read blocks of data from one file or device into a buffer and write to another from the same buffer without moving the data.

Techniques for creating zero-copy software include the use of direct memory access (DMA)-based copying and memory-mapping through an memory management unit (MMU). These features require specific hardware support and usually involve particular memory alignment requirements.

A newer approach used by the Heterogeneous System Architecture (HSA) facilitates the passing of pointers between the CPU and the GPU and also other processors. This requires a unified address space for the CPU and the GPU.





