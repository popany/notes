# curl

- [curl](#curl)
  - [HowTO](#howto)
  - [Practice](#practice)
    - [proxy](#proxy)
    - [Follows redirect](#follows-redirect)

## HowTO

[How do I pipe or redirect the output of curl -v?](https://stackoverflow.com/questions/5427454/how-do-i-pipe-or-redirect-the-output-of-curl-v)

## Practice

### proxy

    -x, --proxy [protocol://]host[:port]

    curl -x "http://user:pwd@127.0.0.1:1234" "http://httpbin.org/ip"
    curl --proxy "http://user:pwd@127.0.0.1:1234" "http://httpbin.org/ip"
    curl -x "socks5://127.0.0.1:50001" "http://httpbin.org/ip"

### Follows redirect

    -L, --location

    curl -x socks5://127.0.0.1:50001 -L -O https://github.com/Kitware/CMake/releases/download/v3.21.0-rc2/cmake-3.21.0-rc2-linux-x86_64.sh
