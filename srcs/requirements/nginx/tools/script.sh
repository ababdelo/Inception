#!/bin/bash

# Generate a self-signed SSL certificate using OpenSSL
openssl req -x509 -nodes -days 365 \
    -subj "/C=MA/L=BenGuerir/O=LE3TMAKERS, Inc./OU=IT/CN=ababdelo.42.fr" \
    -newkey rsa:2048 -keyout /etc/nginx/ssl/ssl_prv.key \
    -out /etc/nginx/ssl/ababdelo.42.fr.cert

# Start nginx in the foreground (prevent daemonizing)
nginx -g "daemon off;"
