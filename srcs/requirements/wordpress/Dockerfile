FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    net-tools \
    php-fpm \
    php-mysql \
    wget \
    unzip \
    curl \
    mariadb-client \
    && apt-get clean

# Create WordPress directory
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM
RUN sed -i "s|;listen.owner = www-data|listen.owner = www-data|g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i "s|;listen.group = www-data|listen.group = www-data|g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i "s|listen = /run/php/php7.4-fpm.sock|listen = 9000|g" /etc/php/7.4/fpm/pool.d/www.conf

# Ensure /run/php exists
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

COPY ./conf/script_wordpress.sh /script_wordpress.sh

RUN chmod +x /script_wordpress.sh

EXPOSE 9000

WORKDIR /var/www/html

ENTRYPOINT ["/script_wordpress.sh"]
CMD ["php-fpm7.4", "--nodaemonize"]
