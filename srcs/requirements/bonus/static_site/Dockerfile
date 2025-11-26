FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean

COPY conf/index.html /var/www/html/index.html
COPY conf/style.css /var/www/html/style.css
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
