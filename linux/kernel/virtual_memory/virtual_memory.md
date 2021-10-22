# Virtual Memory

- [Virtual Memory](#virtual-memory)
  - [Kernel address](#kernel-address)
  - [Memory Map](#memory-map)
    - [VMA](#vma)
    - [`struct mm_struct`](#struct-mm_struct)
    - [`mmap`](#mmap)
  - [Derict I/O](#derict-io)
  - [User space memory access from the Linux kernel](#user-space-memory-access-from-the-linux-kernel)
    - [Dereference pointers to user space](#dereference-pointers-to-user-space)

## Kernel address

- The Linux system deals with several types of addresses, each with its own semantics. Unfortunately, the kernel code is not always very clear on exactly which type of address is being used in each situation, so the programmer must be careful.

- High memory
  
  High memory is the **part of physical memory** in a computer which is not directly mapped by the page tables of its operating system kernel.

  Some operating system kernels, such as Linux, divide their virtual address space into two regions, devoting the larger to user space and the smaller to the kernel. In current 32-bit x86 computers, this commonly (although does not have to, as this is a configurable option) takes the form of a 3GB/1GB split of the 4 GB address space, so kernel virtual addresses start at 0xC0000000 and go to 0xFFFFFFFF. The lower 896 MB, from 0xC0000000 to 0xF7FFFFFF, is directly mapped to the kernel physical address space, and the remaining 128 MB, from 0xF8000000 to 0xFFFFFFFF, is used on demand by the kernel to be mapped to **high memory**. When in user mode, translations are only effective for the first region, thus protecting the kernel from user programs, but when in kernel mode, translations are effective for both regions, thus giving the kernel an easy way to refer to the buffers of processes — it just uses the process' own mappings.

  However, if the kernel needs to refer to physical memory for which a **userspace translation has not already been provided**, it has only 1 GB (for example) of virtual memory to use. On computers with a lot of physical memory, this can mean that there exists memory that the kernel cannot refer to directly — this is called high memory. When the kernel wishes to address high memory, it **creates a mapping on the fly** and destroys the mapping when done, which incurs a performance penalty.

- Kernel logical addresses

  Logical addresses use the hardware's native pointer size and, therefore, may be unable to address all of physical memory on heavily equipped 32-bit systems. Logical addresses are usually stored in variables of type `unsigned long` or `void *`. Memory returned from `kmalloc` has a kernel logical address.

  The Linux kernel maps most of the virtual address space that belongs to the kernel to perform 1:1 mapping with an offset of the first part of physical memory. (slightly less then for 1Gb for 32bit x86, can be different for other processors or configurations). For example, for kernel code on x86 address 0xc00000001 is mapped to physical address 0x1.

  This is called logical mapping - a 1:1 mapping (with an offset) that allows the kernel to access most of the physical memory of the machine.

  But this is not enough - sometime we have more then 1Gb physical memory on a 32bit machine, sometime we want to reference non contiguous physical memory blocks as contiguous to make thing simple, sometime we want to map memory mapped IO regions which are not RAM.

  For this, the kernel keeps a region at the top of its virtual address space where it does a "random" page to page mapping. The mapping there do not follow the 1:1 pattern of the logical mapping area. This is what we call the **virtual mapping**.

  It is important to add that on many platforms (x86 is an example), both the logical and virtual mapping are done using the same hardware mechanism (TLB controlling virtual memory). In many cases, the "logical mapping" is actually done using virtual memory facility of the processor, so this can be a little confusing. The difference therefore is the pattern according to which the mapping is done: 1:1 for logical, something random for virtual.

- Kernel virtual addresses

  Kernel virtual addresses are similar to logical addresses in that they are a mapping from a kernel-space address to a physical address. Kernel virtual addresses do not necessarily have the linear, one-to-one mapping to physical addresses that characterize the logical address space, however. All logical addresses are kernel virtual addresses, but many kernel virtual addresses are not logical addresses. For example, memory allocated by `vmalloc` has a virtual address (but no direct physical mapping). The `kmap` function also returns virtual addresses. Virtual addresses are usually stored in pointer variables.

- If you have a logical address, the macro `__pa()` (defined in <asm/page.h>) returns its associated physical address. Physical addresses can be mapped back to logical addresses with `__va()`, but only for low-memory pages.

- Before accessing a specific high-memory page, the kernel must set up an explicit virtual mapping to make that page available in the **kernel's address space**. Thus, many kernel data structures must be placed in low memory; high memory tends to be reserved for user-space process pages.

- Kernel logical address maps low-memory, Kernel virtual address maps high-memory

- Because the kernel address space is limited, one-to-one mapping to physical addresses cannot be met, so kernel virtual addresses are required.

## Memory Map

- Mapping a device means associating a range of user-space addresses to device memory. Whenever the program reads or writes in the assigned address range, it is actually accessing the device.

- Not every device lends itself to the `mmap` abstraction; it makes no sense, for instance, for serial ports and other stream-oriented devices

### VMA

- The virtual memory area (VMA) is the kernel data structure used to manage distinct regions of a process's address space.

- `vm_area_struct`

  - When a user-space process calls `mmap` to map device memory into its address space, the system responds by **creating a new VMA** to represent that mapping.

  - A driver that supports `mmap` (and, thus, that implements the `mmap` method) needs to help that process by completing the initialization of that VMA.

- `vm_operations_struct` field of `vm_area_struct`

  A set of functions that the kernel may invoke to operate on this memory area. Its presence indicates that the memory area is a kernel "object", like the `struct file` we have been using throughout the book.

- functions in `vm_operations_struct`

  - `void (*open)(struct vm_area_struct *vma);`

  - `void (*close)(struct vm_area_struct *vma);`

  - `struct page *(*nopage)(struct vm_area_struct *vma, unsigned long address, int *type);`

  - `int (*populate)(struct vm_area_struct *vm, unsigned long address, unsigned long len, pgprot_t prot, unsigned long pgoff, int nonblock);`

### `struct mm_struct`

- process memory map structure, which holds all of the other data structures together.

- Each process in the system (with the exception of a few kernel-space helper threads) has a `struct mm_struct` (defined in `<linux/sched.h>`) that contains the process's list of virtual memory areas, page tables, and various other bits of memory management housekeeping information, along with a semaphore (`mmap_sem`) and a spinlock (`page_table_lock`).

- The pointer to this structure is found in the task structure; in the rare cases where a driver needs to access it, the usual way is to use `current->mm`. Note that the memory management structure can be shared between processes; the Linux implementation of threads works in this way, for example.

### `mmap`

- Therefore, much of the work has been done by the kernel; to implement `mmap`, the driver only has to build suitable page tables for the address range and, if necessary, replace `vma->vm_ops` with a new set of operations

- Reserved pages are locked in memory and are the only ones that can be safely mapped to user space

## Derict I/O

- Allows non-cached I/O operations to be applied directly to the userspace

- Perform I/O directly to or from a user-space buffer

- implementing direct I/O in a char driver is usually unnecessary and can be hurtful

- Block and network drivers need not worry about implementing direct I/O at all; in both cases, higher-level code in the kernel sets up and makes use of direct I/O when it is indicated, and driver-level code need not even know that direct I/O is being performed

## User space memory access from the Linux kernel

- kernel itself resides in one address space, and each process resides in its own address space

- kernel APIs for manipulating user memory

  |Function|Description|
  |-|-|
  access_ok|Checks the validity of the user space memory pointer
  get_user|Gets a simple variable from user space
  put_user|Puts a simple variable to user space
  clear_user|Clears, or zeros, a block in user space
  copy_to_user|Copies a block of data from the kernel to user space
  copy_from_user|Copies a block of data from user space to the kernel
  strnlen_user|Gets the size of a string buffer in user space
  strncpy_from_user|Copies a string from user space into the kernel
  |

### Dereference pointers to user space

- How accessing user memory from a kernel context works depends on the operating system. The kernel typically has a (virtual) address space of its own. This can be a completely independent address space from user process spaces (e.g. 32-bit OSX) or it can be in a special region (the high/low address split in many OSes). In the **high/low model**, the kernel **can typically dereference pointers to user space** while it is **executing in the context of that process**. In the general case, the kernel can explicitly look up the underlying **physical memory** the user virtual address refers to, and then **map that into its own virtual address space**.

- As user space can maliciously supply bad pointers, they must never be used by the kernel without first checking for validity. This and the subsequent access must be atomic with regard to the user process's memory map, otherwise the process could `munmap()` the range in the time between the kernel's pointer validity check and actually reading/writing the memory. For this reason, most kernels have helper functions that are essentially a safe memcpy between user- and kernel space that is guaranteed to be safe or return an error in the case of an invalid pointer.

- In any case, the kernel code has to do all of this explicitly, there is nothing "automatic" about it. Your syscall may pass through layers of abstraction that do automate this before reaching your kernel module, of course.

- Modern hardware supports SMAP (supervisor mode access prevention) which is designed to prevent accidental/malicious dereferencing of pointers to user address space from the kernel. Various operating systems have started enabling this feature, so in those cases you absolutely must go through the special kernel functions for accessing user memory.
