# [libevent-book](https://github.com/nmathewson/libevent-book)

- [libevent-book](#libevent-book)
  - [github](#github)
  - [make](#make)

## [github](https://github.com/nmathewson/libevent-book)

commit 6eb2799fdff4d53235d21dccca47ffc66513d250

## make

Environment: Centos7

    yum install -y git dblatex asciidoc make gcc openssl-devel libevent-devel

    # a2x --version
    a2x 8.6.8

    # dblatex --version
    dblatex version 0.3.4

    git clone https://github.com/nmathewson/libevent-book.git
    cd libevent-book/
    make all
    make pdf
