# Windows System Settings

- [Windows System Settings](#windows-system-settings)
  - [TCP](#tcp)
    - [TCP keep-alive 设置](#tcp-keep-alive-设置)
      - [详细请参考以下官方文档](#详细请参考以下官方文档)
      - [试验](#试验)

## TCP

### [TCP keep-alive 设置](https://social.technet.microsoft.com/Forums/office/zh-CN/93ea79f9-f3a3-4fe1-9903-8471e8bf585b/3583125945windows)

On Microsoft Windows set KeepAliveTime to 300000.

Code:

    \HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\TCPIP\Parameters

If the `KeepAlivetime` parameter does not already exist in the above location, create it. The time specified is in milliseconds.

#### 详细请参考以下官方文档

<https://docs.microsoft.com/en-us/archive/blogs/nettracer/things-that-you-may-want-to-know-about-tcp-keepalives>

    KeepAliveTime
    Key: Tcpip\Parameters
    Value Type: REG_DWORD-time in milliseconds
    Valid Range: 1-0xFFFFFFFF
    Default: 7,200,000 (two hours)
    Description: The parameter controls how often TCP attempts to verify that an idle connection is still intact by sending a keep-alive packet. If the remote system is still reachable and functioning, it acknowledges the keep-alive transmission. Keep-alive packets are not sent by default. This feature may be enabled on a connection by an application

#### 试验

Win10 系统设置 KeepAliveTime, 重启后生效
