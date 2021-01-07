# [How to Use SSH Tunneling to Access Restricted Servers and Browse Securely](https://www.howtogeek.com/168145/how-to-use-ssh-tunneling/)

- [How to Use SSH Tunneling to Access Restricted Servers and Browse Securely](#how-to-use-ssh-tunneling-to-access-restricted-servers-and-browse-securely)
  - [Local Port Forwarding: Make Remote Resources Accessible on Your Local System](#local-port-forwarding-make-remote-resources-accessible-on-your-local-system)
  - [Remote Port Forwarding: Make Local Resources Accessible on a Remote System](#remote-port-forwarding-make-local-resources-accessible-on-a-remote-system)
  - [Dynamic Port Forwarding: Use Your SSH Server as a Proxy](#dynamic-port-forwarding-use-your-ssh-server-as-a-proxy)

An SSH client connects to a [Secure Shell server](https://www.howtogeek.com/114812/5-cool-things-you-can-do-with-an-ssh-server/), which allows you to run terminal commands as if you were sitting in front of another computer. But an SSH client also allows you to “tunnel” a port between your local system and a remote SSH server.

There are three different types of SSH tunneling, and they’re all used for different purposes. Each involves using an SSH server to redirect traffic from one network port to another. The traffic is sent over the encrypted SSH connection, so it can’t be monitored or modified in transit.

You can do this with the ssh command included on Linux, macOS, and other [UNIX-like](https://www.howtogeek.com/182649/htg-explains-what-is-unix/) operating systems. On Windows, which doesn’t include a built-in ssh command, we recommend the free tool [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) to connect to SSH servers. It supports SSH tunneling, too.

## Local Port Forwarding: Make Remote Resources Accessible on Your Local System

“Local port forwarding” allows you to access local network resources that aren’t exposed to the Internet. For example, let’s say you want to access a database server at your office from your home. For security reasons, that database server is only configured to accept connections from the local office network. But if you have access to an SSH server at the office, and that SSH server allows connections from outside the office network, then you can connect to that SSH server from home and access the database server as if you were in the office. This is often the case, as it’s easier to secure a single SSH server against attacks than to secure a variety of different network resources.

To do this, you establish an SSH connection with the SSH server and tell the client to forward traffic from a specific port from your local PC—for example, port 1234—to the address of the database’s server and its port on the office network. So, when you attempt to access the database server at port 1234 your current PC, “localhost”, that traffic is automatically “tunneled” over the SSH connection and sent to the database server. The SSH server sits in the middle, forwarding traffic back and forth. You can use any command line or graphical tool to access the database server as if it was running on your local PC.

To use local forwarding, connect to the SSH server normally, but also supply the -L argument. The syntax is:

    ssh -L local_port:remote_address:remote_port username@server.com

For example, let’s say the database server at your office is located at 192.168.1.111 on the office network. You have access to the office’s SSH server at ssh.youroffice.com , and your user account on the SSH server is bob . In that case, your command would look like this:

    ssh -L 8888:192.168.1.111:1234 bob@ssh.youroffice.com

After running that command, you’d be able to access the database server at port 8888 at localhost. So, if the database server offered web access, you could plug <http://localhost:8888> into your web browser to access it. If you had a command line tool that needs the network address of a database, you’d point it at localhost:8888. All traffic sent to port 8888 on your PC will be tunneled to 192.168.1.111:1234 on your office network.

It’s a little more confusing if you want to connect to a server application running on the same system as the SSH server itself. For example, let’s say you have an SSH server running at port 22 on your office computer, but you also have a database server running at port 1234 on the **same system at the same address**. You want to access the database server from home, but the system is only accepting SSH connections on port 22 and its firewall doesn’t allow any other external connections.

In this case, you could run a command like the following one:

    ssh -L 8888:localhost:1234 bob@ssh.youroffice.com

When you attempt to access the database server at port 8888 on your current PC, the traffic will be sent over the SSH connection. When it arrives on the system running the SSH server, the SSH server will send it to port 1234 on “localhost”, which is the same PC running the SSH server itself. So the “localhost” in the command above means “localhost” from the perspective of the remote server.

To do this in the PuTTY application on Windows, select Connection > SSH > Tunnels. Select the “Local” option. For “Source Port”, enter the local port. For “Destination”, enter the destination address and port in the form remote_address:remote_port.

For example, if you wanted to set up the same SSH tunnel as above, you’d enter 8888 as the source port and localhost:1234 as the destination. Click “Add” afterwards and then click “Open” to open the SSH connection. You will also need to enter the address and port of the SSH server itself on the main “Session” screen before connecting, of course.

## Remote Port Forwarding: Make Local Resources Accessible on a Remote System

“Remote port forwarding” is the opposite of local forwarding, and isn’t used as frequently. It allows you to make a resource on your local PC available on the SSH server. For example, let’s say you’re running a web server on the local PC you’re sitting in front of. But your PC is behind a firewall that doesn’t allow incoming traffic to the server software.

Assuming you can access a remote SSH server, you can connect to that SSH server and use remote port forwarding. Your SSH client will tell the server to forward a specific port—say, port 1234—on the SSH server to a specific address and port on your current PC or local network. When someone accesses the port 1234 on the SSH server, that traffic will automatically be “tunneled” over the SSH connection. Anyone with access to the SSH server will be able to access the web server running on your PC. This is effectively a way to tunnel through firewalls.

To use remote forwarding, use the ssh command with the -R argument. The syntax is largely the same as with local forwarding:

    ssh -R remote_port:local_address:local_port username@server.com

Let’s say you want to make a server application listening at port 1234 on your local PC available at port 8888 on the remote SSH server. The SSH server’s address is ssh.youroffice.com and your username on the SSH server is bob. You’d run the following command:

    ssh -R 8888:localhost:1234 bob@ssh.youroffice.com

Someone could then connect to the SSH server at port 8888 and that connection would be tunneled to the server application running at port 1234 on the local PC you established the connection from.

To do this in PuTTY on Windows, select Connection > SSH > Tunnels. Select the “Remote” option. For “Source Port”, enter the remote port. For “Destination”, enter the destination address and port in the form local_address:local_port.

For example, if you wanted to set up the example above, you’d enter 8888 as the source port and localhost:1234 as the destination. Click “Add” afterwards and then click “Open” to open the SSH connection. You will also need to enter the address and port of the SSH server itself on the main “Session” screen before connecting, of course.

People could then connect to port 8888 on the SSH server and their traffic would be tunneled to port 1234 on your local system.

By default, the remote SSH server will only listen to connections from the same host. In other words, only people on the same system as the SSH server itself will be able to connect. This is for security reasons. You’ll need to enable the “GatewayPorts” option in sshd_config on the remote SSH server if you want to override this behavior.

## Dynamic Port Forwarding: Use Your SSH Server as a Proxy

RELATED: [What's the Difference Between a VPN and a Proxy?](https://www.howtogeek.com/247190/whats-the-difference-between-a-vpn-and-a-proxy/)

There’s also “dynamic port forwarding”, which works similarly to a proxy or VPN. The SSH client will create a SOCKS proxy you can configure applications to use. All the traffic sent through the proxy would be sent through the SSH server. This is similar to local forwarding—it takes local traffic sent to a specific port on your PC and sends it over the SSH connection to a remote location.

RELATED: [Why Using a Public Wi-Fi Network Can Be Dangerous, Even When Accessing Encrypted Websites](https://www.howtogeek.com/178696/why-using-a-public-wi-fi-network-can-be-dangerous-even-when-accessing-encrypted-websites/)

For example, let’s say you’re using a public Wi-Fi network. You want to [browse securely without being snooped on](https://www.howtogeek.com/178696/why-using-a-public-wi-fi-network-can-be-dangerous-even-when-accessing-encrypted-websites/). If you have access to an SSH server at home, you could connect to it and use dynamic port forwarding. The SSH client will create a SOCKS proxy on your PC. All traffic sent to that proxy will be sent over the SSH server connection. No one monitoring the public Wi-Fi network will be able to monitor your browsing or censor the websites you can access. From the perspective of any websites you visit, it will be as if you were sitting in front of your PC at home. This also means you could use this trick to access US-only websites while outside of the USA—assuming you have access to an SSH server in the USA, of course.

As an another example, you may want to access a media server application you have on your home network. For security reasons, you may only have an SSH server exposed to the Internet. You don’t allow incoming connections from the Internet to your media server application. You could set up dynamic port forwarding, configure a web browser to use the SOCKS proxy, and then access servers running on your home network through the web browser as if you were sitting in front of your SSH system at home. For example, if your media server is located at port 192.168.1.123 on your home network, you could plug the address 192.168.1.123 into any application using the SOCKS proxy and you’d access the media server as if you were on your home network.

To use dynamic forwarding, run the ssh command with the -D argument, like so:

    ssh -D local_port username@server.com

For example, let’s say you have access to an SSH server at ssh.yourhome.com and your username on the SSH server is bob . You want to use dynamic forwarding to open a SOCKS proxy at port 8888 on the current PC. You’d run the following command:

    ssh -D 8888 bob@ssh.yourhome.com

You could then configure a web browser or another application to use your local IP address (127.0.01) and port 8888. All traffic from that application would be redirected through the tunnel.

To do this in PuTTY on Windows, select Connection > SSH > Tunnels. Select the “Dynamic” option. For “Source Port”, enter the local port.

For example, if you wanted to create a SOCKS proxy on port 8888, you’d enter 8888 as the source port. Click “Add” afterwards and then click “Open” to open the SSH connection. You will also need to enter the address and port of the SSH server itself on the main “Session” screen before connecting, of course.

You could then configure an application to access the SOCKS proxy on your local PC (that is, IP address 127.0.0.1, which points to your local PC) and specify the correct port.

RELATED: [How to Configure a Proxy Server in Firefox](https://www.howtogeek.com/293213/how-to-configure-a-proxy-server-in-firefox/)

For example, you can [configure Firefox to use the SOCKS proxy](https://www.howtogeek.com/293213/how-to-configure-a-proxy-server-in-firefox/). This is particularly useful because Firefox can have its own proxy settings and doesn’t have to use system-wide proxy settings. Firefox will send its traffic through the SSH tunnel, while other applications will use your Internet connection normally.

When doing this in Firefox, select “Manual proxy configuration”, enter “127.0.0.1” into the SOCKS host box, and enter the dynamic port into the “Port” box. Leave the HTTP Proxy, SSL Proxy, and FTP Proxy boxes empty.

The tunnel will remain active and open for as long as you have the SSH session connection open. When you end your SSH session and disconnect from a server, the tunnel will also be closed. Just reconnect with the appropriate command (or the appropriate options in PuTTY) to reopen the tunnel.
