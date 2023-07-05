#!/bin/bash

echo "Installing mariadb database..."
mariadb-install-db --datadir=/var/lib/mysql --user=mysql

if [[ ! -v DB_ADMINPASS ]] || [[ ! -v DB_USER ]] || [[ ! -v DB_PASS ]] || [[ ! -v DB_NAME ]]
then
	echo "ERROR: Env vars DB_ADMINPASS, DB_USER, DB_PASS or DB_NAME undefined."
	echo "       Please make sure that they are defined !"
	echo "Exiting..."
	exit
fi

/usr/bin/mariadbd-safe 2>&1 >/dev/null &
sleep 1

echo -n "Set root database user password..."
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ADMINPASS}'; FLUSH PRIVILEGES;"
echo " OK"

echo -n "Creating wordpress database..."
mariadb -u root -p${DB_ADMINPASS} -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
echo " OK"

echo -n "Creating ${DB_USER} database user..."
mariadb -u root -p${DB_ADMINPASS} -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}'; GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%'; FLUSH PRIVILEGES;"
echo " OK"

mariadb-admin shutdown

sed -i "s/^bind-address.*$/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

echo "Starting mariadbd..."
exec /usr/sbin/mariadbd
