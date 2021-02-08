Symfony-Containers
==================

These containers are made to work with the [Docker-Proxy-Stack](https://github.com/Sengorius/docker-proxy-stack)
from Sengorius. Their main purpose is to run a Symfony project for development.


## NGINX

The NGINX comes with a basic path `/var/www/html/public`, to cooperate with the Symfony file system. It has a
self-signed certificate installed and changes the owner of any mounted file in `/var/www/html` to `www-data`.
The corresponding PHP service can be configured from the outside via variables.

Running as a standalone container:

```shell
docker run --rm -d --name "sf-nginx" \
    -v "$(pwd):/var/www/html:ro" \
    -p "8000:80" \
    -p "4430:443" \
    -e "NGINX_PHP_HOST=php" \
    -e "NGINX_PHP_PORT=9000" \
    vcatconsulting/symfony-nginx:latest
```

Using with the Docker-Proxy-Stack or in any other `docker-compose` file:

```yaml
services:
    web:
        image: vcatconsulting/symfony-nginx:latest
        container_name: sf-nginx
        volumes:
            - .:/var/www/html
        ports:
            - "8000:80"
            - "4430:443"
        environment:
            NGINX_PHP_HOST: php
            NGINX_PHP_PORT: 9000
```


## PHP

Our PHP containers are not small, but very feature heavy. You can choose between PHP version 7.3,
7.4 and 8.0, all based on the FPM architecture. Every container comes with lots of activated extensions,
the lates Composer executables in version 1 and 2 plus installed Node JS and Yarn, for your JavaScript
builds. It changes the owner of any mounted file in `/var/www/html` to `www-data` and has an installed
vim editor (just in case you need it).

These containers also integrate your `~/.ssh` directory, so you can use the installed `git` executable
as you are familiar with.

Running as a standalone container:

```shell
docker run --rm -d --name "sf-php" \
    -v "$(pwd):/var/www/html:ro" \
    -v "~/.ssh:/tmp/.ssh:ro" \
    vcatconsulting/symfony-php:8.0-fpm
```

Using with the Docker-Proxy-Stack or in any other `docker-compose` file:

```yaml
version: '3.5'

services:
    php:
        image: vcatconsulting/symfony-php:8.0-fpm
        container_name: sf-php
        volumes:
            - .:/var/www/html
            - ~/.ssh:/tmp/.ssh:ro
```
