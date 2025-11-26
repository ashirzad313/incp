FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    vsftpd \
    && apt-get clean

RUN useradd -m -s /bin/bash ftpuser && \
    echo "ftpuser:ftppass" | chpasswd

RUN mkdir -p /home/ftpuser/wordpress && \
    chown -R ftpuser:ftpuser /home/ftpuser/wordpress

COPY conf/vsftpd.conf /etc/vsftpd.conf

EXPOSE 20 21 65500-65515

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
