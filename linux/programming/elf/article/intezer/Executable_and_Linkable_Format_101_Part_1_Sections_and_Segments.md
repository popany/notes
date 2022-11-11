# [Executable and Linkable Format 101 - Part 1 Sections and Segments](https://www.intezer.com/blog/research/executable-linkable-format-101-part1-sections-segments/)

- [Executable and Linkable Format 101 - Part 1 Sections and Segments](#executable-and-linkable-format-101---part-1-sections-and-segments)
  - [Overview of The Executable and Linkable Format](#overview-of-the-executable-and-linkable-format)
  - [ELF Header](#elf-header)
  - [Sections](#sections)
  - [Segments](#segments)
  - [Sections and Segments](#sections-and-segments)

## Overview of The Executable and Linkable Format

The Executable and Linkable Format, also known as ELF, is the generic file format for executables in Linux systems. Generally speaking, ELF files are composed of three major components:

- ELF Header

- Sections

- Segments

Each of these elements play a different role in the **linking/loading** process of ELF executables. We'll discuss each of these components and the relationship between segments and sections. First, let's become familiar with the structure of each constituent:

## ELF Header

    readelf -h <executable>

## Sections

Sections comprise all information needed for linking a target object file in order to build a working executable. (It's important to highlight that **sections are needed on linktime but they are not needed on runtime**.) In every ELF executable, there is a **Section Header Table**. This table is an array of `Elfxx_Shdr` structures, having one `Elfxx_Shdr` entry per section.

    readelf -S <executable>

## Segments

Segments, which are commonly known as **Program Headers**, break down the structure of an [ELF binary](https://www.intezer.com/blog/malware-analysis/elf-malware-analysis-101-initial-analysis/) into suitable chunks to prepare the executable to be loaded into memory. In contrast with Section Headers, **Program Headers are not needed on linktime**.

On the other hand, similarly to Section Headers, every ELF binary contains a Program Header Table which comprises of a single `Elfxx_Phdr` structure per existing segment.

...

Something important to highlight about segments is that only `PT_LOAD` segments get loaded into memory. Therefore, every other segment is mapped within the memory range of one of the `PT_LOAD` segments.

    readelf -l <executable>

## Sections and Segments

In contrast from other File formats, ELF files are composed of sections and segments. As previously mentioned, sections gather all needed information to link a given object file and build an executable, while Program Headers split the executable into segments with different attributes, which will eventually be loaded into memory.

In order to understand the relationship between Sections and Segments, we can picture segments as a tool to make the linux loader's life easier, as they **group sections by attributes into single segments** in order to make the loading process of the executable more efficient, instead of loading each individual section into memory.
