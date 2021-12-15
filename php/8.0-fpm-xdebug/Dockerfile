FROM vcatconsulting/symfony-php:8.0-fpm

MAINTAINER VCAT Consulting GmbH <team.sf@vcat.de>

RUN pecl install xdebug && docker-php-ext-enable xdebug

COPY php-ext-xdebug.ini /usr/local/etc/php/conf.d/php-ext-xdebug.ini


