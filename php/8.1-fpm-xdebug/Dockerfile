FROM vcatconsulting/symfony-php:8.1-fpm

MAINTAINER VCAT Consulting GmbH <team.sf@vcat.de>

RUN pecl install xdebug && docker-php-ext-enable xdebug

# Chromium and ChromeDriver
ENV PANTHER_NO_SANDBOX 1
# Not mandatory, but recommended
ENV PANTHER_CHROME_ARGUMENTS='--disable-dev-shm-usage'

ARG CHROMEDRIVER_VERSION=90.0.4430.24
ARG CHROMIUM_VERSION=90.0.4430.212-1
RUN curl -sSL http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip -o chromedriver_linux64.zip; \
      unzip chromedriver_linux64.zip chromedriver -d /usr/bin; \
      apt-get update && apt-get install -y chromium=$CHROMIUM_VERSION; \
      apt-get autoremove && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/pear

COPY php-ext-xdebug.ini /usr/local/etc/php/conf.d/php-ext-xdebug.ini

# Firefox and GeckoDriver (optional)
#ARG GECKODRIVER_VERSION=0.28.0
#RUN apt-get install -y firefox libzip-dev; \
  #docker-php-ext-install zip && \
  #apt-get autoremove && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/pear
#RUN curl -sSL https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz --output geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz; \
  #tar -zxf geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz -C /usr/bin; \
  #rm geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz

