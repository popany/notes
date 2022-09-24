# Nginx Pactice

- [Nginx Pactice](#nginx-pactice)
  - [Tcp Port Forward](#tcp-port-forward)
    - [Reference - Module ngx_stream_proxy_module](#reference---module-ngx_stream_proxy_module)
      - [Example Configuration](#example-configuration)
      - [Directives](#directives)
        - [proxy_connect_timeout](#proxy_connect_timeout)
        - [proxy_pass](#proxy_pass)
        - [proxy_timeout](#proxy_timeout)
  - [NGINX as a file server](#nginx-as-a-file-server)

## Tcp Port Forward

    stream {
        upstream tcpLink1 {
            server 172.17.0.2:55001;
        }
    
        server {
            listen 55000 so_keepalive=on;
            proxy_connect_timeout 3s;
            proxy_timeout 1m;
            proxy_pass tcpLink1;
        }
    }

### Reference - [Module ngx_stream_proxy_module](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html)

The `ngx_stream_proxy_module` module (1.9.0) allows proxying data streams over TCP, UDP (1.9.13), and UNIX-domain sockets.

#### Example Configuration

    server {
        listen 127.0.0.1:12345;
        proxy_pass 127.0.0.1:8080;
    }
    
    server {
        listen 12345;
        proxy_connect_timeout 1s;
        proxy_timeout 1m;
        proxy_pass example.com:12345;
    }
    
    server {
        listen 53 udp reuseport;
        proxy_timeout 20s;
        proxy_pass dns.example.com:53;
    }
    
    server {
        listen [::1]:12345;
        proxy_pass unix:/tmp/stream.socket;
    }

#### Directives

##### proxy_connect_timeout

    Syntax:  proxy_connect_timeout time;
    Default: proxy_connect_timeout 60s;
    Context: stream, server

Defines a timeout for establishing a connection with a proxied server.

##### proxy_pass

    Syntax:  proxy_pass address;
    Default: —
    Context: server

Sets the address of a proxied server. The address can be specified as a domain name or IP address, and a port:

    proxy_pass localhost:12345;

or as a UNIX-domain socket path:

    proxy_pass unix:/tmp/stream.socket;

If a domain name resolves to several addresses, all of them will be used in a round-robin fashion. In addition, an address can be specified as a [server group](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html).

The address can also be specified using variables (1.11.3):

    proxy_pass $upstream;

In this case, the server name is searched among the described [server groups](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html), and, if not found, is determined using a [resolver](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#resolver).

##### proxy_timeout

    Syntax:	 proxy_timeout timeout;
    Default: proxy_timeout 10m;
    Context: stream, server

Sets the `timeout` between two successive read or write operations on client or proxied server connections. If no data is transmitted within this time, the connection is closed.

## [NGINX as a file server](https://www.yanxurui.cc/posts/server/2017-03-21-NGINX-as-a-file-server/)

    # cat /etc/nginx/conf.d/foo.conf
    server {
        listen 8001;

        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;

        location / {
            root /opt/resources;
        }
    }

