# rpath

- [rpath](#rpath)
  - [Resources](#resources)
    - [Understanding RPATH (with CMake)](#understanding-rpath-with-cmake)
    - [CMake RPATH handling](#cmake-rpath-handling)
  - [cmake variables](#cmake-variables)
    - [CMAKE_INSTALL_RPATH](#cmake_install_rpath)
    - [INSTALL_RPATH](#install_rpath)
  - [Related Question](#related-question)

## Resources

### [Understanding RPATH (with CMake)](https://dev.my-gate.net/2021/08/04/understanding-rpath-with-cmake/)

On Linux `$ORIGIN` represents at runtime the location of the executable and thus if set the `RPATH` to for example `$ORIGIN/lib/libmylib.so`, your executable will look for the needed shared library relative to the executable location.

...

`CMAKE_INSTALL_RPATH` – A semicolon-separated list specifying the RPATH to use in installed targets

`CMAKE_SKIP_RPATH` – If true, do not add run time path information

`CMAKE_SKIP_BUILD_RPATH` – Do not include `RPATH`s in the build tree

`CMAKE_BUILD_WITH_INSTALL_RPATH` – Use the install path for the `RPATH`

`CMAKE_INSTALL_RPATH_USE_LINK_PATH` – Add paths to linker search and installed `RPATH`

`MACOSX_RPATH` – When this property is set to `TRUE`, the directory portion of the `install_name` field of this shared library will be `@rpath` unless overridden by `INSTALL_NAME_DIR`

### [CMake RPATH handling](https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/RPATH-handling)  

`$ORIGIN`: On Linux/Solaris, it's probably a very good idea to specify any `RPATH` setting one requires to look up the location of a package's private libraries via a relative expression, to not lose the capability to provide a fully relocatable package. This is what `$ORIGIN` is for. In `CMAKE_INSTALL_RPATH` lines, it should have its dollar sign escaped with a backslash to have it end up with proper syntax in the final executable. See also the [CMake and `$ORIGIN`](http://www.cmake.org/pipermail/cmake/2008-January/019290.html) discussion.

## cmake variables

### [CMAKE_INSTALL_RPATH](https://cmake.org/cmake/help/latest/variable/CMAKE_INSTALL_RPATH.html)

### [INSTALL_RPATH](https://cmake.org/cmake/help/latest/prop_tgt/INSTALL_RPATH.html#prop_tgt:INSTALL_RPATH)

## Related Question

- [Why does cmake's installed files differ from the actual built binary?](https://stackoverflow.com/a/64004227)

  This is normal behavior in CMake. When compiling you binaries the rpath to the dependencies is set in the binary, but stripped when installing it.

  > By default if you don't change any RPATH related settings, CMake will link the executables and shared libraries with full RPATH to all used libraries in the build tree. When installing, it will clear the RPATH of these targets so they are installed with an empty RPATH. [Source](https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling)


