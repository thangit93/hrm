#!/bin/bash

git pull

echo "STARTING DOCKER ENVIRONMENT..."
docker-compose up -d

echo "INSTALLING ICE HRM"
docker-compose exec -T php bash -c '/init-icehrm.sh'
