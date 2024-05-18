#!/bin/bash

# Modify the PHP-FPM configuration to listen on port 9000
sed -i -e 's/.*listen = .*/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

# Wait for 5 seconds to ensure that all services are up
sleep 5

# Change directory to the WordPress installation
cd /var/www/wordpress

# Create the wp-config.php file with the provided database credentials
wp config create --allow-root \
    --dbname=$MYSQL_DATABASE \
    --dbuser=$MYSQL_USER \
    --dbpass=$MYSQL_PASSWORD \
    --dbhost=$DB_host

# Install WordPress with the provided site details
wp core install --allow-root \
	--url=$DOMAIN_NAME \
    --title=$TITLE \
    --admin_user=$ADMIN_USER \
    --admin_password=$ADMIN_PASSWORD \
    --admin_email=$EMAIL

# Create an additional WordPress user with the provided credentials
wp user create --allow-root \
	$USER_WNAME \
	$EMAIL_USER_WNAME \
	--role=$ROLE \
	--user_pass=$USER_PASS

# Set permissions for the wp-content directory
chmod -R 777 wp-content

# Start PHP-FPM in the foreground
/usr/sbin/php-fpm7.4 -F
