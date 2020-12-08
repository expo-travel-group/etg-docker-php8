# Versions 3.8 and 3.7 are current stable supported versions.
FROM alpine:3.12

# trust this project public key to trust the packages.
ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

## you may join the multiple run lines here to make it a single layer

# make sure you can use HTTPS
RUN apk --update --no-cache add ca-certificates

# add the repository, make sure you replace the correct versions if you want.
RUN echo "https://dl.bintray.com/php-alpine/v3.12/php-8.0" >> /etc/apk/repositories

# install php and some extensions
RUN apk add --update --no-cache php php-zip php-bcmath php-gd php-memcached php-mysqli php-xsl php-ldap php-curl php-mbstring php-json php-phar php-sqlite3 php-pdo php-ctype php-apcu php-xdebug

# increase PHP memory limit
RUN echo "memory_limit=512M" >> /etc/php7/conf.d/memory_limit.ini

RUN ln -s /usr/bin/php8 /usr/local/bin/php

# SSH
ARG SSH_DIR="/etc/ssh"
ARG SSH_CONFIG="/etc/ssh/config"

USER root

RUN apk --update --no-cache add curl sshpass openssh-client bash git
RUN set -xe \
    && mkdir -p $SSH_DIR \
	&& echo -e "Host *\n\tStrictHostKeyChecking=no\n\n" >> $SSH_CONFIG
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 
