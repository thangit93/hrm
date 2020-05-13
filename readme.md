# Ant Nest Hrm

This is a docker based development environment for the IceHrm. It's based on 2 containers:

- php (7.3.11)
- mysql (5.5)
  (see `docker-compose.yml` for details)

## Starting, Stopping or Deleting the whole docker stack

There are three shell scripts to help you manage the containers: `./docker-start.sh`, `./docker-stop.sh`, `./docker-remove.sh`. These scripts are pretty simple, check the files for further information.

## Accessing the website and MySQL

The site is available at http://localhost/. MySQL is reachable via `host: mysql`, `port: 3307`, `user: dev`, `password: dev`, `database: icehrm`. See `.env.dev` and `docker-compose.yml` for more details.

