# DMA

- [DMA](#dma)
  - [Review Input Transfer](#review-input-transfer)
  - [The Generic DMA Layer](#the-generic-dma-layer)
    - [DMA mappings](#dma-mappings)
  - [Bus address](#bus-address)
  - [Types of DMA mappings](#types-of-dma-mappings)

- DMA is the hardware mechanism that allows peripheral components to transfer their I/O data directly to and from main memory without the need to involve the system processor.

## Review Input Transfer

- Input transfer can be triggered in two ways

  - software asks for data, steps:

    1. When a process calls read, the driver method allocates a DMA buffer and instructs the hardware to transfer its data into that buffer. The process is put to sleep.

    2. The hardware writes data to the DMA buffer and raises an interrupt when it's done.

    3. The interrupt handler gets the input data, acknowledges the interrupt, and awakens the process, which is now able to read data.

  - hardware asynchronously pushes data, steps:

    1. The hardware raises an interrupt to announce that new data has arrived.

    2. The interrupt handler allocates a buffer and tells the hardware where to transfer its data.

    3. The peripheral device writes the data to the buffer and raises another interrupt when it's done.

    4. The handler dispatches the new data, wakes any relevant process, and takes care of housekeeping.

  A variant of the asynchronous approach is often seen with network cards. These cards often expect to see a **circular buffer** (often called a **DMAring buffer**) established in **memory shared with the processor**; each incoming packet is placed in the next available buffer in the ring, and an interrupt is signaled. The driver then passes the network packets to the rest of the kernel and places a new DMA buffer in the ring.

  The processing steps in all of these cases emphasize that efficient DMA handling **relies on interrupt reporting**. While it is possible to implement DMA with a polling driver, it **wouldn't make sense**, because a polling driver would waste the performance benefits that DMA offers over the easier processor-driven I/O.

  Another relevant item introduced here is the DMA buffer. DMA requires **device drivers to allocate** one or more special buffers suited to DMA. Note that many drivers allocate their buffers at initialization time and use them until shutdown - the word allocate in the previous lists, therefore, means "get hold of a previously allocated buffer".

## The Generic DMA Layer

- DMA operations, in the end, come down to allocating a buffer and passing bus addresses to your device.

### DMA mappings

- A DMA mapping is a combination of allocating a DMA buffer and generating an address for that buffer that is accessible by the device.

- Bounce buffer

  - Setting up a useful address for the device may also, in some cases, require the establishment of a bounce buffer.

  - Bounce buffers are created when a driver attempts to perform DMA on an address that is not reachable by the peripheral device - a high-memory address, for example.

  - Data is then copied to and from the bounce buffer as needed. Needless to say, use of bounce buffers can slow things down, but sometimes there is no alternative.

- DMA mappings must also address the issue of cache coherency.

- The DMA mapping sets up a new type, `dma_addr_t`, to represent **bus addresses**. Variables of type `dma_addr_t` should be treated as opaque by the driver; the only allowable operations are to pass them to the DMA support routines and to the device itself. As a bus address, `dma_addr_t` may lead to unexpected problems if used directly by the CPU.

## Bus address

- From a device's point of view, DMA uses the bus address space, but it may be restricted to a subset of that space.

- If the device supports DMA, the driver sets up a buffer using `kmalloc()` or a similar interface, which returns a virtual address (X). The virtual memory system maps X to a physical address (Y) in system RAM. The driver can use virtual address X to access the buffer, but the device itself cannot because DMA doesn't go through the CPU virtual memory system.

- In some simple systems, the device can do DMA directly to physical address Y.  But in many others, there is IOMMU hardware that translates DMA addresses to physical addresses, e.g., it translates Z to Y. This is part of the reason for the DMA API: the driver can give a virtual address X to an interface like `dma_map_single()`, which sets up any required IOMMU mapping and returns the DMA address Z. The driver then tells the device to do DMA to Z, and the IOMMU maps it to the buffer at address Y in system RAM.

- So that Linux can use the dynamic DMA mapping, it needs some help from the drivers, namely it has to take into account that DMA addresses should be mapped only for the time they are actually used and unmapped after the DMA transfer.

## Types of DMA mappings

There are two types of DMA mappings:

- Consistent DMA mappings

  - which are usually mapped at driver initialization, unmapped at the end and for which the hardware should guarantee that the **device** and the **CPU** can **access the data in parallel** and will see updates made by each other without any explicit software flushing.

- Streaming DMA mappings

  - which are usually mapped for one DMA transfer, unmapped right after it (unless you use `dma_sync_*`) and for which hardware can optimize for sequential accesses.




