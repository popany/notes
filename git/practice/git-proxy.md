# proxy

- [proxy](#proxy)
  - [sock5](#sock5)

## sock5

config proxy

    git config --global --add http.proxy socks5://127.0.0.1:30000
    git config --global --add https.proxy socks5://127.0.0.1:30000

start tunnel

    ssh -i ./.ssh/id_rsa -f -C -q -N -D 30000 root@x.x.x.x
