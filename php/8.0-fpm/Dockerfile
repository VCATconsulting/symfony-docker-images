FROM php:8.0-fpm

MAINTAINER VCAT Consulting GmbH <team.sf@vcat.de>

# variables
ENV TZ Europe/Berlin
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER1_VERSION 1.10.20
ENV WP_CLI_VERSION 2.4.0
ENV NODE_VERSION 14.15.4
ENV YARN_VERSION 1.22.10

# install modules for git and php
# what does `set -ex` do? https://www.computerhope.com/unix/uset.htm
RUN set -eux && \
    apt-get update && apt-get install -y git vim zip unzip \
    libicu-dev libcurl4-gnutls-dev libzip-dev zlib1g-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libpq-dev \
    libwebp-dev libmagickwand-dev libtidy-dev libxslt-dev && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure zip && \
	docker-php-ext-install -j "$(nproc)" intl opcache pdo_pgsql calendar tidy exif xsl > /dev/null && \
	apt-get autoremove && rm -rf /var/lib/apt/lists/*

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

# install WP cli
RUN curl -sSo /usr/local/bin/wp https://github.com/wp-cli/wp-cli/releases/download/v$WP_CLI_VERSION/wp-cli-$WP_CLI_VERSION.phar && \
    curl -sSo /usr/local/bin/wp-completion.sh https://raw.githubusercontent.com/wp-cli/wp-cli/v$WP_CLI_VERSION/utils/wp-completion.bash && \
    chmod +x /usr/local/bin/wp /usr/local/bin/wp-completion.sh

# fix the users permissions for www-data and reset this for the project directory
RUN set -x && \
    groupmod -g 1000 www-data && \
    usermod -u 1000 www-data && \
    chown www-data:www-data /var/www/html

# add NodeJS, NPM and yarn to the development stack
RUN curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" && \
    tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner && \
    rm "node-v$NODE_VERSION-linux-x64.tar.xz" && \
    ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
    node --version && \
    npm --version

RUN curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" && \
    mkdir -p /opt && \
    tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ && \
    ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn && \
    ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg && \
    rm yarn-v$YARN_VERSION.tar.gz && \
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
