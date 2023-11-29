FROM php:7.4-apache

WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install -y mariadb-client git zip libzip-dev zlib1g-dev \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-ext-enable mysqli \
    && docker-php-ext-enable zip \
    && pwd \
    && ls -lh \
    && php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');" \
    && php -r "if (hash_file('sha384', '/tmp/composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('/tmp/composer-setup.php'); } echo PHP_EOL;" \
    && php /tmp/composer-setup.php --2.2 --install-dir=/usr/local/bin --filename=composer \
    && rm -vrf /tmp/composer-setup.php \
    && a2enmod rewrite

COPY --chown=www-data:www-data ./src/composer.json /var/www/html/composer.json

USER www-data

RUN pwd \
    && ls -lh \
    && composer install

COPY --chown=www-data:www-data ./src ./
