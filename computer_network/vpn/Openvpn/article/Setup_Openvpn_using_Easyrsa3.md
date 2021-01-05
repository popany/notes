# [Setup Openvpn using Easyrsa3](https://www.supertechcrew.com/setup-openvpn-easyrsa3/)

- [Setup Openvpn using Easyrsa3](#setup-openvpn-using-easyrsa3)
  - [Initialize it](#initialize-it)
  - [Build the Keys](#build-the-keys)
    - [Generate on the computers themselves](#generate-on-the-computers-themselves)
    - [or Generate keys on the keyserver then move](#or-generate-keys-on-the-keyserver-then-move)
  - [Generate DH](#generate-dh)
  - [Revoke Certificates](#revoke-certificates)
  - [Config OpenVPN](#config-openvpn)
    - [TA key for more security](#ta-key-for-more-security)
    - [Other config items](#other-config-items)
    - [Routing the Traffic](#routing-the-traffic)

## Initialize it

First off I downloaded Easyrsa3 from <https://github.com/OpenVPN/easy-rsa> and put it on a “controlled” computer, or “keyserver” as I’ll call it. The VPS isn’t totally under my control, and I didn’t want to have the main key on it. The keyserver doesn’t have to have internet or an connection to any of the other computers. But you will have to be able to transfer the files to and from the other computers.

You’ll want to edit the vars file with your own values. We using to have to load it into the system, (. ./vars) but we don’t do it that way anymore.

So on the keyserver, in the extracted easyrsa3 folder, you initiate the CA. This is your main keys and certificate files.

    ./easyrsa init-pki
    ./easyrsa build-ca

It will ask you for a password. I would recommend this for the CA key. If you want to not provide the password, add the argument “nopass” to the end of the command. And remember, you loose your password, you will have to rebuild it. There’s no way to get it back.

On all the computers I will tell it not to use a password, otherwise it will prompt for the password on each time OpenVPN starts.

## Build the Keys

Now, there are two ways to build the keys and certificate for the server and clients. You can either generate the keys on the computers themselves or you can generate them on the keyserver and then move them over.

### Generate on the computers themselves

To make the keys on the computers themselves, download the Easyrsa3 onto the computer, and run this:

For a server or client:

    ./easyrsa init-pki
    ./easyrsa gen-req <client-name>

Then copy the result `.req` to the keyserver. On the keyserver you'll then sign it:

    ./easyrsa import-req /path/to/request.req <client-name>
    ./easyrsa sign-req [server|client] <client-name>

Make sure you specify if it’s a ‘server’ or a ‘client’. Then copy the `.crt` file back to the server/client

You can verify certs using:

    openssl verify -CAfile ca.crt <client-name>.crt

### or Generate keys on the keyserver then move

This way is simpler. But less secure.

For the server, do this:

    ./easyrsa build-server-full server nopass

For each client do this:

    ./easyrsa build-client-full <Client Name> nopass

Then copy over the needed keys and crt files.

## Generate DH

This is what gives the server some extra encryption data. You can do this on the keyserver and move it over, or you can generate it on the server if you have the Easyrsa3 on it:

    ./easyrsa gen-dh

Then put it in the /etc/openvpn folder.

## Revoke Certificates

As a side note, the nice things about using a CA setup is if you ever loose a computer or otherwise need to keep one key from being able to access your VPN network, use (on keyserver):

    ./easyrsa revoke <Client Name>

Then run this:

    ./easyrsa gen-crl

And copy the output to the server. No need to copy to the clients.

## Config OpenVPN

Now to the actual meat of it. Install OpenVPN, and put the following files in it: `ca.crt` `.crt` `.key`

You’ll put this in the openvpn config: ca `keys/ca.crt` cert `keys/.crt` key `keys/.key`

Make sure these keys are owned by root and with the perms 600 or 400.

### TA key for more security

For extra security you can generate a ta.key:

    openvpn --genkey --secret ta.key

And add it to the config as (the ‘1’ is for clients, set to ‘0’ on the server): `tls-auth keys/ta.key 1`

This file can help on (D)DOS attacks and brute force attacks, as the server won’t even respond if it’s not provided.

### Other config items

For extra security, run openvpn without privledges.

    user nobody
    group nobody # make sure this group exists
    persist-key
    persist-tun
    nobind

Use udp for faster connections and keep on trying:

    proto udp
    resolv-retry infinite
    keepalive 10 120

Use better encryption

    tls-client # or tls-server on the server
    cipher AES-256-CBC # Use 'openvpn --show-ciphers' and 'openvpn --show-tls'
    remote-cert-tls server # checks the server's cert, to protect against man-in-the-middle attacks

### Routing the Traffic

Now that OpenVPN is installed, we configure it to send all the internet traffic to it.

There’s two ways to do this. The simplest way is to have the server push everything to it.

    push "redirect-gateway def1"
    push "remote-gateway <vpn server ip>"
    push "dhcp-option DNS <vpn server ip>"

Or you can add this to each client:

    redirect-gateway def1
    route 10.172.172.1 gateway

Either of these will create a route on the client that will make the traffic go to the server. But we have to tell the server what to do with it. So we add a iptables firewall to redirect the traffic:

    iptables -I FORWARD -i tun+ -o eth0 \
            -s 10.x.x.0/24 -m conntrack --ctstate NEW -j ACCEPT
    iptables -I FORWARD -m conntrack --ctstate RELATED,ESTABLISHED \
            -j ACCEPT
    iptables -t nat -I POSTROUTING -o eth0 \
            -s 10.x.x.0/24 -j MASQUERADE

    echo 1 > /proc/sys/net/ipv4/ip_forward

Now all the traffic should be working. Just note that DNS may still be going the regular way if you have something like ‘192.168.0.1’ in your /etc/resolv.conf file. You can change it to OpenDNS or Google so it’ll go through the vpn.

You can use OpenVPN’s scripting to set this if you’d like. Add this to the bottom of the OpenVPN config file:

    script-security 2
    up /etc/openvpn/up-script
    down "/usr/bin/sudo /etc/openvpn/down-script"

These are just example files. I use dnsmasq to cache dns lookups, which talks to the dns caching server on the vpn, so I just pipe it there. You’ll notice that I had to use sudo on it as OpenVPN runs as nobody and can’t change the file without sudo.

/etc/openvpn/up-script

    #!/bin/bash
    echo nameserver [vpn server ip] > /etc/resolv.dnsmasq.conf

/etc/openvpn/down-script

    #!/bin/bash
    echo "# OpenDNS IPv4 and IPv6 nameservers
    nameserver 208.67.222.222
    nameserver 2620:0:ccc::2
    nameserver 208.67.220.220
    nameserver 2620:0:ccd::2
    nameserver 4.2.2.4
    nameserver 8.8.8.8" > /etc/resolv.dnsmasq.conf
    exit 0
