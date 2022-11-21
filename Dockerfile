FROM php:8.1.9-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    libjpeg-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libldap2-dev \
    libc-client-dev libkrb5-dev \
    libxslt-dev libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl soap bcmath iconv xsl zip
RUN docker-php-ext-enable pdo_mysql
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-install ldap
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap
RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-install gd

# Copy files
COPY . /var/www
COPY .docker/php/conf.d/error_reporting.ini /usr/local/etc/php/conf.d/error_reporting.ini
COPY .docker/php/conf.d/php.ini /usr/local/etc/php/conf.d/php.ini

RUN useradd -G www-data,root -u 1000 -d /home/ limesurvey
RUN mkdir -p /home/limesurvey/.composer && \
    chown -R limesurvey:limesurvey /home/limesurvey  && \
    chown -R limesurvey:limesurvey /var/www && \
    chmod -R 755 /var/www/tmp && \
    chmod -R 777 /var/www/sessions && \
    chmod -R 755 /var/www/upload && \
    chmod -R 755 /var/www/application/config

USER limesurvey

EXPOSE 9000

CMD ["php-fpm"]