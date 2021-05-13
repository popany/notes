# wget

- [wget](#wget)
  - [proxy](#proxy)
    - [demo](#demo)

## proxy

[reference](https://stackoverflow.com/a/11211812)

For all users of the system via the /etc/wgetrc or for the user only with the ~/.wgetrc file:

    use_proxy=yes
    http_proxy=127.0.0.1:8080
    https_proxy=127.0.0.1:8080

or via -e options placed after the URL:

    wget ... -e use_proxy=yes -e http_proxy=127.0.0.1:8080 ...

### demo

    wget -e use_proxy=yes -e http_proxy=socks5://127.0.0.1:50001 -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.16.1/cmake-3.16.1-Linux-x86_64.sh
