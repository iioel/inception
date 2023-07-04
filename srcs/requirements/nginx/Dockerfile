FROM debian:bookworm-slim

ENV DOMAIN_NAME=localhost

RUN apt update \
	&& apt install -y nginx openssl curl \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/wordpress \
	&& chown -R www-data:www-data /var/www/

ADD ./conf /etc/nginx
ADD ./tools/entrypoint.sh /entrypoint.sh

VOLUME /var/www/wordpress

ENTRYPOINT /entrypoint.sh

EXPOSE 443/tcp
