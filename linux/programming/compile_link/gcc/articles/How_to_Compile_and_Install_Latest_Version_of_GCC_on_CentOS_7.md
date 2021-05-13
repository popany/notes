# [How to Compile and Install Latest Version of GCC on CentOS 7](https://jdhao.github.io/2017/09/04/install-gcc-newer-version-on-centos/)

- [How to Compile and Install Latest Version of GCC on CentOS 7](#how-to-compile-and-install-latest-version-of-gcc-on-centos-7)
  - [Downloading GCC source code](#downloading-gcc-source-code)
  - [Install dependencies](#install-dependencies)
  - [Configuration and install](#configuration-and-install)
  - [Post-installation](#post-installation)
  - [References](#references)

The default GCC that comes with the CentOS 7.2 is GCC 4.8.5, which does not support the complete C++11 standard, for example, it does not fully support [regular expressions](http://en.cppreference.com/w/cpp/regex). In order to use regular expression functions, [we need to install at least GCC 4.9.0](https://stackoverflow.com/a/8061172/6064933). The following installation procedure is applicable to CentOS 7 and are not tested on other Linux systems. Also you have to make sure that you have root privelege.

Update:

[GCC 8.3 has been released on Feb 22, 2019](https://gcc.gnu.org/onlinedocs/8.3.0/). The installation process is the same as prvevious versions. Download the corrent tar file from the GNU ftp server, compile and install it.

## Downloading GCC source code

You can download the GCC source code from the [official GNU ftp](https://ftp.gnu.org/gnu/gcc/). I choose to install [version 5.4.0](https://ftp.gnu.org/gnu/gcc/gcc-5.4.0/).

    curl https://ftp.gnu.org/gnu/gcc/gcc-5.4.0/gcc-5.4.0.tar.bz2 -O
    tar jxvf gcc-5.4.0.tar.bz2

## Install dependencies

We need to install 3 dependencies packages. It is [recommended to install these packages through yum](https://gcc.gnu.org/wiki/InstallingGCC).

    yum install gmp-devel mpfr-devel libmpc-devel

## Configuration and install

Unlike other packages, it is recommended to create another build directory outside of the GCC source directory to build GCC.

    mkdir gcc-5.4.0-build
    cd gcc-5.4.0-build
    ../gcc-5.4.0/configure --enable-languages=c,c++ --disable-multilib
    make -j$(nproc) && make install

The comiplation process may take a long time and you need to be patient. It will install GCC under `/usr/local`. You can change the install dir using `--prefix` option if you prefer.

## Post-installation

You should add the install dir of GCC to your `PATH` and `LD_LIBRARY_PATH` in order to use the newer GCC. Add the following settings to `/etc/profile`:

    export PATH=/usr/local/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH

Maybe a restart of your current session is also needed.

You can download the whole install script [here](https://gist.github.com/jdhao/e3fd77d51f3a95684d2b3354fc61b2ab).

## References

- <https://gist.github.com/craigminihan/b23c06afd9073ec32e0c>
- [GCC install wiki](https://gcc.gnu.org/wiki/InstallingGCC)
- [GNU GCC ftp site](https://ftp.gnu.org/gnu/gcc/)
- [GCC configure options](https://gcc.gnu.org/install/configure.html)
