#!/usr/bin/env bash

docker-compose exec -T php bash -c "cd core/robo && php robo.phar migrate:all app"