FROM php:8.0-fpm

MAINTAINER VCAT Consulting GmbH <team.sf@vcat.de>

# variables
ENV TZ Europe/Berlin
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER1_VERSION 1.10.22
ENV NODE_VERSION 16.20.2
ENV YARN_VERSION 3.6.4

# install modules for git and php
# what does `set -ex` do? https://www.computerhope.com/unix/uset.htm
RUN set -eux && \
    apt-get update && apt-get install -y git vim zip unzip \
    libicu-dev libcurl4-gnutls-dev libzip-dev zlib1g-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libpq-dev \
    libwebp-dev libmagickwand-dev libtidy-dev libxslt-dev libldap2-dev && \
    pecl install -o -f redis && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
	docker-php-ext-install -j "$(nproc)" gd intl opcache pdo_pgsql pdo_mysql calendar tidy exif xsl zip ldap > /dev/null && \
	docker-php-ext-enable redis && \
	apt-get autoremove && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/pear

# install imagemagick from repo
# TODO: fix imagemagick installation, when new release came out
# https://github.com/Imagick/imagick/tags
RUN mkdir -p /usr/src/php/ext && \
    cd /usr/src/php/ext && \
    git clone https://github.com/Imagick/imagick.git && \
    docker-php-ext-install imagick > /dev/null

# fix the timezone in unix
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
	chmod +x composer.phar && \
	mv composer.phar /usr/local/bin/composer

# TODO: remove composer1 if our packages are more stable
RUN curl -sSo /usr/local/bin/composer1 https://getcomposer.org/download/$COMPOSER1_VERSION/composer.phar && \
    chmod +x /usr/local/bin/composer1

# Add python2.7 and pip
ARG PYTHON_VERSION=2.7.9
# Install dependencies
RUN apt-get update \
  && apt-get install -y wget gcc make openssl libffi-dev libgdbm-dev libsqlite3-dev libssl-dev zlib1g-dev \
  && apt-get clean

WORKDIR /tmp/

# Build Python from source
RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
  && tar --extract -f Python-$PYTHON_VERSION.tgz \
  && cd ./Python-$PYTHON_VERSION/ \
  && ./configure --with-ensurepip=install --enable-optimizations --prefix=/usr/local \
  && make && make install \
  && cd ../ \
  && rm -r ./Python-$PYTHON_VERSION*

# fix the users permissions for www-data and reset this for the project directory
RUN set -x && \
    groupmod -g 1000 www-data && \
    usermod -u 1000 www-data && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www

# add NodeJS, NPM and yarn to the development stack
RUN curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" && \
    tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner && \
    rm "node-v$NODE_VERSION-linux-x64.tar.xz" && \
    ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
    node --version && \
    npm --version

RUN corepack enable
RUN yarn set version $YARN_VERSION && \
    yarn --version

# copy config files
COPY docker-entrypoint.sh /usr/local/bin/docker-custom-entrypoint.sh
COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY .bashrc /root/.bashrc
COPY .vimrc /root/.vimrc

# set new entrypoint
RUN chmod +x /usr/local/bin/docker-custom-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-custom-entrypoint.sh"]
CMD ["php-fpm"]
