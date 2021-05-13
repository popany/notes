# Boost Practice

- [Boost Practice](#boost-practice)
  - [Build](#build)
    - [Linux](#linux)

## Build

### Linux

[reference](https://www.boost.org/doc/libs/1_76_0/more/getting_started/unix-variants.html) 

    wget https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.bz2
    yum install -y bzip2
    tar --bzip2 -xf boost_1_76_0.tar.bz2
    cd boost_1_76_0
    ./bootstrap.sh  --without-libraries=python,test
    ./b2 install



