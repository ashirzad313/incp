#!/bin/bash

# Inception Project - Simple Setup Script
# Creates necessary directories and .env file

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
DATA_DIR="$HOME/data"
ENV_FILE="$PROJECT_ROOT/srcs/.env"

# Create directories
mkdir -p "$DATA_DIR/wordpress"
mkdir -p "$DATA_DIR/mariadb"
mkdir -p "$PROJECT_ROOT/secrets"

# Create .env file if it doesn't exist
if [ ! -f "$ENV_FILE" ]; then
    cat > "$ENV_FILE" << 'ENVFILE'
DOMAIN_NAME=ashirzad.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=ashirzad
MYSQL_PASS=ashirzad_db_pass_123
MYSQL_ROOT_PASS=ashirzad_root_pass_123
MYSQL_DB_HOST=mariadb
MYSQL_ADMINUSER=siteowner42
WORDPRESS_DB_NAME=wordpress
WORDPRESS_DB_USER=ashirzad
WORDPRESS_DB_PASS=ashirzad_db_pass_123
WORDPRESS_DB_HOST=mariadb
WORDPRESS_ADMINUSER=siteowner42
WORDPRESS_ADMIN_PASS=siteowner42_wp_pass
WORDPRESS_ADMIN_EMAIL=ashirzad@example.com
WORDPRESS_USER=wpuser42
WORDPRESS_USER_PASS=wpuser42_pass
WORDPRESS_USER_EMAIL=user@example.com
ENVFILE
fi

# Create secrets directory files
echo -n "ashirzad_db_pass_123" > "$PROJECT_ROOT/secrets/db_password.txt"
echo -n "ashirzad_root_pass_123" > "$PROJECT_ROOT/secrets/db_root_password.txt"
echo -n "siteowner42_wp_pass" > "$PROJECT_ROOT/secrets/credentials.txt"
chmod 600 "$PROJECT_ROOT/secrets"/*.txt

echo "Setup complete!"
echo "Data directory: $DATA_DIR"
echo ".env file: $ENV_FILE"
