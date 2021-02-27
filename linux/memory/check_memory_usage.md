# Check Memory Usage

- [Check Memory Usage](#check-memory-usage)
  - [`man 1 top`](#man-1-top)
    - [Linux Memory Types](#linux-memory-types)
    - [MEMORY Usage](#memory-usage)
    - [3a. DESCRIPTIONS of Fields](#3a-descriptions-of-fields)
  - [`man 1 free`](#man-1-free)
  - [`man 8 vmstat`](#man-8-vmstat)
  - [`man 5 proc`](#man-5-proc)
    - [`/proc/meminfo`](#procmeminfo)

## `man 1 top`

### Linux Memory Types

- Physical memory

  A limited resource where code and data must reside when executed or referenced

- Swap file (optional)

  Where modified (dirty) memory can be saved and later retrieved if too many demands are made on physical memory

- Virtual memory

  A nearly unlimited resource serving the following goals:

  1. abstraction, free from physical memory addresses/limits
  2. isolation, every process in a separate address space
  3. sharing, a single mapping can serve multiple needs
  4. flexibility, assign a virtual address to a file

For individual processes, every memory page is restricted to a single quadrant from the table below:

                                     Private | Shared
                                 1           |          2
            Anonymous  . stack               |
                       . malloc()            |
                       . brk()/sbrk()        | . POSIX shm*
                       . mmap(PRIVATE, ANON) | . mmap(SHARED, ANON)
                      -----------------------+----------------------
                       . mmap(PRIVATE, fd)   | . mmap(SHARED, fd)
          File-backed  . pgms/shared libs    |
                                 3           |          4

|||
|-|-|
Note|Even though program images and shared libraries are considered private to a process, they will be accounted for as shared (SHR) by the kernel.
|||

- Physical memory includes #1 #2 #3 #4

- Virtual memory includes #1 #2 #3 #4

- Swap file includes #1 #2 #3

- The memory in quadrant #4, when modified, acts as its own dedicated swap file. (象限＃4中的内存在修改后充当其自己的专用交换文件)

process level memory values displayed as scalable columns:

- `%MEM`
  
  simply `RES` divided by total physical memory

- `CODE`
  
  the 'pgms' portion of quadrant 3

- `DATA`
  
  the entire quadrant 1 portion of `VIRT` plus all explicit `mmap` file-backed pages of quadrant 3

- `RES`

  anything occupying physical memory which, beginning with Linux-4.5, is the sum of the following three fields:

  - `RSan`

    quadrant 1 pages, which include any former quadrant 3 pages if modified

  - `RSfd`

    quadrant 3 and quadrant 4 pages

  - `RSsh`

    quadrant 2 pages

- `RSlk`

  subset of `RES` which cannot be swapped out (any quadrant)

- `SHR`
  
  subset of RES (excludes 1, includes all 2 & 4, some 3)

- `SWAP`
  
  potentially any quadrant except 4

- `USED`
  
  simply the sum of RES and SWAP

- `VIRT`
  
  everything in-use and/or reserved (all quadrants)

### MEMORY Usage

As a default, Line 1 reflects physical memory, classified as:

    total, free, used and buff/cache

Line 2 reflects mostly virtual memory, classified as:

    total, free, used and avail (which is physical memory)

The avail number on line 2 is an estimation of physical memory available for **starting new applications, without swapping**. Unlike the free field, it attempts to account for readily reclaimable page cache and memory slabs. It is available on kernels 3.14, emulated on kernels 2.6.27+, otherwise the same as free.

In the alternate memory display modes, two abbreviated summary lines are shown consisting of these elements:

                      a    b          c
           GiB Mem : 18.7/15.738   [ ...
           GiB Swap:  0.0/7.999    [ ...

Where: a) is the percentage used; b) is the total available; and c) is one of two visual graphs of those representations.

       In the case of physical memory, the percentage represents the
       total minus the estimated avail noted above.  The `Mem' graph
       itself is divided between used and any remaining memory not
       otherwise accounted for by avail.  See topic 4b. SUMMARY AREA
       Commands and the `m' command for additional information on that
       special 4-way toggle.

### 3a. DESCRIPTIONS of Fields

- `%MEM`  --  Memory Usage (RES)

  A task's currently resident share of available physical memory.

- `CODE`  --  Code Size (KiB)

  The amount of physical memory currently devoted to executable code, also known as the Text Resident Set size or TRS.

- `DATA`  --  Data + Stack Size (KiB)

  The amount of private memory reserved by a process. It is also known as the Data Resident Set or DRS. Such memory may not yet be mapped to physical memory (RES) but will always be included in the virtual memory (VIRT) amount.

- `RES`  --  Resident Memory Size (KiB)

  A subset of the virtual address space (VIRT) representing the non-swapped physical memory a task is currently using. It is also the sum of the `RSan`, `RSfd` and `RSsh` fields.

  It can include private anonymous pages, private pages mapped to files (including program images and shared libraries) plus shared anonymous pages. All such memory is backed by the swap file represented separately under `SWAP`.

  Lastly, this field may also include shared file-backed pages which, when modified, act as a dedicated swap file and thus will never impact `SWAP`.

- `RSan`  --  Resident Anonymous Memory Size (KiB)

  A subset of resident memory (RES) representing private pages not mapped to a file.

- `RSfd`  --  Resident File-Backed Memory Size (KiB)

  A subset of resident memory (RES) representing the implicitly shared pages supporting program images and shared libraries. It also includes explicit file mappings, both private and shared.

- `RSsh`  --  Resident Shared Memory Size (KiB)

  A subset of resident memory (RES) representing the explicitly shared anonymous shm*/mmap pages.

- `RSlk`  --  Resident Locked Memory Size (KiB)

  A subset of resident memory (RES) which cannot be swapped out.

- `SHR`  --  Shared Memory Size (KiB)

A subset of resident memory (RES) that may be used by other processes. It will include shared anonymous pages and shared file-backed pages. It also includes private pages mapped to files representing program images and shared libraries.

- `SWAP`  --  Swapped Size (KiB)

The formerly resident portion of a task's address space written to the swap file when physical memory becomes over committed.

- `USED`  --  Memory in Use (KiB)

This field represents the non-swapped physical memory a task is using (RES) plus the swapped out portion of its address space (SWAP).

- `VIRT`  --  Virtual Memory Size (KiB)

The total amount of virtual memory used by the task. It includes all code, data and shared libraries plus pages that have been swapped out and pages that have been mapped but not used.

## `man 1 free`

free displays the total amount of free and used **physical** and **swap** memory in the system, as well as the **buffers and caches** used by the kernel. The information is **gathered by parsing `/proc/meminfo`**. The displayed columns are:

- `total`

  Total installed memory (`MemTotal` and `SwapTotal` in `/proc/meminfo`)

- `used`

  Used memory (calculated as `total - free - buffers - cache`)

- `free`

  Unused memory (`MemFree` and `SwapFree` in `/proc/meminfo`)

- `shared`

  Memory used (mostly) by tmpfs (Shmem in `/proc/meminfo`)

- `buffers`

  Memory used by kernel buffers (Buffers in `/proc/meminfo`)

- `cache`

  Memory used by the page cache and slabs (`Cached` and `SReclaimable` in `/proc/meminfo`)

- `buff/cache`

  Sum of buffers and cache

- `available`

  Estimation of how much memory is available for starting new applications, without swapping. Unlike the data provided by the cache or free fields, this field takes into account page cache and also that not all reclaimable memory slabs will be reclaimed due to items being in use (`MemAvailable` in `/proc/meminfo`, available on kernels 3.14, emulated on kernels 2.6.27+, otherwise the same as free)

## `man 8 vmstat`


## `man 5 proc`

### `/proc/meminfo`



