# ld

- [ld](#ld)
  - [Command Line Options](#command-line-options)

## [Command Line Options](https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_chapter/ld_2.html#SEC3)

- `--whole-archive`

  For each archive mentioned on the command line after the `--whole-archive` option, include every object file in the archive in the link, rather than searching the archive for the required object files. This is normally used to turn an archive file into a shared library, forcing every object to be included in the resulting shared library. This option may be used more than once.



