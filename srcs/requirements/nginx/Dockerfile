FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && apt-get clean

RUN mkdir -p /etc/nginx/ssl


COPY ./conf/default.conf /etc/nginx/conf.d/default.conf
COPY ./conf/script_nginx.sh /script_nginx.sh

RUN chmod +x /script_nginx.sh


RUN /script_nginx.sh


EXPOSE 443


CMD ["nginx", "-g", "daemon off;"]
