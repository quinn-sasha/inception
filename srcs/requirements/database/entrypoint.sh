#!/bin/bash

WP_DATABASE_PASSWORD=$(cat /run/secrets/db_password)
DATABASE_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MariaDB..."
  mysql_install_db --user=mysql --datadir=/var/lib/mysql >/dev/null
fi

cat <<EOF >/tmp/init.sql
CREATE DATABASE IF NOT EXISTS \`${WP_DATABASE_NAME}\`;
CREATE USER IF NOT EXISTS '${WP_DATABASE_USER}'@'%' IDENTIFIED BY '${WP_DATABASE_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WP_DATABASE_NAME}\`.* TO '${WP_DATABASE_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DATABASE_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

echo "Starting MariaDB..."
exec mysqld_safe --user=mysql --init-file=/tmp/init.sql
