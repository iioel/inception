#!/bin/bash

openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/certs/key.pem \
	-out /etc/ssl/certs/cert.pem -sha256 -days 3650 -nodes \
	-subj "/C=CH/ST=Vaud/L=Lausanne/O=42Lausanne/OU=Cursus42/CN=$DOMAIN_NAME"
 
sed -i "s/^	server_name _;$/	server_name $DOMAIN_NAME;/" /etc/nginx/sites-available/default
rm -rf /etc/nginx/sites-enabled/*
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

exec /usr/sbin/nginx -g "daemon off;"
