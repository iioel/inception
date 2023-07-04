#!/bin/bash

echo "Setting up php-fpm config..."
sed -i "s|^;ping.path = /ping$|ping.path = /ping|" /etc/php/8.2/fpm/pool.d/www.conf
sed -i "s|^;ping.response = pong$|ping.response = pong|" /etc/php/8.2/fpm/pool.d/www.conf
sed -i "s|^;pm.status_path = /status$|pm.status_path = /status|" /etc/php/8.2/fpm/pool.d/www.conf
#sed -i "s|^;pm.status_listen = 127.0.0.1:9001$|pm.status_listen = 127.0.0.1:9001|" /etc/php/8.2/fpm/pool.d/www.conf
sed -i "s|^;cgi.fix_pathinfo=1$|cgi.fix_pathinfo = 0|" /etc/php/8.2/fpm/php.ini

cd /var/www/wordpress
echo "Downloading latest wordpress release..."
wp core download

echo "Configure wordpress..."
if [[ ! -v WP_DBUSER ]] || [[ ! -v WP_DBPASS ]] || [[ ! -v WP_DBNAME ]]
then
	echo "ERROR: Env vars WP_DBUSER, WP_DBPASS or WP_DBNAME undefined."
	echo "       Please make sure that they are defined !"
	echo "Exiting..."
	exit
fi
wp config create --dbname=${WP_DBNAME} --dbuser=${WP_DBUSER} --dbpass=${WP_DBPASS} \
	--dbhost=mariadb --locale=en_US --skip-check

echo "Install wordpress..."
if [[ ! -v WP_URL ]] || [[ ! -v WP_TITLE ]] || [[ ! -v WP_ADMINUSER ]] || [[ ! -v WP_ADMINPASS ]] || [[ ! -v WP_ADMINEMAIL ]]
then
	echo "ERROR: Env vars WP_URL, WP_TITLE, WP_ADMINUSER, WP_ADMINPASS or WP_ADMINEMAIL undefined."
	echo "       Please make sure that they are defined !"
	echo "Exiting..."
	exit
fi
wp core install --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMINUSER} \
	--admin_password=${WP_ADMINPASS} --admin_email=${WP_ADMINEMAIL} --locale=en_US --skip-email

echo "Starting php-fpm..."
exec /usr/sbin/php-fpm8.2 -F -O
