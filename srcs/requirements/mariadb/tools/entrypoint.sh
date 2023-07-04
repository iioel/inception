#!/bin/bash

echo "Installing mariadb database..."
mariadb-install-db --datadir=/var/lib/mysql --user=mysql

if [[ ! -v WP_DBADMINPASS ]] || [[ ! -v WP_DBUSER ]] || [[ ! -v WP_DBPASS ]] || [[ ! -v WP_DBNAME ]]
then
	echo "ERROR: Env vars WP_DBADMINPASS, WP_DBUSER, WP_DBPASS or WP_DBNAME undefined."
	echo "       Please make sure that they are defined !"
	echo "Exiting..."
	exit
fi

/usr/bin/mariadbd-safe 2>&1 >/dev/null &
sleep 1

echo -n "Set root database user password..."
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${WP_DBADMINPASS}'; FLUSH PRIVILEGES;"
echo " OK"

echo -n "Creating wordpress database..."
mariadb -u root -p${WP_DBADMINPASS} -e "CREATE DATABASE IF NOT EXISTS ${WP_DBNAME};"
echo " OK"

echo -n "Creating ${WP_DBUSER} database user..."
mariadb -u root -p${WP_DBADMINPASS} -e "CREATE USER IF NOT EXISTS '${WP_DBUSER}'@'%' IDENTIFIED BY '${WP_DBPASS}'; GRANT ALL PRIVILEGES ON ${WP_DBNAME}.* TO '${WP_DBUSER}'@'%'; FLUSH PRIVILEGES;"
echo " OK"

mariadb-admin shutdown

sed -i "s/^bind-address.*$/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

echo "Starting mariadbd..."
exec /usr/sbin/mariadbd
