#!/bin/bash

echo "Stopping and removing all containers..."
docker rm -f $(docker ps -aq)

echo "Removing all Docker images..."
docker rmi -f $(docker images -q)

echo "Removing all Docker volumes..."
docker volume rm $(docker volume ls -q)

echo "Removing all Docker networks..."
docker network prune -f

echo "Cleaning up unused Docker objects..."
docker system prune -af --volumes

echo "Docker cleanup completed!"
