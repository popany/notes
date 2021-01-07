# [GNU Binutils](https://www.gnu.org/software/binutils/)

- [GNU Binutils](#gnu-binutils)
  - [Documentation for binutils](#documentation-for-binutils)
  - [GNU Binary Utilities](#gnu-binary-utilities)
    - [1 ar](#1-ar)
      - [1.1 Controlling ar on the Command Line](#11-controlling-ar-on-the-command-line)

## [Documentation for binutils](https://sourceware.org/binutils/docs-2.35/)

## [GNU Binary Utilities](https://sourceware.org/binutils/docs-2.35/binutils/)

### [1 ar](https://sourceware.org/binutils/docs-2.35/binutils/ar.html#ar)

    ar [-]p[mod] [--plugin name] [--target bfdname] [--output dirname] [relpos] [count] archive [member…]
    ar -M [ <mri-script ]

The GNU `ar` program creates, modifies, and extracts from archives. An archive is a single file holding a collection of other files in a structure that makes it possible to retrieve the original individual files (called members of the archive).

`ar` is considered a binary utility because archives of this sort are most often used as **libraries** holding commonly needed subroutines.

`ar` creates an index to the symbols defined in relocatable object modules in the archive when you specify the modifier '`s`'. Once created, this index is updated in the archive whenever `ar` makes a change to its contents (save for the '`q`' update operation). An archive with such an index speeds up linking to the library, and allows routines in the library to call each other without regard to their placement in the archive.

You may use '`nm -s`' or '`nm --print-armap`' to list this index table. If an archive lacks the table, another form of `ar` called `ranlib` can be used to add just the table.

GNU `ar` can optionally create a thin archive, which contains a symbol index and **references to the original** copies of the member files of the archive. This is useful for building libraries for use within a local build tree, where the relocatable objects are expected to remain available, and copying the contents of each object would only waste time and space.

An archive can either be thin or it can be normal. It cannot be both at the same time. Once an archive is created its format cannot be changed without first deleting it and then creating a new archive in its place.

Thin archives are also flattened, so that adding one thin archive to another thin archive does not nest it, as would happen with a normal archive. Instead the elements of the first archive are added individually to the second archive.

The paths to the elements of the archive are stored relative to the archive itself.

#### [1.1 Controlling ar on the Command Line](https://sourceware.org/binutils/docs-2.35/binutils/ar-cmdline.html#ar-cmdline)

    ar [-X32_64] [-]p[mod] [--plugin name] [--target bfdname] [--output dirname] [relpos] [count] archive [member…]





