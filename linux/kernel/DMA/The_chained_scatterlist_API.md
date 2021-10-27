# [The chained scatterlist API](https://lwn.net/Articles/256368/)

- [The chained scatterlist API](#the-chained-scatterlist-api)

Scatter/gather I/O allows the system to perform DMA I/O operations on buffers which are scattered throughout physical memory. Consider, for example, the case of a large (multi-page) buffer created in user space. The application sees a continuous range of virtual addresses, but the physical pages behind those addresses will almost certainly not be adjacent to each other. If that buffer is to be written to a device in a single I/O operation, one of two things must be done: (1) the data must be copied into a physically-contiguous buffer, or (2) the device must be able to work with a list of physical addresses and lengths, grabbing the right amount of data from each segment. Scatter/gather I/O, by eliminating the need to copy data into contiguous buffers, can greatly increase the efficiency of I/O operations while simultaneously getting around the problem that the creation of large, physically-contiguous buffers can be problematic in the first place.





TODO dma aaaaaaaaaaaaaaaaaaaaaaaaaa