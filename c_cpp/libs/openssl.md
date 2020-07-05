# OpenSSL

- [OpenSSL](#openssl)
  - [Repository](#repository)
    - [Build and Install](#build-and-install)
      - [Windows](#windows)

[Welcome to OpenSSL!](https://www.openssl.org/)

## [Repository](https://github.com/openssl/openssl)

### [Build and Install](https://github.com/openssl/openssl/blob/master/INSTALL.md)

#### Windows

Refer to `Configure` file for options to create makefile.

    # Options:
    #
    # --config      add the given configuration file, which will be read after
    #               any "Configurations*" files that are found in the same
    #               directory as this script.
    # --prefix      prefix for the OpenSSL installation, which includes the
    #               directories bin, lib, include, share/man, share/doc/openssl
    #               This becomes the value of INSTALLTOP in Makefile
    #               (Default: /usr/local)
    # --openssldir  OpenSSL data area, such as openssl.cnf, certificates and keys.
    #               If it's a relative directory, it will be added on the directory
    #               given with --prefix.
    #               This becomes the value of OPENSSLDIR in Makefile and in C.
    #               (Default: PREFIX/ssl)

For more information, read `INSTALL` file.

cmd

    "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\vsvars32.bat"

    set path=%path%;C:\Program Files (x86)\Windows Kits\8.1\bin\x86

    perl Configure --prefix=C:\openssl_install_dir_x86 --openssldir=ssl VC-WIN32

    nmake
    nmake test
    nmake install
