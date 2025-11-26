#!/bin/bash
set -e

DB_DIR="/var/lib/mysql"
RUN_DIR="/run/mysqld"

# Create /run/mysqld directory if it doesn't exist
mkdir -p "$RUN_DIR"
chown -R mysql:mysql "$RUN_DIR"

# Initialize database if needed
if [ ! -d "$DB_DIR/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir="$DB_DIR"
fi

# Update bind address to listen on all interfaces
sed -i "s|bind-address\s*=\s*127.0.0.1|bind-address = 0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

# Create a temporary initialization SQL file
INIT_SQL="/tmp/mariadb_init.sql"
cat > "$INIT_SQL" << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASS}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
CREATE USER IF NOT EXISTS '${MYSQL_ADMINUSER}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASS}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_ADMINUSER}'@'%';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ADMINUSER}'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Run MariaDB with init SQL and keep it running as PID 1
exec mysqld --datadir="$DB_DIR" --user=mysql --init-file="$INIT_SQL" --socket="$RUN_DIR/mysqld.sock"
