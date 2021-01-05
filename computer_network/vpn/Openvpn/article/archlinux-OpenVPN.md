# [OpenVPN](https://wiki.archlinux.org/index.php/OpenVPN)

- [OpenVPN](#openvpn)
  - [Installation](#installation)
  - [Kernel configuration](#kernel-configuration)
  - [Connect to a VPN provided by a third party](#connect-to-a-vpn-provided-by-a-third-party)
  - [Create a Public Key Infrastructure (PKI) from scratch](#create-a-public-key-infrastructure-pki-from-scratch)
  - [A basic Layer-3 IP routing configuration](#a-basic-layer-3-ip-routing-configuration)
    - [Example configuration](#example-configuration)
    - [The server configuration file](#the-server-configuration-file)
      - [Hardening the server](#hardening-the-server)
      - [Enabling compression](#enabling-compression)
      - [Deviating from the standard port and/or protocol](#deviating-from-the-standard-port-andor-protocol)
      - [Running multiple instances of OpenVPN on different ports on the physical machine](#running-multiple-instances-of-openvpn-on-different-ports-on-the-physical-machine)
    - [The client config profile](#the-client-config-profile)
      - [Run as unprivileged user](#run-as-unprivileged-user)
    - [Converting certificates to encrypted .p12 format](#converting-certificates-to-encrypted-p12-format)
    - [Testing the OpenVPN configuration](#testing-the-openvpn-configuration)
    - [Configure the MTU with Fragment and MSS](#configure-the-mtu-with-fragment-and-mss)
    - [IPv6](#ipv6)
      - [Connect to the server via IPv6](#connect-to-the-server-via-ipv6)
      - [Provide IPv6 inside the tunnel](#provide-ipv6-inside-the-tunnel)
  - [Starting OpenVPN](#starting-openvpn)
    - [Manual startup](#manual-startup)
    - [systemd service configuration](#systemd-service-configuration)
    - [Letting NetworkManager start a connection](#letting-networkmanager-start-a-connection)
    - [Gnome configuration](#gnome-configuration)
  - [Routing client traffic through the server](#routing-client-traffic-through-the-server)
    - [Firewall configuration](#firewall-configuration)
      - [firewalld](#firewalld)
      - [ufw](#ufw)
      - [iptables](#iptables)
    - [Prevent leaks if VPN goes down](#prevent-leaks-if-vpn-goes-down)
      - [ufw](#ufw-1)
      - [vpnfailsafe](#vpnfailsafe)
  - [Layer-3 IPv4 routing](#layer-3-ipv4-routing)
    - [Prerequisites for routing a LAN](#prerequisites-for-routing-a-lan)
      - [Routing tables](#routing-tables)
    - [Connect the server LAN to a client](#connect-the-server-lan-to-a-client)
    - [Connect the client LAN to a server](#connect-the-client-lan-to-a-server)
    - [Connect both the client and server LANs](#connect-both-the-client-and-server-lans)
    - [Connect clients and client LANs](#connect-clients-and-client-lans)
  - [DNS](#dns)
    - [The pull-resolv-conf custom scripts](#the-pull-resolv-conf-custom-scripts)
    - [The update-resolv-conf custom script](#the-update-resolv-conf-custom-script)
    - [The update-systemd-resolved custom script](#the-update-systemd-resolved-custom-script)
    - [Override DNS servers using NetworkManager](#override-dns-servers-using-networkmanager)
  - [Layer-2 Ethernet bridging](#layer-2-ethernet-bridging)
  - [Config generators](#config-generators)
    - [ovpngen](#ovpngen)
    - [openvpn-unroot](#openvpn-unroot)
  - [Troubleshooting](#troubleshooting)
    - [Client daemon not reconnecting after suspend](#client-daemon-not-reconnecting-after-suspend)
    - [Connection drops out after some time of inactivity](#connection-drops-out-after-some-time-of-inactivity)
    - [PID files not present](#pid-files-not-present)
    - [Route configuration fails with systemd-networkd](#route-configuration-fails-with-systemd-networkd)
    - [tls-crypt unwrap error: packet too short](#tls-crypt-unwrap-error-packet-too-short)
  - [See also](#see-also)

This article describes a basic installation and configuration of [OpenVPN](http://openvpn.net/), suitable for private and small business use. For more detailed information, please see the [OpenVPN 2.4 man page](https://community.openvpn.net/openvpn/wiki/Openvpn24ManPage) and the [OpenVPN documentation](http://openvpn.net/index.php/open-source/documentation). OpenVPN is a robust and highly flexible [VPN](https://en.wikipedia.org/wiki/VPN) daemon. It supports [SSL/TLS](https://en.wikipedia.org/wiki/SSL/TLS) security, [Ethernet bridging](https://en.wikipedia.org/wiki/Bridging_(networking)), [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) or [UDP](https://en.wikipedia.org/wiki/User_Datagram_Protocol) [tunnel transport](https://en.wikipedia.org/wiki/Tunneling_protocol) through [proxies](https://en.wikipedia.org/wiki/Proxy_server) or [NAT](https://en.wikipedia.org/wiki/Network_address_translation). Additionally it has support for dynamic IP addresses and [DHCP](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol), scalability to hundreds or thousands of users, and portability to most major OS platforms.

OpenVPN is tightly bound to the [OpenSSL](http://www.openssl.org/) library, and derives much of its crypto capabilities from it. It supports conventional encryption using a [pre-shared secret key](https://en.wikipedia.org/wiki/Pre-shared_key) (Static Key mode) or [public key security](https://en.wikipedia.org/wiki/Public_key) ([SSL/TLS](https://en.wikipedia.org/wiki/SSL/TLS) mode) using client & server certificates. Additionally it supports unencrypted TCP/UDP tunnels.

OpenVPN is designed to work with the [TUN/TAP](https://en.wikipedia.org/wiki/TUN/TAP) virtual networking interface that exists on most platforms. Overall, it aims to offer many of the key features of [IPSec](https://en.wikipedia.org/wiki/Ipsec) but with a relatively lightweight footprint. OpenVPN was written by James Yonan and is published under the [GNU General Public License (GPL)](https://en.wikipedia.org/wiki/GNU_General_Public_License).

## Installation

[Install](https://wiki.archlinux.org/index.php/Install) the [openvpn](https://archlinux.org/packages/?name=openvpn) package, which provides both server and client mode.

Available frontends:

- NetworkManager OpenVPN — NetworkManager VPN plugin for OpenVPN.

  <https://wiki.gnome.org/Projects/NetworkManager/VPN> || [networkmanager-openvpn](https://archlinux.org/packages/?name=networkmanager-openvpn)

- QOpenVPN — Simple OpenVPN GUI written in PyQt for systemd based distributions.

  <https://github.com/xmikos/qopenvpn> || [qopenvpn](https://archlinux.org/packages/?name=qopenvpn)

## Kernel configuration

OpenVPN requires TUN/TAP support, which is already configured in the default kernel. Users of custom kernel should make sure to enable the tun module:

Kernel config file

     Device Drivers
      --> Network device support
        [M] Universal TUN/TAP device driver support

Read [Kernel modules](https://wiki.archlinux.org/index.php/Kernel_modules) for more information.

## Connect to a VPN provided by a third party

To connect to a VPN service provided by a third party, most of the following can most likely be ignored, especially regarding server setup. Begin with [#The client config profile](https://wiki.archlinux.org/index.php/OpenVPN#The_client_config_profile) and skip ahead to [#Starting OpenVPN](https://wiki.archlinux.org/index.php/OpenVPN#Starting_OpenVPN) after that. One should use the provider certificates and instructions, see [Category:VPN providers](https://wiki.archlinux.org/index.php/Category:VPN_providers) for examples that can be adapted to other providers. [OpenVPN client in Linux Containers](https://wiki.archlinux.org/index.php/OpenVPN_client_in_Linux_Containers) also has general applicable instructions, while it goes a step further by isolating an OpenVPN client process into a container.

Note: Most free VPN providers will (often only) offer [PPTP](https://wiki.archlinux.org/index.php/PPTP_server), which is drastically easier to setup and configure, but [not secure](http://poptop.sourceforge.net/dox/protocol-security.phtml).

## Create a Public Key Infrastructure (PKI) from scratch

When setting up an OpenVPN server, users need to create a [Public Key Infrastructure (PKI)](https://en.wikipedia.org/wiki/Public_key_infrastructure) which is detailed in the [Easy-RSA](https://wiki.archlinux.org/index.php/Easy-RSA) article. Once the needed certificates, private keys, and associated files are created via following the steps in the separate article, one should have 5 files in `/etc/openvpn/server` at this point:

    ca.crt
    dh.pem
    servername.crt
    servername.key
    ta.key

Alternatively, as of OpenVPN 2.4, one can use Easy-RSA to generate certificates and keys using elliptic curves. See the OpenVPN documentation for details.

## A basic Layer-3 IP routing configuration

Note: Unless otherwise explicitly stated, the rest of this article assumes a basic Layer-3 IP routing configuration.

OpenVPN is an extremely versatile piece of software and many configurations are possible, in fact machines can be both servers and clients.

With the release of v2.4, server configurations are stored in `/etc/openvpn/server` and client configurations are stored in `/etc/openvpn/client` and each mode has its own respective systemd unit, namely, `openvpn-client@.service` and `openvpn-server@.service`.

### Example configuration

The OpenVPN package comes with a collection of example configuration files for different purposes. The sample server and client configuration files make an ideal starting point for a basic OpenVPN setup with the following features:

- Uses [Public Key Infrastructure (PKI)](https://en.wikipedia.org/wiki/Public_key_infrastructure) for authentication.
- Creates a VPN using a virtual TUN network interface (OSI Layer-3 IP routing).
- Listens for client connections on UDP port 1194 (OpenVPN's official IANA port number[[1]](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml?search=openvpn)).
- Distributes virtual addresses to connecting clients from the 10.8.0.0/24 subnet.

For more advanced configurations, please see the [openvpn(8)](https://jlk.fjfi.cvut.cz/arch/manpages/man/openvpn.8) man page and the [OpenVPN documentation](http://openvpn.net/index.php/open-source/documentation).

### The server configuration file

Note: Note that if the server is behind a firewall or a NAT translating router, the OpenVPN port must be forwarded on to the server.

Copy the example server configuration file `/usr/share/openvpn/examples/server.conf` to `/etc/openvpn/server/server.conf`.

Edit the file making a minimum of the following changes:

/etc/openvpn/server/server.conf

    ca ca.crt
    cert servername.crt
    key servername.key
    dh dh.pem
    .
    tls-crypt ta.key # Replaces tls-auth ta.key 0
    .
    user nobody
    group nobody

If TLS with elliptic curves is used, specify `dh none` and `ecdh-curve secp521r1`. DH parameters file is not used when using elliptic curves. Starting from OpenVPN 2.4.8, it is required to specify the type of elliptic curves in server configuration. Otherwise the server would fail to recognize the curve type and possibly use an incompatible one, resulting in authentication errors.

#### Hardening the server

If security is a priority, additional configuration is recommended including: limiting the server to use a strong cipher/auth method and (optionally) limiting the set of enabled TLS ciphers to the newer ciphers. Starting from OpenVPN 2.4, the server and the client will automatically negotiate AES-256-GCM in TLS mode.

Add the following to `/etc/openvpn/server/server.conf`:

/etc/openvpn/server/server.conf

    .
    cipher AES-256-GCM
    auth SHA512
    tls-version-min 1.2
    tls-cipher TLS-DHE-RSA-WITH-AES-256-GCM-SHA384:TLS-DHE-RSA-WITH-AES-128-GCM-SHA256:TLS-DHE-RSA-WITH-AES-256-CBC-SHA:TLS-DHE-RSA-WITH-CAMELLIA-256-CBC-SHA:TLS-DHE-RSA-WITH-AES-128-CBC-SHA:TLS-DHE-RSA-WITH-CAMELLIA-128-CBC-SHA
    .

Note:

- The .ovpn client profile must contain a matching cipher and auth line to work properly (at least with the iOS and Android client).
- Using `tls-cipher` incorrectly may cause difficulty with debugging connections and may not be necessary. See [OpenVPN’s community wiki](https://community.openvpn.net/openvpn/wiki/Hardening#Useof--tls-cipher) for more information.

#### Enabling compression

Enabling compression is not recommended by upstream; doing so opens to the server the so-called VORACLE attack vector. See [this](https://community.openvpn.net/openvpn/wiki/VORACLE) article.

#### Deviating from the standard port and/or protocol

It is generally recommended to use OpenVPN over UDP, because [TCP over TCP is a bad idea](http://sites.inka.de/bigred/devel/tcp-tcp.html)[[2]](http://adsabs.harvard.edu/abs/2005SPIE.6011..138H).

Some networks may disallow OpenVPN connections on the default port and/or protocol. One strategy to circumvent this is to mimic HTTPS traffic which is very likely unobstructed.

To do so, configure `/etc/openvpn/server/server.conf` as such:

    /etc/openvpn/server/server.conf

    .
    port 443
    proto tcp
    .

Note: The .ovpn client profile must contain a matching port and proto line to work properly!

#### Running multiple instances of OpenVPN on different ports on the physical machine

One can have multiple, concurrent instances of OpenVPN running on the same box. Each server needs to be defined in `/etc/openvpn/server/` as a separate .conf file. At a minimum, the parallel servers need to be running on different ports. A simple setup directs traffic connecting in to a separate IP pool. More advanced setups are beyond the scope of this guide.

Consider this example, running 2 concurrent servers, one port 443/udp and another on port 80/tcp.

First modify `/etc/openvpn/server/server.conf` created as so:

/etc/openvpn/server/server.conf

    .
    port 443
    proto udp
    server 10.8.0.0 255.255.255.0
    .

Now copy it and modify the copy to run on 80/tcp:

/etc/openvpn/server/server2.conf

    .
    port 80
    proto tcp
    server 10.8.1.0 255.255.255.0
    .

Be sure to setup the corresponding entries in the firewall, see the relevant sections in [#Firewall configuration](https://wiki.archlinux.org/index.php/OpenVPN#Firewall_configuration).

### The client config profile

Copy the example client configuration file `/usr/share/openvpn/examples/client.conf` to `/etc/openvpn/client/`.

Edit the following:

- The `remote` directive to reflect either the server's [Fully Qualified Domain Name](https://en.wikipedia.org/wiki/Fully_qualified_domain_name), hostname (as known to the client), or its IP address.
- Uncomment the `user` and `group` directives to drop privileges.
- The `ca`, `cert`, and `key` parameters to reflect the path and names of the keys and certificates.
- Enable the TLS HMAC handshake protection (`--tls-crypt` or `--tls-auth`).

/etc/openvpn/client/client.conf

    client
    remote elmer.acmecorp.org 1194
    .
    user nobody
    group nobody
    ca ca.crt
    cert client.crt
    key client.key
    .
    tls-crypt ta.key # Replaces tls-auth ta.key 1

#### Run as unprivileged user

Using the options `user nobody` and `group nobody` in the configuration file makes OpenVPN drop its `root` privileges after establishing the connection. The downside is that upon VPN disconnect the daemon is unable to delete its set network routes again. If one wants to limit transmitting traffic without the VPN connection, then lingering routes may be considered beneficial. It can also happen, however, that the OpenVPN server pushes updates to routes at runtime of the tunnel. A client with dropped privileges will be unable to perform the update and exit with an error.

As it could seem to require manual action to manage the routes, the options `user nobody` and `group nobody` might seem undesirable. Depending on setup, however, there are different ways to handle these situations:

- For errors of the unit, a simple way is to [edit](https://wiki.archlinux.org/index.php/Edit) it and add a `Restart=on-failure` to the `[Service]` section. Though, this alone will not delete any obsoleted routes, so it may happen that the restarted tunnel is not routed properly.
- The package contains the `/usr/lib/openvpn/plugins/openvpn-plugin-down-root.so`, which can be used to let openvpn fork a process with root privileges with the only task to execute a custom script when receiving a down signal from the main process, which is handling the tunnel with dropped privileges (see also its [README](https://community.openvpn.net/openvpn/browser/plugin/down-root/README?rev=d02a86d37bed69ee3fb63d08913623a86c88da15)).

The OpenVPN HowTo's linked below go further by creating a dedicated non-privileged user/group, instead of the already existing `nobody`. The advantage is that this avoids potential risks when sharing a user among daemons:

- The [OpenVPN HowTo](https://openvpn.net/index.php/open-source/documentation/howto.html#security) explains another way how to create an unprivileged user mode and wrapper script to have the routes restored automatically.

- It is possible to let OpenVPN start as a non-privileged user in the first place, without ever running as root, see [this OpenVPN wiki](https://community.openvpn.net/openvpn/wiki/UnprivilegedUser) (howto). The howto assumes the presence of System V init, rather than [Systemd](https://wiki.archlinux.org/index.php/Systemd) and does not cover the handling of `--up/--down` scripts - those should be handled the same way as the ip command, with additional attention to access rights.

- It is also possible to run OpenVPN from within unprivileged podman container, see [this section of OpenVPN HowTo](https://community.openvpn.net/openvpn/wiki/UnprivilegedUser#RunOpenVPNwithinunprivilegedpodmancontainer)

Tip: [#openvpn-unroot](https://wiki.archlinux.org/index.php/OpenVPN#openvpn-unroot) describes a tool to automate above setup.

### Converting certificates to encrypted .p12 format

Some software will only read VPN certificates that are stored in a password-encrypted .p12 file. These can be generated with the following command:

    # openssl pkcs12 -export -inkey keys/bugs.key -in keys/bugs.crt -certfile keys/ca.crt -out keys/bugs.p12

### Testing the OpenVPN configuration

Run `openvpn /etc/openvpn/server/server.conf` (as the root user) on the server, and `openvpn /etc/openvpn/client/client.conf` (as the root user) on the client. Example output should be similar to the following:

    # openvpn /etc/openvpn/server/server.conf
    Wed Dec 28 14:41:26 2011 OpenVPN 2.2.1 x86_64-unknown-linux-gnu [SSL] [LZO2] [EPOLL] [eurephia] built on Aug 13 2011
    Wed Dec 28 14:41:26 2011 NOTE: OpenVPN 2.1 requires '--script-security 2' or higher to call user-defined scripts or executables
    Wed Dec 28 14:41:26 2011 Diffie-Hellman initialized with 2048 bit key
    .
    .
    Wed Dec 28 14:41:54 2011 bugs/95.126.136.73:48904 MULTI: primary virtual IP for bugs/95.126.136.73:48904: 10.8.0.6
    Wed Dec 28 14:41:57 2011 bugs/95.126.136.73:48904 PUSH: Received control message: 'PUSH_REQUEST'
    Wed Dec 28 14:41:57 2011 bugs/95.126.136.73:48904 SENT CONTROL [bugs]: 'PUSH_REPLY,route 10.8.0.1,topology net30,ping 10,ping-restart 120,ifconfig 10.8.0.6 10.8.0.5' (status=1)

    # openvpn /etc/openvpn/client/client.conf
    Wed Dec 28 14:41:50 2011 OpenVPN 2.2.1 i686-pc-linux-gnu [SSL] [LZO2] [EPOLL] [eurephia] built on Aug 13 2011
    Wed Dec 28 14:41:50 2011 NOTE: OpenVPN 2.1 requires '--script-security 2' or higher to call user-defined scripts or executables
    .
    .
    Wed Dec 28 14:41:57 2011 GID set to nobody
    Wed Dec 28 14:41:57 2011 UID set to nobody
    Wed Dec 28 14:41:57 2011 Initialization Sequence Completed

[Find the IP address](https://wiki.archlinux.org/index.php/Network_configuration#IP_addresses) assigned to the tunX interface on the server, and ping it from the client.

Find the IP address assigned to the tunX interface on the client, and ping it from the server.

Note: If using a firewall, make sure that IP packets on the TUN device are not blocked.

### Configure the MTU with Fragment and MSS

If experiencing issues when using (remote) services over OpenVPN (e.g. web browsing, [DNS](https://wiki.archlinux.org/index.php/DNS), [NFS](https://wiki.archlinux.org/index.php/NFS)), it may be needed to set a MTU value manually.

The following message may indicate the MTU value should be adjusted:

    read UDPv4 [EMSGSIZE Path-MTU=1407]: Message too long (code=90)

In order to get the maximum segment size (MSS), the client needs to discover the smallest MTU along the path to the server. In order to do this ping the server and disable fragmentation, then specify the maximum packet size [[3]](https://www.sonassi.com/help/troubleshooting/setting-correct-mtu-for-openvpn):

    # ping -M do -s 1500 -c 1 example.com

Decrease the 1500 value by 10 each time, until the ping succeeds.

Note: Clients that do not support the 'fragment' directive (e.g. OpenELEC, [iOS app](https://docs.openvpn.net/connecting/connecting-to-access-server-with-apple-ios/faq-regarding-openvpn-connect-ios/)) are not able to connect to a server that uses the `fragment` directive. See `mtu-test` as alternative solution.

Update the client configuration to use the succeeded MTU value, e.g.:

    /etc/openvpn/client/client.conf
    remote example.com 1194
    ...
    tun-mtu 1400 
    mssfix 1360

OpenVPN may be instructed to test the MTU every time on client connect. Be patient, since the client may not inform about the test being run and the connection may appear as nonfunctional until finished. The following will add about 3 minutes to OpenVPN start time. It is advisable to configure the fragment size unless a client will be connecting over many different networks and the bottle neck is not on the server side:

    /etc/openvpn/client/client.conf
    remote example.com 1194
    ...
    mtu-test
    ...

### IPv6

#### Connect to the server via IPv6

Starting from OpenVPN 2.4, OpenVPN will use `AF_INET` defined by the OS when just using `proto udp` or `proto tcp`, which in most cases will be IPv4 only. To use both IPv4 and IPv6, use `proto udp6` or `proto tcp6`. To enforce only IPv4-only, you need to use `proto udp4` or `proto tcp4`. On older OpenVPN versions, one server instance can only support either IPv4 or IPv6.

#### Provide IPv6 inside the tunnel

In order to provide IPv6 inside the tunnel, have an IPv6 prefix routed to the OpenVPN server. Either set up a static route on the gateway (if a static block is assigned), or use a DHCPv6 client to get a prefix with DHCPv6 Prefix delegation (see [IPv6 Prefix delegation](https://wiki.archlinux.org/index.php/IPv6#Prefix_delegation_(DHCPv6-PD)) for details). Also consider using a unique local address from the address block fc00::/7. Both methods have advantages and disadvantages:

- Many ISPs only provide dynamically changing IPv6 prefixes. OpenVPN does not support prefix changes, so change the server.conf every time the prefix is changed (Maybe can be automated with a script).
- ULA addresses are not routed to the Internet, and setting up NAT is not as straightforward as with IPv4. This means one cannot route the entire traffic over the tunnel. Those wanting to connect two sites via IPv6, without the need to connect to the Internet over the tunnel, may want to use the ULA addresses for ease.

Alternatively, if you have no access to these mentioned methods, an NDP proxy should work. See [this StackExchange post](https://unix.stackexchange.com/questions/136211/routing-public-ipv6-traffic-through-openvpn-tunnel).

After having received a prefix (a /64 is recommended), append the following to the server.conf:

    server-ipv6 2001:db8:0:123::/64

This is the IPv6 equivalent to the default 10.8.0.0/24 network of OpenVPN and needs to be taken from the DHCPv6 client. Or use for example fd00:1234::/64.

Those wanting to push a route to a home network (192.168.1.0/24 equivalent), need to also append:

    push "route-ipv6 2001:db8:0:abc::/64"

OpenVPN does not yet include DHCPv6, so there is no method to e.g. push DNS server over IPv6. This needs to be done with IPv4. The [OpenVPN Wiki](https://community.openvpn.net/openvpn/wiki/IPv6) provides some other configuration options.

## Starting OpenVPN

### Manual startup

To troubleshoot a VPN connection, start the client's daemon manually with `openvpn /etc/openvpn/client/client.conf` as root. The server can be started the same way using its own configuration file (e.g., `openvpn /etc/openvpn/server/server.conf`).

### systemd service configuration

To start the OpenVPN server automatically at system boot, [enable](https://wiki.archlinux.org/index.php/Enable) `openvpn-server@configuration.service` on the applicable machine. For a client, [enable](https://wiki.archlinux.org/index.php/Enable) `openvpn-client@configuration.service` instead. (Leave `.conf` out of the `configuration` string.)

For example, if the client configuration file is `/etc/openvpn/client/client.conf`, the service name is `openvpn-client@client.service`. Or, if the server configuration file is `/etc/openvpn/server/server.conf`, the service name is `openvpn-server@server.service`.

Tip: If `openvpn-client@configuration.service` units take a long time to start, it might be that your network manager is not triggering the `network-online.target` systemd target at the right moment. For example, if you are using [systemd-networkd](https://wiki.archlinux.org/index.php/Systemd-networkd), you might want to properly configure `systemd-networkd-wait-online.service`.

### Letting NetworkManager start a connection

One might not always need to run a VPN tunnel and/or only want to establish it for a specific NetworkManager connection. This can be done by adding a script to `/etc/NetworkManager/dispatcher.d/`. In the following example "Provider" is the name of the NetworkManager connection:

/etc/NetworkManager/dispatcher.d/10-openvpn

    #!/bin/bash
    
    case "$2" in
      up)
        if [ "$CONNECTION_ID" == "Provider" ]; then
          systemctl start openvpn-client@<configuration>
        fi
      ;;
      down)
        systemctl stop openvpn-client@<configuration>
      ;;
    esac

See [NetworkManager#Network services with NetworkManager dispatcher for more details](https://wiki.archlinux.org/index.php/NetworkManager#Network_services_with_NetworkManager_dispatcher).

### Gnome configuration

To connect to an OpenVPN server through Gnome's built-in network configuration do the following. First, install [networkmanager-openvpn](https://archlinux.org/packages/?name=networkmanager-openvpn). Then go to the Settings menu and choose Network. Click the plus sign to add a new connection and choose VPN. From there, choose OpenVPN and manually enter the settings. One can optionally import [#The client config profile](https://wiki.archlinux.org/index.php/OpenVPN#The_client_config_profile). Yet, be aware NetworkManager does not show error messages for options it does not import. To connect to the VPN simply turn the connection on and check the options are applied (e.g. via `journalctl -b -u NetworkManager`).

## Routing client traffic through the server

Without further configuration only traffic directly to and from the OpenVPN server's IP passes through the VPN. To have other traffic, like web traffic pass through the VPN, correspondent routes must be added. You can either add routes in the client's configuration or configure the server to push these routes to the client.

To redirect traffic to and from a subnet of the server, add `push "route <address pool> <subnet>"` right before the `remote <address> <port> udp/tcp`, like:

    route 192.168.1.0 255.255.255.0

To redirect all traffic including Internet traffic to the server, add the following in the client's configuration:

    redirect-gateway def1 bypass-dhcp ipv6

If you are running an IPv4-only server, drop the `ipv6` option. If you are going IPv6-only, use `redirect-gateway ipv6 !ipv4`.

To make the server push routes, [append](https://wiki.archlinux.org/index.php/Append) `push "redirect-gateway def1 bypass-dhcp ipv6"` to the configuration file (i.e. `/etc/openvpn/server/server.conf`) [[4]](http://openvpn.net/index.php/open-source/documentation/howto.html#redirect) of the server. Note this is not a requirement and may even give performance issue:

    push "redirect-gateway def1 bypass-dhcp ipv6"

If you are running an IPv4-only server, drop the `ipv6` option. If you are going IPv6-only, use `push "redirect-gateway ipv6 !ipv4"`

Use the `push "route <address pool> <subnet>"` option to allow clients reaching other subnets/devices behind the server:

    push "route 192.168.1.0 255.255.255.0"
    push "route 192.168.2.0 255.255.255.0"

Optionally, push local [DNS](https://wiki.archlinux.org/index.php/DNS) settings to clients (e.g. the DNS-server of the router and domain prefix .internal):

Note: One may need to use a simple [DNS](https://wiki.archlinux.org/index.php/DNS) forwarder like [BIND](https://wiki.archlinux.org/index.php/BIND) and push the IP address of the OpenVPN server as DNS to clients.

    push "dhcp-option DNS 192.168.1.1"
    push "dhcp-option DOMAIN internal"

After setting up the configuration file, [enable packet forwarding](https://wiki.archlinux.org/index.php/Internet_sharing#Enable_packet_forwarding) on the server. Additionally, the server's [firewall](https://wiki.archlinux.org/index.php/Firewall) needs to be adjusted to allow VPN traffic, which is described below for both [ufw](https://wiki.archlinux.org/index.php/OpenVPN#ufw) and [iptables](https://wiki.archlinux.org/index.php/OpenVPN#iptables).

Note: There are potential pitfalls when routing all traffic through a VPN server. Refer to the [OpenVPN documentation](http://openvpn.net/index.php/open-source/documentation/howto.html#redirect) for more information.

### Firewall configuration

#### firewalld

If you use the default port 1194, enable the `openvpn` service. Otherwise, create a new service with a different port.

    # firewall-cmd --zone=public --add-service openvpn

Now add masquerade to the zone:

    # firewall-cmd --zone=FedoraServer --add-masquerade

Make these changes permanent:

    # firewall-cmd --runtime-to-permanent

#### ufw

In order to allow [ufw](https://wiki.archlinux.org/index.php/Ufw) forwarding (VPN) traffic [append](https://wiki.archlinux.org/index.php/Append) the following to `/etc/default/ufw`:

/etc/default/ufw

    DEFAULT_FORWARD_POLICY="ACCEPT"

Change `/etc/ufw/before.rules`, and [append](https://wiki.archlinux.org/index.php/Append) the following code after the header and before the "*filter" line:

- Change the IP/subnet mask to match the `server` set in the OpenVPN server configuration.
- Change the [network interface](https://wiki.archlinux.org/index.php/Network_configuration#Check_the_connection) to the connection used by OpenVPN server.

/etc/ufw/before.rules

    # NAT (Network Address Translation) table rules
    *nat
    :POSTROUTING ACCEPT [0:0]

    # Allow traffic from clients to the interface
    -A POSTROUTING -s 10.8.0.0/24 -o interface -j MASQUERADE

    # Optionally duplicate this line for each subnet if your setup requires it
    -A POSTROUTING -s 10.8.1.0/24 -o interface -j MASQUERADE

    # do not delete the "COMMIT" line or the NAT table rules above will not be processed
    COMMIT

    # Don't delete these required lines, otherwise there will be errors
    *filter
    ..

Make sure to open the chosen OpenVPN port (default 1194/udp):

    # ufw allow 1194/udp

To apply the changes. [reload](https://wiki.archlinux.org/index.php/Reload)/[restart](https://wiki.archlinux.org/index.php/Restart) ufw:

    # ufw reload

#### iptables

In order to allow VPN traffic through an [iptables](https://wiki.archlinux.org/index.php/Iptables) firewall, first create an iptables rule for NAT forwarding [[5]](http://openvpn.net/index.php/open-source/documentation/howto.html#redirect) on the server. An example (assuming the interface to forward to is named `eth0`):

    # iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

If running multiple servers on different IP pools, add a corresponding line for each one, for example:

    # iptables -t nat -A POSTROUTING -s 10.8.1.0/24 -o eth0 -j MASQUERADE

If the server cannot be pinged through the VPN, one may need to add explicit rules to open up TUN/TAP interfaces to all traffic. If that is the case, do the following [[6]](https://community.openvpn.net/openvpn/wiki/255-qconnection-initiated-with-xxxxq-but-i-cannot-ping-the-server-through-the-vpn):

Warning: There are security implications for the following rules if one does not trust all clients which connect to the server. Refer to the [OpenVPN documentation on this topic](https://community.openvpn.net/openvpn/wiki/255-qconnection-initiated-with-xxxxq-but-i-cannot-ping-the-server-through-the-vpn) for more details.

    # iptables -A INPUT -i tun+ -j ACCEPT
    # iptables -A FORWARD -i tun+ -j ACCEPT
    # iptables -A INPUT -i tap+ -j ACCEPT
    # iptables -A FORWARD -i tap+ -j ACCEPT

Additionally be sure to accept connections from the OpenVPN port (default 1194) and through the physical interface:

    # iptables -A INPUT -i eth0 -m state --state NEW -p udp --dport 1194 -j ACCEPT
    # iptables -A FORWARD -i tun+ -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    # iptables -A FORWARD -i eth0 -o tun+ -m state --state RELATED,ESTABLISHED -j ACCEPT
    # iptables -A FORWARD -i tap+ -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    # iptables -A FORWARD -i eth0 -o tap+ -m state --state RELATED,ESTABLISHED -j ACCEPT

When satisfied, make the changes permanent as shown in [iptables#Configuration and usage](https://wiki.archlinux.org/index.php/Iptables#Configuration_and_usage).

Those with multiple `tun` or `tap` interfaces, or more than one VPN configuration can "pin" the name of the interface by specifying it in the OpenVPN config file, e.g. `tun22` instead of `tun`. This is advantageous if different firewall rules for different interfaces or OpenVPN configurations are wanted.

### Prevent leaks if VPN goes down

This prevents all traffic through the default interface (enp3s0 for example) and only allows traffic through tun0. If the OpenVPN connection drops, the system will lose its internet access thereby preventing connections through the default network interface.

One may want to set up a script to restart OpenVPN if it goes down.

#### ufw

    # Default policies
    ufw default deny incoming
    ufw default deny outgoing
    
    # Openvpn interface (adjust interface accordingly to your configuration)
    ufw allow in on tun0
    ufw allow out on tun0
    
    # Local Network (adjust ip accordingly to your configuration)
    ufw allow in on enp3s0 from 192.168.1.0/24
    ufw allow out on enp3s0 to 192.168.1.0/24
    
    # Openvpn (adjust port accordingly to your configuration)
    ufw allow in on enp3s0 from any port 1194
    ufw allow out on enp3s0 to any port 1194

Warning: DNS will not work unless running a dedicated DNS server like [BIND](https://wiki.archlinux.org/index.php/BIND).

Alternatively, one can allow DNS leaks. Be sure to trust your DNS server!

    # DNS
    ufw allow in from any to any port 53
    ufw allow out from any to any port 53

#### vpnfailsafe

Alternatively, the [vpnfailsafe](https://github.com/wknapik/vpnfailsafe) ([vpnfailsafe-git](https://aur.archlinux.org/packages/vpnfailsafe-git/)) script can be used by the client to prevent DNS leaks and ensure that all traffic to the internet goes over the VPN. If the VPN tunnel goes down, internet access will be cut off, except for connections to the VPN server(s). The script contains the functionality of [update-resolv-conf](https://wiki.archlinux.org/index.php/OpenVPN#The_update-resolv-conf_custom_script), so the two do not need to be combined.

## Layer-3 IPv4 routing

This section describes how to connect client/server LANs to each other using Layer-3 IPv4 routing.

### Prerequisites for routing a LAN

For a host to be able to forward IPv4 packets between the LAN and VPN, it must be able to forward the packets between its NIC and its tun/tap device. See [Internet sharing#Enable packet forwarding](https://wiki.archlinux.org/index.php/Internet_sharing#Enable_packet_forwarding) for configuration details.

#### Routing tables

By default, all IP packets on a LAN addressed to a different subnet get sent to the default gateway. If the LAN/VPN gateway is also the default gateway, there is no problem and the packets get properly forwarded. If not, the gateway has no way of knowing where to send the packets. There are a couple of solutions to this problem.

- Add a static route to the default gateway routing the VPN subnet to the LAN/VPN gateway's IP address.
- Add a static route on each host on the LAN that needs to send IP packets back to the VPN.
- Use [iptables](https://wiki.archlinux.org/index.php/Iptables)' NAT feature on the LAN/VPN gateway to masquerade the incoming VPN IP packets.

### Connect the server LAN to a client

The server is on a LAN using the 10.66.0.0/24 subnet. To inform the client about the available subnet, add a push directive to the server configuration file:

/etc/openvpn/server/server.conf

    push "route 10.66.0.0 255.255.255.0"

Note: To route more LANs from the server to the client, add more push directives to the server configuration file, but keep in mind that the server side LANs will need to know how to route to the client.

### Connect the client LAN to a server

Prerequisites:

- Any subnets used on the client side, must be unique and not in use on the server or by any other client. In this example we will use 192.168.4.0/24 for the clients LAN.
- Each client's certificate has a unique Common Name, in this case bugs.
- The server may not use the duplicate-cn directive in its config file.
- The CCD folder must be accessible via user and group defined in the server config file (typically nobody:nobody)

Create a client configuration directory on the server. It will be searched for a file named the same as the client's common name, and the directives will be applied to the client when it connects.

    # mkdir -p /etc/openvpn/ccd

Create a file in the client configuration directory called bugs, containing the `iroute 192.168.4.0 255.255.255.0` directive. It tells the server what subnet should be routed to the client:

/etc/openvpn/ccd/bugs

    iroute 192.168.4.0 255.255.255.0

Add the client-config-dir and the `route 192.168.4.0 255.255.255.0` directive to the server configuration file. It tells the server what subnet should be routed from the tun device to the server LAN:

/etc/openvpn/server/server.conf

    client-config-dir ccd
    route 192.168.4.0 255.255.255.0

Note: To route more LANs from the client to the server, add more iroute and route directives to the appropriate configuration files, but keep in mind that the client side LANs will need to know how to route to the server.

### Connect both the client and server LANs

Combine the two previous sections:

/etc/openvpn/server/server.conf

    push "route 10.66.0.0 255.255.255.0"
    .
    .
    client-config-dir ccd
    route 192.168.4.0 255.255.255.0

/etc/openvpn/ccd/bugs

    iroute 192.168.4.0 255.255.255.0

Note: Remember to make sure that all the LANs or the needed hosts can route to all the destinations.

### Connect clients and client LANs

By default clients will not see each other. To allow IP packets to flow between clients and/or client LANs, add a client-to-client directive to the server configuration file:

/etc/openvpn/server/server.conf

    client-to-client

In order for another client or client LAN to see a specific client LAN, add a push directive for each client subnet to the server configuration file (this will make the server announce the available subnet(s) to other clients):

/etc/openvpn/server/server.conf

    client-to-client
    push "route 192.168.4.0 255.255.255.0"
    push "route 192.168.5.0 255.255.255.0"
    ..

Note: One may need to adjust the firewall to allow client traffic passing through the VPN server.

## DNS

For Linux, the OpenVPN client can receive DNS host information from the server, but the client expects an external command to act on this information. No such commands are configured by default. They must be specified with the `up` and `down` config options. There are a few alternatives for what scripts to use, but none are officially recognised by OpenVPN, so in order for any of them to work, `script-security` must be set to 2. The `down-root` plugin can be used instead of the `down` option if [running as an unprivileged user](https://wiki.archlinux.org/index.php/OpenVPN#Run_as_unprivileged_user).

### The pull-resolv-conf custom scripts

These scripts are [maintained by](https://github.com/OpenVPN/openvpn/tree/master/contrib/pull-resolv-conf) OpenVPN. They are `client.up` and `client.down`, and they are packaged in `/usr/share/openvpn/contrib/pull-resolv-conf/`. The following is an excerpt of a resulting client configuration using the scripts in conjunction with the `down-root` plugin:

/etc/openvpn/client/clienttunnel.conf

    user nobody
    group nobody
    # Optional, choose a suitable path to chroot into
    chroot /srv
    script-security 2
    up /usr/share/openvpn/contrib/pull-resolv-conf/client.up 
    plugin /usr/lib/openvpn/plugins/openvpn-plugin-down-root.so "/usr/share/openvpn/contrib/pull-resolv-conf/client.down tun0"

These scripts use the `resolvconf` command if present. [Systemd-resolvconf](https://wiki.archlinux.org/index.php/Systemd-resolvconf) and [Openresolv](https://wiki.archlinux.org/index.php/Openresolv) both implement this command. See their wiki pages for more information on getting a working `resolvconf` implementation.

Note: As of October 2019, systemd-resolvconf works as long as the systemd-resolved service is running. Openresolv will not work out of the box because `client.up` will only create private DNS server entries. These require extra configuration of openresolv to work. See `man 8 resolvconf` for more details on private DNS servers in openresolv.

If no implementation of `resolvconf` is present, `client.up` preserves the existing `resolv.conf` at `/etc/resolv.conf.ovpnsave` and writes a new one. This new one will not have any of the original DNS servers.

If you need to edit these scripts, copy them somewhere else and edit them there, so that your changes don't get overwritten by the next [openvpn](https://archlinux.org/packages/?name=openvpn) package upgrade. `/etc/openvpn/client` is a pretty good place.

    # cp /usr/share/openvpn/contrib/pull-resolv-conf/* /etc/openvpn/client
    # $EDITOR /etc/openvpn/client/client.{up.,down}
    # # etc ...

### The update-resolv-conf custom script

Note: Another script, [update-systemd-resolved](https://wiki.archlinux.org/index.php/OpenVPN#The_update-systemd-resolved_custom_script), is recommended by the author of update-resolv-conf for systems with systemd.

The [openvpn-update-resolv-conf](https://github.com/masterkorp/openvpn-update-resolv-conf) script is available as an alternative to packaged scripts. It needs to be saved for example at `/etc/openvpn/update-resolv-conf` and made [executable](https://wiki.archlinux.org/index.php/Executable).

If you prefer a package, there is [openvpn-update-resolv-conf-git](https://aur.archlinux.org/packages/openvpn-update-resolv-conf-git/) that does above for you. You still need to do the following.

Once the script is installed add lines like the following into the OpenVPN client configuration file:

    script-security 2
    up /etc/openvpn/update-resolv-conf
    down /etc/openvpn/update-resolv-conf

Note: If manually placing the script on the filesystem, be sure to have [openresolv](https://archlinux.org/packages/?name=openresolv) installed.

Now, when launching the OpenVPN connection, `resolv.conf` should be updated accordingly, and also should get returned to normal when the connection is closed.

Note: When using `openresolv` with the -p or -x options in a script (as both the included `client.up` and `update-resolv-conf` scripts currently do), a DNS resolver like [dnsmasq](https://archlinux.org/packages/?name=dnsmasq) or [unbound](https://archlinux.org/packages/?name=unbound) is required for `openresolv` to correctly update `/etc/resolv.conf`. In contrast, when using the default DNS resolution from `libc` the -p and -x options must be removed in order for `/etc/resolv.conf` to be correctly updated by openresolv. For example, if the script contains a command like `resolvconf -p -a` and the default DNS resolver from `libc` is being used, change the command in the script to be `resolvconf -a`.

### The update-systemd-resolved custom script

Note: Since [systemd](https://wiki.archlinux.org/index.php/Systemd) 229, [systemd-networkd](https://wiki.archlinux.org/index.php/Systemd-networkd) has exposed an API through DBus allowing management of DNS configuration on a per-link basis. Tools such as [openresolv](https://archlinux.org/packages/?name=openresolv) may not work reliably when `/etc/resolv.conf` is managed by `systemd-resolved`, and will not work at all if using `resolve` instead of `dns` in `/etc/nsswitch.conf`.

The [update-systemd-resolved](https://github.com/jonathanio/update-systemd-resolved) script links OpenVPN with `systemd-resolved` via DBus to update the DNS records.

Copy the script into `/etc/openvpn/scripts` and mark as [executable](https://wiki.archlinux.org/index.php/Executable) (or [install](https://wiki.archlinux.org/index.php/Install) [openvpn-update-systemd-resolved](https://aur.archlinux.org/packages/openvpn-update-systemd-resolved/)) and [append](https://wiki.archlinux.org/index.php/Append) the following lines into the OpenVPN client configuration file:

/etc/openvpn/client/client.conf

    client
    remote example.com 1194 udp
    ..
    script-security 2
    setenv PATH /usr/bin
    up /etc/openvpn/scripts/update-systemd-resolved
    down /etc/openvpn/scripts/update-systemd-resolved
    down-pre

In order to send all DNS traffic through the VPN tunnel and prevent DNS leaks, also add the following line (see [[7]](https://github.com/jonathanio/update-systemd-resolved#dns-leakage)):

/etc/openvpn/client/client.conf

    dhcp-option DOMAIN-ROUTE .

Make sure that the [systemd-resolved](https://wiki.archlinux.org/index.php/Systemd-resolved) service is configured and running. Also, since openvpn 2.5.0-3 scripts are running as openvpn user instead of root. Thus, you need to add a PolicyKit rule to allow OpenVPN systemd units to call DBus with SetLinkDNS:

/etc/polkit-1/rules.d/00-openvpn-resolved.rules

    polkit.addRule(function(action, subject) {
        if (action.id == 'org.freedesktop.resolve1.set-dns-servers' ||
            action.id == 'org.freedesktop.resolve1.set-domains' ||
            action.id == 'org.freedesktop.resolve1.set-dnssec') {
            if (subject.user == 'openvpn') {
                return polkit.Result.YES;
            }
        }
    });

### Override DNS servers using NetworkManager

By default [networkmanager-openvpn](https://archlinux.org/packages/?name=networkmanager-openvpn) plugin appends DNS servers provided by OpenVPN to `/etc/resolv.conf`.

To verify that the correct DNS server(s) are configured, see `resolvectl status` if systemd-resolved is in use, for other resolvers see [Domain name resolution](https://wiki.archlinux.org/index.php/Domain_name_resolution).

## Layer-2 Ethernet bridging

For now see: [OpenVPN Bridge](https://wiki.archlinux.org/index.php/OpenVPN_Bridge)

## Config generators

Warning: Users are highly recommended to pass through the manual configuration described above to gain knowledge about options and usage before using any additional automation scripts.

### ovpngen

The [ovpngen](https://aur.archlinux.org/packages/ovpngen/) package provides a simple shell script that creates OpenVPN compatible tunnel profiles in the unified file format suitable for the OpenVPN Connect app for Android and iOS.

Simply invoke the script with 5 tokens:

1. Server Fully Qualified Domain Name of the OpenVPN server (or IP address).
2. Full path to the CA cert.
3. Full path to the client cert.
4. Full path to the client private key.
5. Full path to the server TLS shared secret key.
6. Optionally a port number.
7. Optionally a protocol (udp or tcp).

Example:

    # ovpngen example.org /etc/openvpn/server/ca.crt /etc/easy-rsa/pki/signed/client1.crt /etc/easy-rsa/pki/private/client1.key /etc/openvpn/server/ta.key > foo.ovpn

If the server is configured to use tls-crypt, as is suggested in [#The server configuration file](https://wiki.archlinux.org/index.php/OpenVPN#The_server_configuration_file), [manually edit](https://github.com/graysky2/ovpngen/issues/4) the resulting `foo.ovpn` replacing `<tls-auth>` and `</tls-auth>` with `<tls-crypt>` and `</tls-crypt>`.

The resulting `foo.ovpn` can be edited if desired as the script does insert some commented lines. `foo.ovpn` will not automatically route all traffic through the VPN, so you may want to follow [#Routing client traffic through the server](https://wiki.archlinux.org/index.php/OpenVPN#Routing_client_traffic_through_the_server) to enable redirection.

The client expects this file to be located in `/etc/openvpn/client/foo.conf`. Note the change in file extension from 'ovpn' to 'conf' in this case.

Tip: If the server.conf contains a specified cipher and/or auth line, it is highly recommended that users manually edit the generated .ovpn file adding matching lines for cipher and auth. Failure to do so may results in connection errors!

### openvpn-unroot

Note: If you intend to use a custom script, perhaps for configuring [#DNS](https://wiki.archlinux.org/index.php/OpenVPN#DNS), you must add these scripts to your config before calling openvpn-unroot on it. Failing to do so will cause problems if the scripts require root permissions.

The steps necessary for OpenVPN to [#Run as unprivileged user](https://wiki.archlinux.org/index.php/OpenVPN#Run_as_unprivileged_user), can be performed automatically using [openvpn-unroot](https://github.com/wknapik/openvpn-unroot) ([openvpn-unroot-git](https://aur.archlinux.org/packages/openvpn-unroot-git/)).

It automates the actions required for the [OpenVPN howto](https://community.openvpn.net/openvpn/wiki/UnprivilegedUser) by adapting it to systemd, and also working around the bug for persistent tun devices mentioned in the note.

## Troubleshooting

### Client daemon not reconnecting after suspend

[openvpn-reconnect](https://aur.archlinux.org/packages/openvpn-reconnect/), available on the AUR, solves this problem by sending a SIGHUP to openvpn after waking up from suspend.

Alternatively, restart OpenVPN after suspend by creating the following systemd service:

/etc/systemd/system/openvpn-reconnect.service

    [Unit]
    Description=Restart OpenVPN after suspend

    [Service]
    ExecStart=/usr/bin/pkill --signal SIGHUP --exact openvpn

    [Install]
    WantedBy=sleep.target

[Enable](https://wiki.archlinux.org/index.php/Enable) this service for it to take effect.

### Connection drops out after some time of inactivity

If the VPN-Connection drops some seconds after it stopped transmitting data and, even though it states it is connected, no data can be transmitted through the tunnel, try adding a `keepalive` directive to the server's configuration:

/etc/openvpn/server/server.conf

    .
    .
    keepalive 10 120
    .
    .

In this case the server will send ping-like messages to all of its clients every 10 seconds, thus keeping the tunnel up. If the server does not receive a response within 120 seconds from a specific client, it will assume this client is down.

A small ping-interval can increase the stability of the tunnel, but will also cause slightly higher traffic. Depending on the connection, also try lower intervals than 10 seconds.

### PID files not present

The default systemd service file for openvpn-client does not have the --writepid flag enabled, despite creating /run/openvpn-client. If this breaks a config (such as an i3bar VPN indicator), simply change `openvpn-client@.service` using a [drop-in snippet](https://wiki.archlinux.org/index.php/Drop-in_snippet):

    [Service]
    ExecStart=
    ExecStart=/usr/sbin/openvpn --suppress-timestamps --nobind --config %i.conf --writepid /run/openvpn-client/%i.pid

### Route configuration fails with systemd-networkd

When using [systemd-networkd](https://wiki.archlinux.org/index.php/Systemd-networkd) to manage network connections and attempting to tunnel all outgoing traffic through the VPN, OpenVPN may fail to add routes. This is a result of systemd-networkd attempting to manage the tun interface before OpenVPN finishes configuring the routes. When this happens, the following message will appear in the OpenVPN log.

    openvpn[458]: RTNETLINK answers: Network is unreachable
    openvpn[458]: ERROR: Linux route add command failed: external program exited with error status: 2

From systemd-233, systemd-networkd can be configured to ignore the tun connections and allow OpenVPN to manage them. To do this, create the following file:

/etc/systemd/network/90-tun-ignore.network

    [Match]
    Name=tun*

    [Link]
    Unmanaged=true

[Restart](https://wiki.archlinux.org/index.php/Restart) `systemd-networkd.service` to apply the changes. To verify that the changes took effect, start the previously problematic OpenVPN connection and run `networkctl`. The output should have a line similar to the following:

    7 tun0             none               routable    unmanaged

### tls-crypt unwrap error: packet too short

This error shows up in the server log when a client that does not support tls-crypt, or a client that is misconfigured to use tls-auth while the server is configured to use tls-crypt, attempts to connect.

To support clients that do not support tls-crypt, replace `tls-crypt ta.key` with `tls-auth ta.key 0` (the default) in `server.conf`. Also replace `tls-crypt ta.key` with `tls-auth ta.key 1` (the default) in `client.conf`.

## See also

- [Wikipedia:OpenVPN](https://en.wikipedia.org/wiki/OpenVPN)

- [Securing Network Communication with Stunnel, OpenSSH, and OpenVPN](https://www.infosecwriters.com/text_resources/pdf/securing_communication.pdf) (PDF)
