# ssh

- [ssh](#ssh)
  - [Forward](#forward)
    - [Local to Remote](#local-to-remote)
    - [Dynamic Forward](#dynamic-forward)

## Forward

### Local to Remote

Forward connections to `127.0.0.1:55000` to `172.20.0.2:50000` through the host 172.21.0.3.

    ssh -f -C -q -N -L 127.0.0.1:55000:172.20.0.2:50000 root@172.21.0.3

- `-f`: Forks the process to the background
- `-C`: Compresses the data before sending it
- `-q`: Uses quiet mode
- `-N`: Tells SSH that no command will be sent once the tunnel is up

### Dynamic Forward

    ssh -f -C -q -N -D 50001 root@172.21.0.3
