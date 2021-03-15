# [The /proc Filesystem](https://www.kernel.org/doc/html/latest/filesystems/proc.html)

- [The /proc Filesystem](#the-proc-filesystem)
  - [Preface](#preface)
    - [0.1 Introduction/Credits](#01-introductioncredits)
    - [0.2 Legal Stuff](#02-legal-stuff)
  - [Chapter 1: Collecting System Information](#chapter-1-collecting-system-information)
    - [1.1 Process-Specific Subdirectories](#11-process-specific-subdirectories)
    - [1.2 Kernel data](#12-kernel-data)
      - [meminfo](#meminfo)
  - [Chapter 2: Modifying System Parameters](#chapter-2-modifying-system-parameters)
  - [Chapter 3: Per-process Parameters](#chapter-3-per-process-parameters)
  - [Chapter 4: Configuring procfs](#chapter-4-configuring-procfs)
  - [Chapter 5: Filesystem behavior](#chapter-5-filesystem-behavior)

## Preface

### 0.1 Introduction/Credits

### 0.2 Legal Stuff

## Chapter 1: Collecting System Information

### 1.1 Process-Specific Subdirectories

### 1.2 Kernel data

#### meminfo

Provides information about distribution and utilization of memory. This varies by architecture and compile options. The following is from a 16GB PIII, which has highmem enabled. You may not have all of these fields.

    > cat /proc/meminfo

    MemTotal:     16344972 kB
    MemFree:      13634064 kB
    MemAvailable: 14836172 kB
    Buffers:          3656 kB
    Cached:        1195708 kB
    SwapCached:          0 kB
    Active:         891636 kB
    Inactive:      1077224 kB
    HighTotal:    15597528 kB
    HighFree:     13629632 kB
    LowTotal:       747444 kB
    LowFree:          4432 kB
    SwapTotal:           0 kB
    SwapFree:            0 kB
    Dirty:             968 kB
    Writeback:           0 kB
    AnonPages:      861800 kB
    Mapped:         280372 kB
    Shmem:             644 kB
    KReclaimable:   168048 kB
    Slab:           284364 kB
    SReclaimable:   159856 kB
    SUnreclaim:     124508 kB
    PageTables:      24448 kB
    NFS_Unstable:        0 kB
    Bounce:              0 kB
    WritebackTmp:        0 kB
    CommitLimit:   7669796 kB
    Committed_AS:   100056 kB
    VmallocTotal:   112216 kB
    VmallocUsed:       428 kB
    VmallocChunk:   111088 kB
    Percpu:          62080 kB
    HardwareCorrupted:   0 kB
    AnonHugePages:   49152 kB
    ShmemHugePages:      0 kB
    ShmemPmdMapped:      0 kB

## Chapter 2: Modifying System Parameters

## Chapter 3: Per-process Parameters

## Chapter 4: Configuring procfs

## Chapter 5: Filesystem behavior















TODO linux /proc filesystem