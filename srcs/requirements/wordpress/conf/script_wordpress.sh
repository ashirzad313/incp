#!/bin/bash

# Check if WordPress is already installed, if not download it
setup_wordpress_files() {
  if [ ! -f /var/www/html/wp-settings.php ]; then
    echo "WordPress files not found. Downloading..."
    cd /tmp
    wget -q https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    rm -rf wordpress latest.tar.gz
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
    echo "WordPress files installed."
  fi
}

# Function to check if MariaDB is ready
wait_for_mariadb() {
  echo "Waiting for MariaDB to be ready..."
  until mysqladmin ping -h "${MYSQL_DB_HOST}" -u root --password="${MYSQL_ROOT_PASS}" --silent; do
    sleep 1
  done
  echo "MariaDB is ready."
}

# Function to validate admin username
validate_admin_username() {
  if echo "${WORDPRESS_ADMINUSER}" | grep -i -qE "admin|administrator"; then
    echo "Error: Invalid administrator username."
    exit 1
  fi
}

# Function to create wp-config.php
create_wp_config() {
  if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create --path=/var/www/html \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASS}" \
        --dbhost="${MYSQL_DB_HOST}" \
        --allow-root
    
    # Add dynamic URL configuration for localhost and domain support
    cat >> /var/www/html/wp-config.php << 'EOF'

/* Support both localhost and domain name access */
if ( ( isset( $_SERVER['HTTP_X_FORWARDED_PROTO'] ) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https' ) || 
     ( isset( $_SERVER['HTTPS'] ) && $_SERVER['HTTPS'] === 'on' ) || 
     $_SERVER['SERVER_PORT'] == 443 || 
     $_SERVER['SERVER_PORT'] == 8443 ) {
    $protocol = 'https://';
} else {
    $protocol = 'http://';
}

// Allow access via localhost:8443 or domain name
define( 'WP_HOME', $protocol . $_SERVER['HTTP_HOST'] );
define( 'WP_SITEURL', $protocol . $_SERVER['HTTP_HOST'] );
EOF
  else
    echo "wp-config.php already exists. Skipping creation."
  fi
}

# Function to install WordPress
install_wordpress() {
  if ! wp core is-installed --path=/var/www/html --allow-root; then
    echo "Installing WordPress..."
    wp core install --path=/var/www/html \
        --url=https://${DOMAIN_NAME} \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMINUSER}" \
        --admin_password="${WORDPRESS_ADMIN_PASS}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --skip-email --allow-root

    echo "Creating a regular user..."
    wp user create "${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" \
        --user_pass="${WORDPRESS_USER_PASS}" --role=subscriber \
        --path=/var/www/html --allow-root

    echo "WordPress installation complete."
  else
    echo "WordPress is already installed. Skipping setup."
  fi
}

# Function to fix WordPress URLs if accessed from different host
fix_wordpress_urls() {
  # Only fix if WordPress is already installed
  if wp core is-installed --path=/var/www/html --allow-root 2>/dev/null; then
    echo "Fixing WordPress database URLs..."
    
    # Update siteurl and home to use dynamic URLs
    wp option update siteurl 'https://localhost:8443' --path=/var/www/html --allow-root 2>/dev/null || true
    wp option update home 'https://localhost:8443' --path=/var/www/html --allow-root 2>/dev/null || true
    
    echo "WordPress URLs updated in database"
  fi
}

# Main execution block
setup_wordpress_files
wait_for_mariadb
validate_admin_username
create_wp_config
install_wordpress
fix_wordpress_urls

# Execute the CMD passed in
exec "$@"
