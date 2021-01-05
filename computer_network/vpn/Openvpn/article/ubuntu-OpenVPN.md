# [OpenVPN](https://help.ubuntu.com/community/OpenVPN)

- [OpenVPN](#openvpn)
  - [Overview](#overview)
  - [What is a bridged VPN?](#what-is-a-bridged-vpn)
  - [Setting up a Bridged VPN using OpenVPN](#setting-up-a-bridged-vpn-using-openvpn)
    - [Installing the Server](#installing-the-server)
      - [Setting up the Bridge](#setting-up-the-bridge)
        - [1. Edit /etc/network/interfaces](#1-edit-etcnetworkinterfaces)
        - [2. If you are running Linux inside a virtual machine, you may want to add the following parameters to the bridge connection:](#2-if-you-are-running-linux-inside-a-virtual-machine-you-may-want-to-add-the-following-parameters-to-the-bridge-connection)
        - [3. Restart networking:](#3-restart-networking)
      - [Generating Certificates](#generating-certificates)
        - [Step 1](#step-1)
        - [Step 2](#step-2)
        - [Step 3](#step-3)
      - [Configuring the Server](#configuring-the-server)
        - [Pre-systemd setup](#pre-systemd-setup)
        - [systemd setup](#systemd-setup)
        - [Firewall notes](#firewall-notes)
    - [Getting Clients Connected](#getting-clients-connected)
      - [Generating Client Certificate and Key](#generating-client-certificate-and-key)
      - [Configuring the Client](#configuring-the-client)
    - [Firestarter configuration for OpenVPN](#firestarter-configuration-for-openvpn)
  - [Other Resources](#other-resources)

## Overview

OpenVPN is a Virtual Private Networking (VPN) solution provided in the Ubuntu Repositories. It is flexible, reliable and secure. It belongs to the family of SSL/TLS VPN stacks (different from IPSec VPNs).

This page refers to the community version of the OpenVPN server. Setup examples are also provided on the [OpenVPN community website](http://www.openvpn.net/index.php/open-source.html). There is also a [commercial Web GUI](http://openvpn.net/) which might be easier to set up and maintain, especially for non-experts, and which allows clients to download VPN configurations themselves using the web browser.

## What is a bridged VPN?

A bridged VPN allows the clients to appear as though they are on the same local area network (LAN) as the server system. The VPN accomplishes this by using a combination of virtual devices -- one called a "bridge" and the other called a "tap device". A tap device acts as a virtual Ethernet adapter and the bridge device acts as a virtual hub. When you bridge a physical Ethernet device and a tap device, you are essentially creating a hub between the physical network and the remote clients. Therefore, all LAN services are visible to the remote clients.

## Setting up a Bridged VPN using OpenVPN

Note that good networking knowledge and enough time is required to follow this manual setup guide. These instructions are for setting up a Bridged VPN on Ubuntu 8.04 using x509 certs and some general administration tasks.

This example installation was performed using Ubuntu Jeos 8.04 in a KVM virtual machine (but could just have easily been performed on a standalone Ubuntu Server). In my configuration eth0 is connected to the Internet and eth1 is connected to the LAN network that will be bridged. Comments in configuration files are preceeded by two pound signs (##).

### Installing the Server

Install OpenVPN:

    sudo apt-get install openvpn bridge-utils

#### Setting up the Bridge

##### 1. Edit /etc/network/interfaces

When a Linux server is behind a NAT firewall, the /etc/network/interfaces file commonly looks like

    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    # The loopback network interface
    auto lo eth0
    iface lo inet loopback

    # The primary network interface
    ## This device provides internet access.
    iface eth0 inet static
      address 192.168.1.10
      netmask 255.255.255.0
      gateway 192.168.1.1

Edit this and add a bridge interface:

    sudo nano /etc/network/interfaces

so that it look similar to:

    ## This is the network bridge declaration

    ## Start these interfaces on boot
    auto lo br0

    iface lo inet loopback

    iface br0 inet static 
      address 192.168.1.10 
      netmask 255.255.255.0
      gateway 192.168.1.1
      bridge_ports eth0

    iface eth0 inet manual
      up ip link set $IFACE up promisc on
      down ip link set $IFACE down promisc off

##### 2. If you are running Linux inside a virtual machine, you may want to add the following parameters to the bridge connection:

    bridge_fd 9      ## from the libvirt docs (forward delay time)
    bridge_hello 2   ## from the libvirt docs (hello time)
    bridge_maxage 12 ## from the libvirt docs (maximum message age)
    bridge_stp off   ## from the libvirt docs (spanning tree protocol)

##### 3. Restart networking:

    sudo /etc/init.d/networking restart

The bridging declarations come from the libvirt documentation. (I really only understand the bridge_ports directive and the bridge_stp directive. Please add more instructions here.)

#### Generating Certificates

Generate certificates for the server. In order to do this I will setup my own Certificate Authority using the provided easy-rsa scripts in the /usr/share/doc/openvpn/examples/easy-rsa/ directory. Another alternative is using the graphical program tinyca to create your CA.

##### Step 1

Create a *new* directory and prepare it to be used as a (CA) key management directory (to create and store keys and certificates).
sudo make-cadir /etc/openvpn/easy-rsa/

##### Step 2

Edit /etc/openvpn/easy-rsa/vars

sudo vi /etc/openvpn/easy-rsa/vars

    Change these lines at the bottom so that they reflect your new CA.

    export KEY_COUNTRY="US"
    export KEY_PROVINCE="CA"
    export KEY_CITY="SanFrancisco"
    export KEY_ORG="Fort-Funston"
    export KEY_EMAIL="me@myhost.mydomain"

##### Step 3

Setup the CA and create the first server certificate

    cd /etc/openvpn/easy-rsa/ ## move to the easy-rsa directory
    sudo chown -R root:sudo .  ## make this directory owned by the system administrators
    sudo chmod g+w . ## make this directory writable by the system administrators
    source ./vars ## execute your new vars file
    ./clean-all  ## Setup the easy-rsa directory (Deletes all keys)
    ./build-dh  ## takes a while consider backgrounding
    ./pkitool --initca ## creates ca cert and key
    ./pkitool --server server ## creates a server cert and key
    ## If you get this error: 
    ##    "The correct version should have a comment that says: easy-rsa version 2.x"
    ## Try This:
    ##     sudo ln -s openssl-1.0.0.cnf openssl.cnf
    ## Refer to: https://bugs.launchpad.net/ubuntu/+source/openvpn/+bug/998918
    cd keys
    openvpn --genkey --secret ta.key  ## Build a TLS key
    sudo cp server.crt server.key ca.crt dh2048.pem ta.key ../../

The Certificate Authority is now setup and the needed keys are in /etc/openvpn/

#### Configuring the Server

By default all servers specified in *.conf files in the /etc/openvpn/ directory are started on boot. Therefore, all we have to do is creating a new file named server.conf in the /etc/openvpn/ directory.

First, we're going to create a couple of new scripts to be used by the openvpn server.

    sudo vi /etc/openvpn/up.sh

This script should contain the following

    #!/bin/sh

    BR=$1
    DEV=$2
    MTU=$3
    /sbin/ip link set "$DEV" up promisc on mtu "$MTU"
    /sbin/brctl addif $BR $DEV

Now, we'll create a "down" script.

    sudo vi /etc/openvpn/down.sh

It should contain the following.

    #!/bin/sh

    BR=$1
    DEV=$2

    /sbin/brctl delif $BR $DEV
    /sbin/ip link set "$DEV" down

Now, make both scripts executable.

    sudo chmod +x /etc/openvpn/up.sh /etc/openvpn/down.sh

And now on to configuring openvpn itself.

    sudo vi /etc/openvpn/server.conf

    mode server
    tls-server

    local <your ip address> ## ip/hostname of server
    port 1194 ## default openvpn port
    proto udp

    #bridging directive
    dev tap0 ## If you need multiple tap devices, add them here
    script-security 2 ## allow calling up.sh and down.sh
    up "/etc/openvpn/up.sh br0 tap0 1500"
    down "/etc/openvpn/down.sh br0 tap0"

    persist-key
    persist-tun

    #certificates and encryption
    ca ca.crt
    cert server.crt
    key server.key  # This file should be kept secret
    dh dh2048.pem
    tls-auth ta.key 0 # This file is secret

    cipher BF-CBC        # Blowfish (default)
    comp-lzo

    #DHCP Information
    ifconfig-pool-persist ipp.txt
    server-bridge 192.168.1.10 255.255.255.0 192.168.1.100 192.168.1.110
    push "dhcp-option DNS your.dns.ip.here"
    push "dhcp-option DOMAIN yourdomain.com"
    max-clients 10 ## set this to the max number of clients that should be connected at a time

    #log and security
    user nobody
    group nogroup
    keepalive 10 120
    status openvpn-status.log
    verb 3

The server initialization script will complain about WARN: could not open database for 4096 bits. Skipped and you can work around it by running this command:

    touch /usr/share/openssl-blacklist/blacklist.RSA-4096

##### Pre-systemd setup

Don't forget to either reboot or run the command below. This will restart openvpn and load the new config.

    sudo /etc/init.d/openvpn restart

##### systemd setup

For systemd, the /lib/systemd/system/openvpn@.service file is defined so that multiple OpenVPN servers can be active concurrently. This is accomplished by the %i in the service definition file, which will be used as the name of the configuration file. Since we created a server.conf file, use the following commands to enable OpenVPN:

    systemctl start openvpn@server
    systemctl enable openvpn@server

##### Firewall notes

In case you run a firewall like ufw, please consider enabling ip forwarding, otherwise the clients will only be able to connect to the server, but not to other LAN servers.

### Getting Clients Connected

This section concerns creating client certificate and key files and setting up a client configuration file. The files can then be used with OpenVPN on a client platform. The described configuration will work with OpenVPN installations of [OpenVPN GUI](http://openvpn.se/) for Windows and [Tunnelblick](http://code.google.com/p/tunnelblick/) for Mac OS X clients. For a detailed discussion of each, refer to their respective home pages. It should also be compatible with Linux OpenVPN clients.

#### Generating Client Certificate and Key

Generating certificates and keys for a client is very similar to the process used for generating server certificates. It is assumed that you have already set up the /etc/openvpn/easy-rsa/ directory and updated the /etc/openvpn/easy-rsa/vars file as described above. You should have already setup your Certificate Authority and created a server certificate and keys.

    cd /etc/openvpn/easy-rsa/ ## move to the easy-rsa directory
    source ./vars             ## execute the vars file
    ./pkitool client          ## create a cert and key named "client"
    ## Note: if you get a 'TXT_DB error number 2' error you may need to specify
    ## a unique KEY_CN, for example: KEY_CN=client ./pkitool client

#### Configuring the Client

The client configuration has been adapted from the OpenVPN 2.0 sample configuration file. For Windows, the file should be named client.ovpn and for other operating systems, the file should be named client.conf. The file can be created using vi or other editor that can create plain text files.

The configuration file assumes that there is only one TUN/TAP device configured on the client.

    ### Client configuration file for OpenVPN

    # Specify that this is a client
    client

    # Bridge device setting
    dev tap

    # Host name and port for the server (default port is 1194)
    # note: replace with the correct values your server set up
    remote your.server.example.com 1194

    # Client does not need to bind to a specific local port
    nobind

    # Keep trying to resolve the host name of OpenVPN server.
    ## The windows GUI seems to dislike the following rule. 
    ##You may need to comment it out.
    resolv-retry infinite

    # Preserve state across restarts
    persist-key
    persist-tun

    # SSL/TLS parameters - files created previously
    ca ca.crt
    cert client.crt
    key client.key

    # Since we specified the tls-auth for server, we need it for the client
    # note: 0 = server, 1 = client
    tls-auth ta.key 1

    # Specify same cipher as server
    cipher BF-CBC

    # Use compression
    comp-lzo

    # Log verbosity (to help if there are problems)
    verb 3

Place the client.ovpn (or client.conf) configuration file along with the certificate and key files in the openvpn configuration directory on the client. With the above setup, the following files should be in the configuration directory.

    client.ovpn
    ca.crt
    client.crt
    client.key
    ta.key

(For the OpenVPN GUI for Windows, the default location for the files is C:\Program Files\OpenVPN\config.)

(For Tunnelblick for Mac OS X, the default location for the files is ~username/Library/openvpn.

### Firestarter configuration for OpenVPN

Firestarter requires some configuration on both client and server machines to allow services like SAMBA over a VPN tunnel. In addition the creation of rules within the GUI, it was also necessary to edit the /etc/firestarter/user-pre file. I used the instructions found here:

<http://www.howtoadvice.com/FirestarterVPN/>

Also, though the tutorial didn't discuss it, I found it necessary to save the original user-pre file as a copy, then rename the original and rename the copy to user-pre due to permissions issues.

## Other Resources

1. Consult the official [OpenVPN Howto](http://openvpn.net/howto.html).

2. Consult this tutorial [Howto setup and OpenVPN Server](https://www.septimius.net/linux-howto-setup-openvpn-server/).

3. Consult [this tutorial](http://www.juanpablo.netne.net/index.php/en/manuales-linux/red-privada-virtual-openvpn/item/58).

4. Consult [(K)Ubuntuguide -- OpenVPN server installation](http://ubuntuguide.org/wiki/OpenVPN_server)
