FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server && apt-get clean

COPY ./conf/script.sh /script.sh

RUN chmod +x /script.sh

EXPOSE 3306

ENTRYPOINT ["/script.sh"]
