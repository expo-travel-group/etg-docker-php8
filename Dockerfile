FROM php:8.0-cli-alpine

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions apcu gd intl memcached ldap bcmath zip pdo_mysql imagick sodium xdebug @composer-2 \
  && apk add --no-cache curl nano

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# increase PHP memory limit
RUN echo "memory_limit=512M" > $PHP_INI_DIR/conf.d/memory_limit.ini

# Xdebug in coverage mode
RUN echo "xdebug.mode=coverage" > $PHP_INI_DIR/conf.d/xdebug.ini
