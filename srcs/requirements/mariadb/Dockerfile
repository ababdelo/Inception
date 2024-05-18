
# Use Debian 11 as the base image
FROM debian:11

# Update the package lists and install MariaDB server
RUN apt update -y && apt-get install mariadb-server -y

# Copy the custom MariaDB configuration file into the container
COPY conf/mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy the custom script into the container at the specified path
COPY tools/script.sh /var/script.sh

# Make the script executable
RUN chmod 0777 /var/script.sh

# Expose port 3306 for MariaDB
EXPOSE 3306

# Specify the command to run when the container starts
CMD ["/var/script.sh"]
