# curl

- [curl](#curl)
  - [HowTO](#howto)
  - [Practice](#practice)
    - [proxy](#proxy)

## HowTO

[How do I pipe or redirect the output of curl -v?](https://stackoverflow.com/questions/5427454/how-do-i-pipe-or-redirect-the-output-of-curl-v)

## Practice

### proxy

    -x, --proxy [protocol://]host[:port]

    curl -x "http://user:pwd@127.0.0.1:1234" "http://httpbin.org/ip"
    curl --proxy "http://user:pwd@127.0.0.1:1234" "http://httpbin.org/ip"
    curl -x "socks5://127.0.0.1:50001" "http://httpbin.org/ip"
