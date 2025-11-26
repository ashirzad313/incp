FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-pgsql \
    php-sqlite3 \
    nginx \
    wget \
    && apt-get clean

RUN mkdir -p /var/www/html && \
    mkdir -p /run/php && \
    cd /var/www/html && \
    wget -q https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
    mv adminer-4.8.1.php index.php && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/php-fpm.conf /etc/php/7.4/fpm/pool.d/www.conf

EXPOSE 8080

CMD mkdir -p /run/php && php-fpm7.4 -D && nginx -g 'daemon off;'
