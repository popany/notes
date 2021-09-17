# Network Bash

- [Network Bash](#network-bash)
  - [Show Available Network Interfaces](#show-available-network-interfaces)
    - [`ip`](#ip)
    - [`nmcli`](#nmcli)
    - [netstat](#netstat)
    - [ifconfig](#ifconfig)
  - [Show List Of Network Cards](#show-list-of-network-cards)
    - [`lspci`](#lspci)
    - [`lshw`](#lshw)
    - [`dmidecode`](#dmidecode)
    - [`ifconfig`](#ifconfig-1)
    - [`ip`](#ip-1)
    - [`hwinfo`](#hwinfo)
    - [`ethtool`](#ethtool)

## Show Available Network Interfaces

[Linux Show / Display Available Network Interfaces](https://www.cyberciti.biz/faq/linux-list-network-interfaces-names-command/)

### `ip`

    ip link show

### `nmcli`

    nmcli device status

    nmcli connection show

### netstat

    netstat -i

### ifconfig

    ifconfig -a

## Show List Of Network Cards

[HowTo: Linux Show List Of Network Cards](https://www.cyberciti.biz/faq/linux-list-network-cards-command/)

### `lspci`

    lspci | egrep -i --color 'network|ethernet'

    lspci | egrep -i --color 'network|ethernet|wireless|wi-fi'

### `lshw`

    lshw -class network

    lshw -class network -short

### `dmidecode`

List all hardware data from BIOS.

### `ifconfig`

    ifconfig -a

### `ip`

    ip a show eth0

    ip link show

    ip a

    ip -br -c link show

    ip -br -c addr show

### `hwinfo`

    hwinfo --network --short

### `ethtool`

    ethtool eth0

    ethtool -i eth0
