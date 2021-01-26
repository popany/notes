# Capture TCP Package

- [Capture TCP Package](#capture-tcp-package)
  - [Capture tcp package on port 5555](#capture-tcp-package-on-port-5555)
  - [Write the raw packets to file and than read](#write-the-raw-packets-to-file-and-than-read)
  - [Capture tcp package sent to host 172.17.0.2 and port 5555](#capture-tcp-package-sent-to-host-1721702-and-port-5555)
  - [Capturing with “tcpdump” for viewing with Wireshark](#capturing-with-tcpdump-for-viewing-with-wireshark)

## Capture tcp package on port 5555

    tcpdump -i any -#nnSxxU tcp port 5555

- `-i any`

  capture packets from all interfaces

- `-#`

  Print an optional packet number at the beginning of the line

- `-nn`

  Don’t resolve hostnames or port names

- `-S`

  Print absolute, rather than relative, TCP sequence numbers

- `xx`

  When parsing and printing, in addition to printing the headers of each packet, print the data of each packet, including its link level header, in hex.

- `U`

  Make the printed packet output "packet-buffered"

## Write the raw packets to file and than read

    tcpdump -i any -w test.pcap tcp port 5555

    tcpdump -#nnSxx -r test.pcap

## Capture tcp package sent to host 172.17.0.2 and port 5555

    tcpdump -i any -#nnSxxU dst host 172.17.0.2 and tcp dst port 5555

## [Capturing with “tcpdump” for viewing with Wireshark](https://www.wireshark.org/docs/wsug_html_chunked/AppToolstcpdump.html)

It’s often more useful to capture packets using `tcpdump` rather than `wireshark`. For example, you might want to do a remote capture and either don’t have GUI access or don’t have Wireshark installed on the remote machine.

Older versions of tcpdump truncate packets to 68 or 96 bytes. If this is the case, use `-s` to capture full-sized packets:

    tcpdump -i <interface> -s 65535 -w <file>

You will have to specify the correct interface and the name of a file to save into. In addition, you will have to terminate the capture with `^C` when you believe you have captured enough packets.



