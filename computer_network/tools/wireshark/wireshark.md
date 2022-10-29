# Wireshark

- [Wireshark](#wireshark)
  - [Install](#install)
    - [Windows](#windows)
  - [Decrypt Tls](#decrypt-tls)

## Install

### Windows

[download](https://www.wireshark.org/download.html)

Each Windows package comes with the latest stable release of Npcap, which is required for live packet capture. If needed you can download separately from the [Npcap](https://nmap.org/npcap/) web site.

## Decrypt Tls

[Decrypting SSL/TLS traffic with Wireshark](https://resources.infosecinstitute.com/topic/decrypting-ssl-tls-traffic-with-wireshark/)

[How to Decrypt SSL using Chrome or Firefox and Wireshark in Windows](https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA14u000000HB8gCAG&lang=en_US%E2%80%A9)

[SSLKEYLOGFILE](https://everything.curl.dev/usingcurl/tls/sslkeylogfile)

[Getting and using KEYLOG files from cURL]()

In order to use this feature in cURL, you'll need to enable it at compile time (unfortunately). That means building cURL in linux or OSX using the following commands:

    USE_CURL_SSLKEYLOGFILE=true ./configure
    make

After it's compiled, you can then set the environment variable that specifies the path you want for your keylog file. You can do this at run time in a command line like this:

    SSLKEYLOGFILE=~/curl_ssl_keylog.keylog ./curl -k <target URL>


