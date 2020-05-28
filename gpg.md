#gpg

- [Cases](#cases)
  - [Verify Notepad++ Installer](#verify-notepad-installer)

## Cases

### Verify Notepad++ Installer

1. Download Notepad++ Installer and GPG Signature

       curl -O http://download.notepad-plus-plus.org/repository/7.x/7.7.1/npp.7.7.1.Installer.x64.exe

       curl -O http://download.notepad-plus-plus.org/repository/7.x/7.7.1/npp.7.7.1.Installer.x64.exe.sig

2. Import public key from keyserver

       $ gpg  --keyserver keyserver.ubuntu.com --search-keys don.h@free.fr
       gpg: data source: http://162.213.33.9:11371
       (1)     Notepad ++ <don.h@free.fr>
                 2048 bit RSA key 6D821F0AFFBCF709, created: 2019-05-12
       (2)     Notepad++ <don.h@free.fr>
                 4096 bit RSA key 6C429F1D8D84F46E, created: 2019-03-11
       Keys 1-2 of 2 for "don.h@free.fr".  Enter number(s), N)ext, or Q)uit

       $ gpg --receive-keys 6C429F1D8D84F46E
       gpg: key 6C429F1D8D84F46E: public key "Notepad++ <don.h@free.fr>" imported
       gpg: Total number processed: 1
       gpg:               imported: 1

3. Verify

       $ gpg --verify npp.7.7.1.Installer.x64.exe.sig
       gpg: assuming signed data in 'npp.7.7.1.Installer.x64.exe'
       gpg: Signature made 2019年06月20日  7:47:38
       gpg:                using RSA key 14BCE4362749B2B51F8C71226C429F1D8D84F46E
       gpg: Good signature from "Notepad++ <don.h@free.fr>" [unknown]
       gpg: WARNING: This key is not certified with a trusted signature!
       gpg:          There is no indication that the signature belongs to the owner.
       Primary key fingerprint: 14BC E436 2749 B2B5 1F8C  7122 6C42 9F1D 8D84 F46E
