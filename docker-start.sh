#!/bin/bash

git pull

echo "STARTING DOCKER ENVIRONMENT..."
docker-compose up -d --build php

#echo "INSTALLING ICE HRM"
#docker-compose exec -T php bash -c '/bin/start.sh'
