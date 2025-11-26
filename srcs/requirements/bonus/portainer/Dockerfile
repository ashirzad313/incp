FROM portainer/portainer-ce:latest

EXPOSE 8000 9000

VOLUME ["/data"]

CMD ["--host", "unix:///var/run/docker.sock"]
