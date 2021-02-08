FROM nginx:latest

MAINTAINER VCAT Consulting GmbH <team.sf@vcat.de>

# set env variables
ENV NGINX_PHP_HOST php
ENV NGINX_PHP_PORT 9000
ENV TZ Europe/Berlin

# install modules for git and php
RUN apt-get update && apt-get install -y vim openssl ca-certificates && \
    apt-get autoremove && rm -rf /var/lib/apt/lists/*

# fix the timezone in unix
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install SSL key
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 1825 -newkey rsa:4096 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=DE/ST=Brandenburg/L=Potsdam/O=VCAT Consulting GmbH/OU=Development/CN=docker.test"

# fix the users permissions for www-data
# and create the projekt files directory
RUN set -x && \
	groupmod -g 1000 www-data && \
    usermod -u 1000 www-data && \
	mkdir -p /var/www/html/public && \
	chown -R www-data:www-data /var/www

# copy config files
COPY default.conf /etc/nginx/conf.d/default.conf
COPY ssl.conf /etc/nginx/templates/ssl.conf.template
COPY .bashrc /root/.bashrc

# set the project directory as default
WORKDIR /var/www/html
