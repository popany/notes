# VNC

- [VNC](#vnc)
  - [vnc使用](#vnc使用)

## vnc使用

1. 修改vnc密码

       /opt/TurboVNC/bin/vncpasswd

2. 关闭vnc

       /opt/TurboVNC/bin/vncserver -kill :5

3. 开启vnc

       /opt/TurboVNC/bin/vncserver :5

   :5: 表示此 VNC 服务器会话将监听虚拟显示器 5。这意味着客户端在连接到这个服务器时需要指定地址 your_server_ip:5 或者使用端口号方式 your_server_ip:5905（VNC 默认端口是 5900，所以显示号 5 通常对应端口 5900 + 5 = 5905）

4. 测试 ubuntu terminal 中打开 xeyes

       export DISPLAY=:5
       xeyes
