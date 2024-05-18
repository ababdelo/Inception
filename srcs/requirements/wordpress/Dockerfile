# Use Debian 11 as the base image
FROM debian:11

# Update package lists
RUN apt-get update -y

# Install wget and PHP dependencies
RUN apt-get install -y wget php7.4 php-fpm php-mysql

# Download and extract WordPress
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www && \
    cd /var/www && \
    tar -xzf wordpress-6.0-fr_FR.tar.gz && \
    rm wordpress-6.0-fr_FR.tar.gz

# Download and install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy the custom script into the container
COPY ./tools/script.sh .

# Make the script executable
RUN chmod +x script.sh

# Create /run/php folder if it doesn't exist
RUN mkdir -p /run/php

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Specify the command to run when the container starts
CMD ["./script.sh"]
