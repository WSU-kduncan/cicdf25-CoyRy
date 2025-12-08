#!/bin/bash
CONTAINER_NAME="elden-site"
IMAGE_NAME="coyryan/elden-cake:latest"
PORT="8080:80"

# Stop and remove the existing container silently
docker stop $CONTAINER_NAME > /dev/null 2>&1
docker rm $CONTAINER_NAME > /dev/null 2>&1

# Pull the latest image
docker pull $IMAGE_NAME

# Run a new container as detached (-d) and restart unless stopped (--restart=always)
# The --restart=always flag ensures it resumes running if Docker is started (on system start)
docker run -d -p $PORT --name $CONTAINER_NAME --restart=always $IMAGE_NAME