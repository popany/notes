# Driver Make

- [Driver Make](#driver-make)
  - [`M` argument](#m-argument)

## `M` argument

    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

Here the make is called within my project's directory. `-C` is make option:

> -C dir, --directory=dir Change to directory dir before reading the makefiles or doing anything else. If multiple -C options are specified, each is interpreted relative to the previous one: -C / -C etc is equivalent to -C /etc. This is typically used with recursive invocations of make.

`M` is not make option but argument passed to it. Since `-C` changes make directory we know that make will read make file in that directory. By inspection of make file in that directory I have discovered what it is going then to do with M:

From make file (named Makefile) in the directory pointed to by `-C` (btw it is kernel build directory):

    # Use make M=dir to specify directory of external module to build
    # Old syntax make ... SUBDIRS=$PWD is still supported
    # Setting the environment variable KBUILD_EXTMOD takes precedence
    ifdef SUBDIRS
      KBUILD_EXTMOD ?= $(SUBDIRS)
    endif

Explanation from Linux Device Drivers, 3rd Edition, Jonathan Corbet et al.:

> This command starts by changing its directory to the one provided with the `-C` option (that is, your kernel source directory). There it finds the kernel's top-level makefile. The M= option causes that makefile to move back into your module source directory before trying to build the modules target.
