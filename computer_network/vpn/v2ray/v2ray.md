# v2ray

- [v2ray](#v2ray)
  - [V2Ray](#v2ray-1)
    - [安装](#安装)
      - [Linux](#linux)
      - [Windows](#windows)
    - [配置](#配置)
      - [服务端](#服务端)
      - [客户端](#客户端)
    - [启动](#启动)
  - [V2Ray + Warp](#v2ray--warp)
    - [安装与配置 WARP](#安装与配置-warp)
    - [V2Ray 服务端配置](#v2ray-服务端配置)
  - [参考](#参考)


https://www.v2ray.com/en/welcome/install.html

https://www.v2fly.org/

V2Ray 初期是 Projet V 开发并维护的，Project V 停止更新后，由 V2Fly 社区继续开发维护 V2Ray  

## V2Ray

### 安装

#### Linux

参考: [linux-安装方式](https://www.v2fly.org/guide/install.html#linux-%E5%AE%89%E8%A3%85%E6%96%B9%E5%BC%8F)

    git clone https://github.com/v2fly/fhs-install-v2ray.git
    sudo bash ./fhs-install-v2ray/install-release.sh

#### Windows

参考：[Windows 安装方式](https://www.v2fly.org/guide/install.html#windows-%E5%AE%89%E8%A3%85%E6%96%B9%E5%BC%8F)

### 配置

#### 服务端

    {
        "inbounds": [
            {
                "port": 10086,
                "protocol": "vmess",
                "settings": {
                    "clients": [
                        {
                            "id": "b831381d-6324-4d53-ad4f-8cda48b30811"
                        }
                    ]
                }
            }
        ],
        "outbounds": [
            {
                "protocol": "freedom"
            }
        ]
    }

#### 客户端

    {
        "inbounds": [
            {
                "port": 1080, // SOCKS 代理端口，在浏览器中需配置代理并指向这个端口
                "listen": "127.0.0.1",
                "protocol": "socks",
                "settings": {
                    "udp": true
                }
            }
        ],
        "outbounds": [
            {
                "protocol": "vmess",
                "settings": {
                    "vnext": [
                        {
                            "address": "server", // 服务器地址，请修改为你自己的服务器 ip 或域名
                            "port": 10086, // 服务器端口
                            "users": [
                                {
                                    "id": "b831381d-6324-4d53-ad4f-8cda48b30811"
                                }
                            ]
                        }
                    ]
                }
            },
            {
                "protocol": "freedom",
                "tag": "direct"
            }
        ],
        "routing": {
            "domainStrategy": "IPOnDemand",
            "rules": [
                {
                    "type": "field",
                    "ip": [
                        "geoip:private"
                    ],
                    "outboundTag": "direct"
                }
            ]
        }
    }

### 启动

客户端与服务端的启动方式相同

    v2ray run -c /path/to/config.json

## V2Ray + Warp

参考: [fscarmen/warp](https://gitlab.com/fscarmen/warp)

### 安装与配置 WARP

    wget -N https://gitlab.com/fscarmen/warp/-/raw/main/warp-go.sh && sudo bash warp-go.sh

### V2Ray 服务端配置

    {
        "inbounds": [
            {
                "port": 10086,
                "protocol": "vmess",
                "settings": {
                    "clients": [
                        {
                            "id": "b831381d-6324-4d53-ad4f-8cda48b30811"
                        }
                    ]
                }
            }
        ],
        "outbounds":[
            {
                "protocol":"freedom",
                "tag": "direct"
            },
            {
                "protocol":"wireguard",
                "settings":{
                    "secretKey":"YFYOAdbw1bKTHlNNi+aEjBM3BO7unuFC5rOkMRAz9XY=", // 粘贴你的 "private_key" 值
                    "address":[
                        "172.16.0.2/32",
                        "2606:4700:110:8a36:df92:102a:9602:fa18/128"
                    ],
                    "peers":[
                        {
                            "publicKey":"bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
                            "allowedIPs":[
                                "0.0.0.0/0",
                                "::/0"
                            ],
                            "endpoint":"engage.cloudflareclient.com:2408" // 或填写 162.159.193.10:2408 或 [2606:4700:d0::a29f:c001]:2408
                        }
                    ],
                    "reserved":[78, 135, 76], // 粘贴你的 "reserved" 值
                    "mtu":1280
                },
                "tag":"wireguard"
            },
            {
                "protocol":"freedom",
                "settings":{
                    "domainStrategy":"UseIPv4"
                },
                "proxySettings":{
                    "tag":"wireguard"
                },
                "tag":"warp-IPv4"
            },
            {
                "protocol":"freedom",
                "settings":{
                    "domainStrategy":"UseIPv6"
                },
                "proxySettings":{
                    "tag":"wireguard"
                },
                "tag":"warp-IPv6"
            }
        ],
        "routing":{
            "domainStrategy":"AsIs",
            "rules":[
                {
                    "type":"field",
                    "domain":[
                        "geosite:openai",
                        "ip.gs"
                    ],
                    "outboundTag":"warp-IPv4"
                },
                {
                    "type":"field",
                    "domain":[
                        "geosite:netflix",
                        "p3terx.com"
                    ],
                    "outboundTag":"warp-IPv6"
                }
            ]
        }
    }

说明：

1. `outbounds`: 出站连接列表，定义了数据通过V2Ray时如何被处理。

   - 第一个出站连接 `"tag": "direct"` 使用`freedom`协议，直接连接到目标服务器，无需任何代理。

   - 第二个出站连接 `"tag": "wireguard"`` 配置了WireGuard代理，这需要你有一个已经设置好的WireGuard服务器。`"secretKey"`` 是你的私钥，与服务器进行通信时使用；`"address"`` 包含你的IP地址；`"peers"`` 定义了服务器端以及如何路由流量。

   - 第三和第四个出站连接 `"tag": "warp-IPv4"` 和 `"tag": "warp-IPv6"` 分别用于处理IPv4和IPv6流量，并且它们都设置了`domainStrategy`来决定如何处理域名请求。同时，它们通过`proxySettings`将流量转发到WireGuard。

2. `routing`: 路由规则，定义了不同的数据包应该如何被转发到不同的出站连接。

   - 第一条路由规则指定访问 `geosite:openai` 和 `ip.gs` 时使用 `"outboundTag": "warp-IPv4"` 出站连接，即通过Warp的IPv4网络。

   - 第二条路由规则指定访问 `geosite:netflix` 和 `p3terx.com` 时使用 `"outboundTag": "warp-IPv6"` 出站连接，即通过Warp的IPv6网络。

## 参考

https://gitlab.com/fscarmen/warp

https://blog.skyju.cc/post/v2ray-warp-go-unlock-new-bing/

https://github.com/willoong9559/XrayWarp

https://wej.cc/147.html

https://powerfulyang.com/post/136

https://www.4spaces.org/3750.html

https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/download-warp/