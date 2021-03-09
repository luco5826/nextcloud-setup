#!/bin/bash

echo "## Creating POSTGRES"
echo "Insert a password for PostgreSQL instance (can be changed in docker-compose.yml)"
read pgPassword
sed -i "s/YOUR_PASSWORD/$pgPassword/g" docker-compose.yml

echo "## Creating APACHE"
echo "Do you want to create a self signed certificate? [Y/N]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
  openssl req -x509 -newkey rsa:4096 -keyout key.pem -nodes -out cert.pem -days 365
  mv key.pem apache/certs
  mv cert.pem apache/certs
fi

echo "Enter your domain name: "
read domain
sed -i "s/YOUR_DOMAIN/$domain/g" apache/extra/httpd-vhosts.conf

echo "Enter your cloud's local IP address: " 
read ipAddr
sed -i "s/YOUR_IP/$ipAddr/g" apache/extra/httpd-vhosts.conf
echo "...OK"

echo "### Done ###"
echo "Run your NextCloud instance by typing: docker-compose up"