#!/bin/bash

# Start the MariaDB service
service mariadb start

# Create a database if it doesn't already exist
mariadb -e \
    "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

# Create a user that can connect from any host
mariadb -e \
    "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' \
     IDENTIFIED BY '${MYSQL_PASSWORD}';"

# Grant all privileges on the specified database to the user
mariadb -e \
    "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* \
     TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# Change the password for the root user
mariadb -e \
    "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

# Grant all privileges on the specified database to the root user
mariadb -u root -p${MYSQL_ROOT_PASSWORD} -e \
    "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* \
     TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

# Reload the privileges to apply any changes made
mariadb -u root -p${MYSQL_ROOT_PASSWORD} -e \
    "FLUSH PRIVILEGES;"

# Shut down the MariaDB server gracefully
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Start the MariaDB server in safe mode
mysqld_safe
