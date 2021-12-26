FROM debian:buster

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get -y install --no-install-recommends \
mariadb-server \
procps

# IP configuration
RUN sed 's/127.0.0.1/0.0.0.0/g' -i /etc/mysql/mariadb.conf.d/50-server.cnf

# Volume ownership
RUN mkdir -p /var/run/mysqld \
&& chown mysql:mysql /var/run/mysqld

# Entrypoint
COPY ./tools/entrypoint.sh /
ENTRYPOINT ["bash", "/entrypoint.sh"]
