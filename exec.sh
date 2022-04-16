#!/bin/bash

docker-compose exec --user 0:0 php bash -c "$*"