FROM debian:bookworm-slim

RUN apt update \
	&& apt install -y mariadb-server mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /run/mysqld \
	&& chown -R mysql /run/mysqld \
	&& chown -R mysql /var/lib/mysql \
	&& chown -R mysql /etc/mysql

ADD ./tools/entrypoint.sh /entrypoint.sh

VOLUME /var/lib/mysql

USER mysql

ENTRYPOINT /entrypoint.sh

EXPOSE 3306
