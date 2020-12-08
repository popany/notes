# [Nginx Tutorial](http://tutorials.jenkov.com/nginx/index.html)

- [Nginx Tutorial](#nginx-tutorial)
  - [Installing Nginx](#installing-nginx)
  - [Starting Nginx](#starting-nginx)
    - [Check if Nginx is Running](#check-if-nginx-is-running)
  - [Restarting Nginx](#restarting-nginx)
  - [The Nginx Configuration File](#the-nginx-configuration-file)
    - [Original Configuration File Example](#original-configuration-file-example)
  - [Configuring Nginx](#configuring-nginx)
    - [Configuring Nginx as Reverse Proxy With SSL / HTTPS](#configuring-nginx-as-reverse-proxy-with-ssl--https)

Nginx (pronounced "Engine X") is a high performance web server. It was originally developed to tackle the 10K problem which means serving 10.000 concurrent connections. Nginx can be used as a standalone web server, or serve in front of other web servers as a reverse proxy.

When serving as a reverse proxy, Nginx is acting as a front web server which passes the incoming requests on to web servers on the back, on different ports etc. Nginx can then handle aspects like SSL / HTTPS, GZip, cache headers, load balancing and a lot of other stuff. The web servers on the back then do not need to know how to handle this. And - you only have one web server for which you need to learn how to configure SSL / HTTPS, GZip etc. - and that is Nginx. I use Nginx in front of Jetty. Nginx handles all the SSL / HTTPS stuff, and Jetty just serves ordinary HTTP requests on the back.

You can find Nginx at the Nginx website: <http://nginx.com>

## Installing Nginx

You can install Nginx on Ubuntu using the apt-get package manager, like this:

apt-get install nginx
That should install the latest version of Nginx on your Ubuntu server.

To install Nginx on other Linux distributions, search on Google, Bing etc. You will easily find the command lines necessary to install Nginx on your desired Linux distribution.

## Starting Nginx

Once you have installed Nginx, you will need to start it. You do so using this command:

    /etc/init.d/nginx start

To verify that Nginx is running, try directing a browser to the IP address (or domain name) of your Ubuntu server. Make sure that you have [opened the firewall on port 80](http://tutorials.jenkov.com/ubuntu/ubuntu-linux-as-web-server.html#opening-the-firewall).

### Check if Nginx is Running

Another way to check if Nginx is running is to run this command:

    htop

In the output of the command, look for "nginx master process" and "nginx worker process" in the list. If you see these processes in the list, Nginx is running.

## Restarting Nginx

Whenever you make changes to the Nginx configuration file, you will need to restart Nginx. Restarting Nginx is done using this command:

    /etc/init.d/nginx restart

One Nginx is restarted the new configurations will take effect.

If you have an error in your configuration file, restarting Nginx will fail. The restart command will write a small "OK" or "Fail" at the end of the line it outputs, letting you know if restarting failed or succeeded. If you have an error, correct it, and restart Nginx again. Then it should work again.

## The Nginx Configuration File

The Nginx main configuration file is located at:

    /etc/nginx/nginx.conf

The Nginx configuration file may include other configuration files. Thus you can divide your configuration into multiple smaller, reusable configuration files, which are all included in the main Nginx configuration file.

To configure Nginx we must make changes to the Nginx configuration file. Make a copy of the original config file before making changes to it. That way you can always go back to the original in case you mess up the copy. Here is how you make a copy of the original Nginx configuration file:

    cp  /etc/nginx/nginx.conf  /etc/nginx.conf.orig

The file `/etc/nginx.conf.orig` now contains a copy of the original Nginx configuration file.

### Original Configuration File Example

Here is what my original Nginx configuration file looked like. Everywhere you see a `[\n]`, that means I have inserted a line break compared to the original, to make it easier to view the file in a browser. The # are comments.

    user www-data;
    worker_processes 4;
    pid /run/nginx.pid;

    events {
        worker_connections 768;
        # multi_accept on;
    }

    http {

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        ##
        # Gzip Settings
        ##

        gzip on;
        gzip_disable "msie6";

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json [\n]
                    application/x-javascript text/xml [\n]
                    application/xml application/xml+rss text/javascript;

        ##
        # nginx-naxsi config
        ##
        # Uncomment it if you installed nginx-naxsi
        ##

        #include /etc/nginx/naxsi_core.rules;

        ##
        # nginx-passenger config
        ##
        # Uncomment it if you installed nginx-passenger
        ##

        #passenger_root /usr;
        #passenger_ruby /usr/bin/ruby;

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
    }


    #mail {
    #	# See sample authentication script at:
    #	# http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
    #
    #	# auth_http localhost/auth.php;
    #	# pop3_capabilities "TOP" "USER";
    #	# imap_capabilities "IMAP4rev1" "UIDPLUS";
    #
    #	server {
    #		listen     localhost:110;
    #		protocol   pop3;
    #		proxy      on;
    #	}
    #
    #	server {
    #		listen     localhost:143;
    #		protocol   imap;
    #		proxy      on;
    #	}
    #}

## Configuring Nginx

Configuring Nginx is done via the configuration file. Exactly what to configure depends on what you want Nginx to do. I will write more about that in a near future. Until then, this video on YouTube is a good start:

[Setting up webservers with Nginx](https://www.youtube.com/watch?v=7QXnk8emzOU)

### Configuring Nginx as Reverse Proxy With SSL / HTTPS

Here is an example `nginx.conf` (Nginx configuration file) which shows you how to configure Nginx as a reverse proxy. Again, the `[\n]` marks where I have inserted line breaks to make the file easier to view in a browser. Remove the `[\n]` and the line break in your own version of this file. More details about the configuration follows after the file listing.

    user www-data;
    worker_processes 4;
    pid /run/nginx.pid;

    events {
        worker_connections 768;
        # multi_accept on;
    }

    http {

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        ##
        # Gzip Settings
        ##

        gzip on;
        gzip_disable "msie6";

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json [\n]
                    application/x-javascript text/xml application/xml [\n]
                    application/xml+rss text/javascript;

        ##
        # nginx-naxsi config
        ##
        # Uncomment it if you installed nginx-naxsi
        ##

        #include /etc/nginx/naxsi_core.rules;

        ##
        # nginx-passenger config
        ##
        # Uncomment it if you installed nginx-passenger
        ##

        #passenger_root /usr;
        #passenger_ruby /usr/bin/ruby;

        ##
        # Virtual Host Configs
        ##
            server {
                listen 443;
                server_name _;
                ssl on;
                ssl_certificate       certificate-bundle.crt;
                ssl_certificate_key   private-key.pem;
                ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

                location / {
                    proxy_pass http://127.0.0.1:8080;

                }
            }
    }

All the configuration of the reverse proxy stuff happens inside the `server { ... }` block.

The `listen 443` line instructs Nginx to listen on port 443 (the default HTTPS port).

The `server_name _` instructs Nginx that all domain names match this `server{ ... }` section.

The `ssl on` line instructs Nginx to turn SSL / HTTPS on.

The `ssl_certificate certificate-bundle.crt` points to the certificate file. The certificate file path is the `certificate-bundle.crt`. This path can point to a single certificate file, or in my case a certificate bundle because I purchased a certificate from a intermediary certificate authority. The bundle contains my certificate as the first entry in the file, and the rest of the CA certificates after (see next section for more details).

The `ssl_certificate_key private-key.pem` points to the original private key which was used to generate the certificate signing request. This key is needed for Nginx to create SSL connections with the certificate.

The `ssl_protocols TLSv1 TLSv1.1 TLSv1.2;` line sets what SSL protocols are enabled. In this example I have only enabled TSLv1, TLSv1.1 and TLSv1.2. Note: Some of the SSL protocols (like SSLv3) have security weaknesses, so be sure to consult a security guide before enabling all SSL protocols.

The `location / { ... }` section instructs Nginx to forward all requests from `/` and down in the virtual directory structure of the website, to the web server running on `http://127.0.0.1:8080`, which is port `8080` on the same machine.

I used OpenSSL to generated my private key and certificate signing request. I have a separate tutorial on [creating private keys and certificate signing requests with OpenSSL for use with web servers](http://tutorials.jenkov.com/openssl/openssl-for-web-servers.html).

### Concatenate Certificates Into One File

If you buy a certificate from an intermediate certificate authority (CA), your CA may send you several certificates. One of these certificates is yours. Another is the certificate of the CA. And then the CA may send you a chain of certificates from other CAs which have been used to sign your CAs certificate (that is why your CA is an "intermediate" CA and not a root CA).

For Nginx to be able to use your intermediate CA's certificate, you need to concatenate all of the certificates including yours into a single certificate file. Your certificate must be the first entry in this concatenated file.

Here are the two unix commands I used with my SSL certificate from NameCheap.com (Comodo Positive SSL - cheapest option) to concatenate the certificates into a single certificate bundle file. Again the `[\n]` + line breaks are inserted by me. Remove both the `[\n]` and the line break, so the command is just a single line.

    cat AddTrustExternalCARoot.crt COMODORSAAddTrustCA.crt [\n]
        COMODORSADomainValidationSecureServerCA.crt > comodo-ca-certificate-bundle.crt

This first command concatenates the Comodo certificate with the rest of the certificates in the certificate chain.

The second command inserts your certificate (`myserver-com.crt`) at the top of a certificate bundle file:

    cat myserver-com.crt comodo-ca-certificate-bundle.crt > certificate-bundle.crt

You can now point to the `certificate-bundle.crt` from inside your Nginx configuration file, as shown earlier in the previous section.

You can read more about configuring SSL / HTTPs with Nginx at:
<http://nginx.org/en/docs/http/configuring_https_servers.html>
