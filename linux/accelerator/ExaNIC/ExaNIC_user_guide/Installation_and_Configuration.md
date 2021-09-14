# Installation and Configuration

- [Installation and Configuration](#installation-and-configuration)
  - [Installation](#installation)
    - [SmartNIC Device Installation](#smartnic-device-installation)
    - [Software Installation](#software-installation)
      - [Pre-built packages](#pre-built-packages)
      - [Build your own packages](#build-your-own-packages)
      - [Install from source](#install-from-source)
    - [Driver Installation Verification](#driver-installation-verification)
    - [Setting permissions](#setting-permissions)
    - [Updating firmware](#updating-firmware)
      - [Hot Reload](#hot-reload)
    - [Firmware Recovery](#firmware-recovery)
    - [Uninstallation](#uninstallation)
    - [Troubleshooting](#troubleshooting)
  - [General Usage](#general-usage)
    - [Configuration](#configuration)
    - [The exanic-config utility](#the-exanic-config-utility)
    - [Interface packet counters](#interface-packet-counters)
      - [Packet counters in exanic-config](#packet-counters-in-exanic-config)
      - [Packet counters in ifconfig](#packet-counters-in-ifconfig)
    - [Setting port speed](#setting-port-speed)
    - [Promiscuous mode](#promiscuous-mode)
    - [Bypass-only mode](#bypass-only-mode)
    - [Local-loopback mode](#local-loopback-mode)
    - [Pulse-per-second](#pulse-per-second)
    - [Packet Capture](#packet-capture)
      - [Using tcpdump](#using-tcpdump)
      - [Using exanic-capture](#using-exanic-capture)
      - [exact-capture](#exact-capture)
    - [Multicast Traffic](#multicast-traffic)
      - [Confirming registration](#confirming-registration)
  - [Benchmarking](#benchmarking)
  - [Clock Synchronization](#clock-synchronization)
  - [Traffic Steering](#traffic-steering)

## [Installation](https://exablaze.com/docs/exanic/user-guide/installation/)

### SmartNIC Device Installation

Some motherboards have certain PCI Express slots connected directly to the processor and others connected to the chipset; for optimal performance, install the Cisco Nexus SmartNIC (formerly ExaNIC) in a slot directly connected to the processor. If installing in a dual-processor server with only one processor installed, take special care to install in the correct slot(s), otherwise the NIC may not show up at all.

Install SFP+ modules into the SmartNIC as required. There are no limitations on the type or manufacturer of SFP+ modules that can be used.

### Software Installation

There are a number of different ways of installing the Cisco Nexus SmartNIC (formerly ExaNIC) software: using the pre-built packages provided by Cisco, building your own packages, or installing from source.

#### Pre-built packages

...

#### Build your own packages

...

#### Install from source

If binary packages are not available for your distribution, the Cisco Nexus SmartNIC (formerly ExaNIC) software is also easy to build and install from source. To start, download the ExaNIC source package from the [Exablaze repository](https://exablaze.com/dy/exanic-updates.php) and unpack it.

    $ tar xzf exanic-1.7.0.tar.gz
    $ cd exanic-1.7.0

Running the following commands should build and install the driver, library and utilities:

    $ make
    $ sudo make install

By default, the library will be installed to `/usr/local/lib/libexanic.a`, include files to `/usr/local/include/exanic` and utilities to `/usr/local/bin/exanic-*`. (You can add a `PREFIX=` argument to the `make install` command to use a prefix other than `/usr/local`.) Additionally the driver (`exanic.ko`) will be installed into `/lib/modules/'uname -r'/extra`.

If the driver fails to build, ensure that you have the kernel headers package for your kernel installed (this is typically named `kernel-devel` [RedHat/CentOS] or `linux-headers` [Debian/Ubuntu]).

### Driver Installation Verification

Assuming installation completed successfully, load the driver and verify that the `exanic-config` utility works:

    $ sudo modprobe exanic
    $ sudo exanic-config exanic0

If either of these commands fail, run `dmesg` and check for errors.

The `exanic-config` output will show the Linux interfaces corresponding to each port of the SmartNIC. You can verify that packets are being received by bringing up an interface and running `tcpdump`. For example:

    $ sudo ifconfig eth7 up
    $ sudo tcpdump -n -i eth7

Some systems may present the following error in the `dmesg` output:

    modprobe: ERROR: could not insert 'exanic': Required key not available

To resolve this issue, change the BIOS from Windows to "Other OS". This should alter the "Secure boot" setup of the host and the module can now be loaded.

### Setting permissions

If the SmartNIC is to be used in kernel bypass mode, it may be useful to set permissions on the SmartNIC device files (`/dev/exanic0`, etc, and the `/dev/exasock` device file used by ExaNIC Sockets) so that they can be accessed by certain non-root applications. Permissions can be set with `chown`/`chgrp`/`chmod` as normal, however this will not persist across reboots. A persistent configuration can be achieved by appropriate configuration of the `udev` daemon. For example, to force the device files to be accessible by a group called `exanic`, create a `/etc/udev/rules.d/exanic.rules` file as follows:

    KERNEL=="exanic*", GROUP="exanic", MODE="0660"
    KERNEL=="exasock", GROUP="exanic", MODE="0660"

In the current software release, the SmartNIC device files also expose the device control registers so only trusted users should be given access to the SmartNIC in this way.

If non-root users require utilities such as `exanic-config`, this can be accomplished by setting the appropriate Linux capability on the relevant binary, eg:

    setcap cap_net_admin+ep $(which exanic-config)

Would allow non-root users to enable/disable interfaces via `exanic-config`.

### Updating firmware

The firmware version currently running on the SmartNIC card is shown under 'Firmware date' in `exanic-config`. If there is a newer version available on the website, you can update your firmware as follows.

The `exanic-fwupdate` utility can be used to update the firmware image stored on the SmartNIC. This utility can use the compressed .fw.gz file format that firmware images are released as, or uncompressed .fw files.

    $ exanic-fwupdate exanic_x40_20171019.fw
    Querying target device...done (0.0s)
    Loading and verifying update...done (0.2s)
    Erasing............

Note that there are different firmware files for each type of SmartNIC. The utility will prevent you from installing firmware incompatible with your hardware.

If there are multiple SmartNICs installed into the system, the utility will require you to specify which NIC you are updating:

    $ exanic-fwupdate -d exanic1 exanic_x40_20171019.fw

After the SmartNIC has been updated, the FPGA needs to be reloaded for the new firmware image to be active. This can be done via a host reboot.

#### Hot Reload

Instead of rebooting the host, `exanic-fwupdate` can "hot reload" the FPGA by passing a flag to the utility either during the update process or afterwards as shown below. This will cause the FPGA to reload it's firmware from flash. Note that the SmartNIC firmware image running on the card at the time of the update process must support the hot reload feature. `exanic-fwupdate` will output a message if hot reload is available, otherwise the host will need to be rebooted.

    $ exanic-fwupdate -r
    Reloading card.....done (2.8s)
    The new firmware will take effect immediately.

### Firmware Recovery

...

### Uninstallation

If you installed from packages then you should use the appropriate yum or apt command (`sudo yum remove 'exanic'` or `sudo apt-get remove 'exanic'`).

If you installed from source the following command should remove everything that was installed by `make install`:

    $ sudo make uninstall

Also remove any files that were manually created while following these instructions (`/etc/udev/rules.d/exanic.rules` and any scripts that run `exanic-clock-sync`).

### Troubleshooting

...

## [General Usage](https://exablaze.com/docs/exanic/user-guide/config/)

### Configuration

Since the Cisco Nexus SmartNIC (formerly ExaNIC) appears to Linux as a normal network card, most configuration can be performed through the normal Linux mechanisms. For example, in Redhat-based distributions, configuration is generally performed using files in the `/etc/sysconfig/network-scripts` directory. Alternatively, the interface can be configured temporarily by issuing a command such as `ifconfig eth7 192.168.1.100`.

If the interface is being used through the low-level userspace API (libexanic) only, it is sufficient to bring the interface up without assigning an IP address. This can be done through either `ifconfig` (e.g. `ifconfig eth7 up`) or `exanic-config` (e.g. `exanic-config exanic0:0 up`).

### The exanic-config utility

The `exanic-config` utility can be used to inspect diagnostic information about the card and SFP modules. For example:

    $ exanic-config
    Device exanic0:
     Hardware type: ExaNIC X4
     Board ID: 0x02
     Temperature: 53.2 C VCCint: 1.00 V VCCaux: 1.81 V
     Fan speed: 6987 RPM
     Function: network interface
     Firmware date: Thu Nov 28 20:54:56 2013
     Bridging: off
     Port 0:
      Interface: eth7
      Port speed: 10000 Mbps
      Port status: enabled, SFP present, signal detected, link active
      Mirroring: off
      Promiscuous mode: off
      Bypass-only mode: off
      MAC address: 64:3f:5f:01:13:18
      RX packets: 6 ignored: 0 error: 0
      TX packets: 6
    ...
    
    $ exanic-config exanic0:0 sfp status
    Device exanic0 port 0 SFP status:
     Vendor: FINISAR CORP. PN: FTLX8571D3BCL rev: A
                           SN: ALF0QE7 date: 111006
     Wavelength: 850 nm
     Nominal bit rate: 10300 Mbps
     Rx power: -2.5 dBm (0.56 mW)
     Tx power: -1.9 dBm (0.65 mW)
     Temperature: 33.8 C

The `exanic-config` utility will either accept the Linux interface name (e.g. `eth7`) or the device name of the SmartNIC device (e.g. `exanic0` for the first SmartNIC in the system by PCI ID, and `exanic0:0` for the first port of that card). Globbing syntax is also accepted in order to match several cards/ports. For example, `exanic*:[0-3]` will match ports 0-3 inclusive on any SmartNICs installed. See the output of `exanic-config --help` for more details.

### Interface packet counters

#### Packet counters in exanic-config

The `exanic-config` utility will display the packet counter values for traffic being transmitted or received at a particular port.

    Port 0:
     Interface: eth7
     Port speed: 10000 Mbps
     Port status: enabled, SFP present, signal detected, link active
     Mirroring: off
     Promiscuous mode: off
     Bypass-only mode: off
     MAC address: 64:3f:5f:01:13:18
     RX packets: 1514936895 ignored: 20578657 error: 145683 dropped: 0
     TX packets: 615149369

- `RX Packets`: refers to the total number of packets received by the NIC hardware.

- `ignored`: refers to packets that did not match the local MAC address. It is incremented when the NIC receives a packet that is unicast but destined to a different destination address. This is not as a result of load or any problem with the NIC/host, but that the device on the other end of the wire is sending packets not destined for this device.

- `error`: refers to packets which failed CRC checking. A common cause of this type of behaviour is poor signal from the other end, e.g. a bad cable or optical splitter. To investigate run `exanic-config exanicX:Y sfp status` at both ends of the link.

- `dropped`: refers to packets lost as a result of insufficient PCIe bandwidth to transfer all packets into host memory. If this occurs, check `lspci -vvv` and in particular the `LnkSta`: line for the SmartNIC to verify that the card is operating at Speed 8GT/s (PCIe Gen 3.0) and Width x8. Dropped packets can also occur due to system topology - for example in a multi-socket system where the card is being accessed from a remote socket and QPI bottlenecks occur - or if the incoming network bandwidth exceeds that available on the PCI Express link (e.g. 8x10G or 2x40G can exceed the bandwidth available on a 8x8Gbit/s link during line rate bursts).

#### Packet counters in ifconfig

`dropped` in ifconfig counters can be a result of:

- insufficient CPU cycles to service the NIC
- if jumbo frames are coming in (see note 1 below)
- if IP6 frames are coming in when expecting IP4 only.
Note

Although the kernel driver and exasock don't support jumbo frames, the raw libexanic API can actually receive jumbo frames with no problems. Transmitting jumbo frames using the raw libexanic API is also possible, however you will need to allocate a larger TX buffer than the default size. For sending 4k frames you will need a TX buffer size of 16k.

### Setting port speed

...

### Promiscuous mode

Normally the SmartNIC only passes on received unicast traffic that matches the MAC address of the port to the CPU. If Promiscuous mode is enabled on a port then the network interface controller will instead pass all unicast traffic it receives on that port to the CPU.

    $ exanic-config exanic0:0 promisc on

### Bypass-only mode

If the interface is being used through the userspace API only and kernel CPU load on high traffic connections is a concern, the `bypass-only` setting in `exanic-config` (or `bypass_only` in `ethtool`) can be used to detach the kernel driver from the interface. This means that the kernel driver will not receive any packets. However, tools such as `tcpdump` will not function correctly while this is enabled. Additionally, this setting is not currently persistent across reboots so, if required, should be added to post-up scripts for the interface.

bypass-only mode should not be enabled for exasock to function correctly.

    $ exanic-config exanic0:0 bypass-only on

### Local-loopback mode

When an interface is configured to local-loopback mode the SmartNIC will transmit frames through the FPGA to the wire and will also loop the frame back to the host.

When configured to local-loopback mode traffic is disabled from coming in from the wire. That is you will only receive the traffic you transmit on that interface.

    $ exanic-config exanic0:0 local-loopback on
    exanic0:0: local-loopback mode enabled

This then allows the transmitted traffic to be confirmed by observing the received traffic with tools such as `exanic-capture` and `tcpdump`. Once validated remember to turn the local-loopback function back off.

    $ exanic-config exanic0:0 local-loopback off
    exanic0:0: local-loopback mode disabled

### Pulse-per-second

...

### Packet Capture

#### Using tcpdump

`tcpdump` can be used to capture SmartNIC traffic that the kernel sees. This would normally be all received traffic (unless steered away using [flow steering](https://exablaze.com/docs/exanic/user-guide/features/#1-flow-steering)) and any traffic transmitted via the kernel. Note that traffic transmitted via utilities that use libexanic or exasock bypass the kernel, hence will not be shown in tcpdump. The kernel may also not keep up with received traffic in high load scenarios.

#### Using exanic-capture

A utility called `exanic-capture` is provided that can be used to capture traffic received by an SmartNIC.

This utility receives Ethernet frames from defined interface and dumps to terminal or defined file.

    $ exanic-capture
    Usage: ./exanic-capture -i interface [-w savefile] [-s snaplen] [-p] [-H] [-N] [filter...]
      -i: specify Linux interface (e.g. eth0) or ExaNIC port name (e.g. exanic0:0)
      -w: dump frames to given file in pcap format (- for stdout)
      -s: maximum data length to capture
      -p: do not attempt to put interface in promiscuous mode
      -H: use hardware timestamps (refer to documentation on how to sync clock)
      -N: write nanosecond-resolution pcap format
    
    Filter examples:
      tcp port 80                   (to/from tcp port 80)
      host 192.168.0.1 tcp port 80  (to/from 192.168.0.1:80)
      dst 192.168.0.1 dport 53      (to 192.168.0.1:53, either tcp or udp)
      src 192.168.0.5 sport 80 or dst 192.168.0.1 (combine clauses with 'or')

#### exact-capture

There is a utility called `exact-capture` which is designed for high rate capture across multiple SmartNIC interfaces. This utility is open source and available on [Exablaze's github](https://github.com/exablaze-oss/exact-capture) account.

This is the recommended utility for capturing traffic in high load environments. Please refer to [this page](https://github.com/exablaze-oss/exact-capture) for documentation and further details on `exact-capture`.

### Multicast Traffic

#### Confirming registration

Please note this guide assumes the use of IGMP v3, to check the configured version of IGMP on the host operating system (OS) run:

    cat /proc/net/igmp

It is a common source of error that the host OS and the multicast switch operate with different IGMP versions. While the IGMP versions are backwards compatible, please ensure that the implementations of the versions are suitable.

`exanic-config` should be used to confirm that the SmartNIC card is present and that the interface to be used is appropriately configured. E.g. enabled and link active. The rest of the guide assumes a switch with IP `10.230.91.1`

    $ exanic-config

This should port output similar to.

    Port 1:
       Interface: enp1s0d1
       Port speed: 10000 Mbps
       Port status: enabled, SFP present, signal detected, link active
       ...
       IP address: 10.230.91.62  Mask: 255.0.0.0

Confirm the SmartNIC is able to register for group membership successfully at the host. To assist, Cisco provides with the driver source an example multicast registration utility. Browse to the `src/examples/exanic/` folder and build the mcast_register utility for registering to a multicast group.

    $ make

Then without exasock, run the built utility to register for the multicast group on the SmartNIC host. Providing the interface to utilise and the multicast address to register to. e.g.

    $ ./mcast_register 226.20.20.21:enp1s0d1

Next confirm the SmartNIC interface and the multicast address show in the multicast group memberships on the SmartNIC host OS. e.g.

    $ netstat -g

This should return a table similar to.

    IPv6/IPv4 Group Memberships
    Interface       RefCnt Group
    --------------- ------ ---------------------
    lo              1      all-systems.mcast.net
    enp1s0          1      all-systems.mcast.net
    enp1s0d1        1      226.20.20.21

Then confirm the SmartNIC interface and the switch are up and have link and routes. If possible ping between the IP addresses on the subnet, note this may not be possible with Fusion objects.

Confirm that multicast registration requests are being sent from the SmartNIC interface e.g.

    $ tcpdump -i enp1s0 igmp

## [Benchmarking](https://exablaze.com/docs/exanic/user-guide/benchmarking/)

...

## [Clock Synchronization](https://exablaze.com/docs/exanic/user-guide/clock-sync/)

...

## [Traffic Steering](https://exablaze.com/docs/exanic/user-guide/features/)

...
