# stunnel + openvpn

- [stunnel + openvpn](#stunnel--openvpn)
  - [references](#references)
  - [install openvpn (Cenos8)](#install-openvpn-cenos8)

## references

[Xaqron/openvpn](https://github.com/Xaqron/openvpn)

[Xaqron/stunnel](https://github.com/Xaqron/stunnel)

## install openvpn (Cenos8)

    yum install epel-release -y
    yum install openvpn iptables openssl wget ca-certificates -y

    # Get easy-rsa
    wget -O ~/EasyRSA-3.0.4.tgz "https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.4/EasyRSA-3.0.4.tgz"
    tar xzf ~/EasyRSA-3.0.4.tgz -C ~/
    mv ~/EasyRSA-3.0.4/ /etc/openvpn/
    mv /etc/openvpn/EasyRSA-3.0.4/ /etc/openvpn/easy-rsa/
    chown -R root:root /etc/openvpn/easy-rsa/
    rm -rf ~/EasyRSA-3.0.4.tgz
    cd /etc/openvpn/easy-rsa/


