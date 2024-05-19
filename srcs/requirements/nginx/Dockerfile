
# Use Debian 11 as the base image
FROM debian:11

# Perform multiple actions in one RUN command to reduce the number of layers
RUN \
    # Update the package lists
    apt-get update && \
    # Upgrade all installed packages to their latest versions
    apt-get upgrade -y && \
    # Install nginx web server and openssl for SSL certificate generation
    apt-get install -y nginx openssl vim && \
    # Create necessary directories for nginx and SSL
    mkdir -p /etc/nginx/ssl/ /var/run/nginx /var/www/wordpress && \
    # Remove the default nginx site configuration
    rm -rf /etc/nginx/sites-enabled/default

COPY tools/script.sh /usr/local/bin/script.sh

COPY conf/nginx.conf /etc/nginx/sites-enabled/

RUN \
    # Make the script executable
    chmod +x /usr/local/bin/script.sh && \
    # Set permissions for the web directory to be writable
    chmod 0777 /var/www/wordpress && \
    # Change ownership of the web directory to the www-data user and group
    chown -R www-data:www-data /var/www/wordpress

# Specify the command to run when the container starts
CMD ["/usr/local/bin/script.sh"]
