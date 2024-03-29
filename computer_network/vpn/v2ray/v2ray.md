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
    - [V2Ray 服务端配置(warp-go)](#v2ray-服务端配置warp-go)
    - [启动 V2Ray](#启动-v2ray)
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

参考:

[fscarmen/warp](https://gitlab.com/fscarmen/warp)

[一个 warp-go 的案例](https://blog.skyju.cc/post/v2ray-warp-go-unlock-new-bing/)

### 安装与配置 WARP

    wget -N https://gitlab.com/fscarmen/warp/-/raw/main/warp-go.sh && sudo bash warp-go.sh

切换为 non-global 模式

    sudo warp-go g

### V2Ray 服务端配置(warp-go)

v2-wrap-go-config.json

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
                "protocol":"freedom"
            },
            {
                "tag":"WARP-interface-v4",
                "protocol":"freedom",
                "settings":{
                    "domainStrategy":"UseIPv4"
                },
                "streamSettings":{
                    "sockopt":{
                        "interface":"WARP",
                        "tcpFastOpen":true
                    }
                }
            },
            {
                "tag":"WARP-interface-v6",
                "protocol":"freedom",
                "settings":{
                    "domainStrategy":"UseIPv6"
                },
                "streamSettings":{
                    "sockopt":{
                        "interface":"WARP",
                        "tcpFastOpen":true
                    }
                }
            }
        ],
        "routing":{
            "domainStrategy":"AsIs",
            "rules":[
                {
                    "type":"field",
                    "domain":[
                        "geosite:google",
                        "geosite:openai",
                        "ip.gs"
                    ],
                    "outboundTag":"WARP-interface-v4"
                },
                {
                    "type":"field",
                    "domain":[
                        "geosite:netflix",
                        "p3terx.com"
                    ],
                    "outboundTag":"WARP-interface-v6"
                }
            ]
        }
    }

### 启动 V2Ray

使用 WARP 网卡要有 root 权限

    sudo v2ray run -c v2-wrap-go-config.json

## 参考

https://gitlab.com/fscarmen/warp

https://github.com/willoong9559/XrayWarp

https://wej.cc/147.html

https://powerfulyang.com/post/136

https://www.4spaces.org/3750.html

https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/download-warp/