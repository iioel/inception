FROM debian:bookworm-slim

RUN apt update \
	&& apt install -y php-fpm php-mysql wget libfcgi0ldbl \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i "s/^listen = .*$/listen = 9000/" /etc/php/8.2/fpm/pool.d/www.conf \
	&& sed -i "s|^error_log = .*$|error_log = /dev/stderr|" /etc/php/8.2/fpm/php-fpm.conf \
	&& sed -i "s|^;access.log = .*$|access.log = /dev/stdout|" /etc/php/8.2/fpm/pool.d/www.conf

RUN mkdir -p /var/www/wordpress \
	&& mkdir -p /run/php \
	&& chown -R www-data:www-data /var/www/ \
	&& chown -R www-data /etc/php/ \
	&& chown -R www-data /proc/self/fd/2 \
	&& chown -R www-data /run/php

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/ \
	&& chmod +x /usr/local/bin/wp-cli.phar \
	&& ln -s /usr/local/bin/wp-cli.phar /usr/local/bin/wp

ADD ./tools/entrypoint.sh /entrypoint.sh

USER www-data

VOLUME /var/www/wordpress

ENTRYPOINT /entrypoint.sh

EXPOSE 9000
