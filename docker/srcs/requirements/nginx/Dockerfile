FROM	debian:buster

# Install NginX and OpenSSL
RUN	apt-get update \
&& apt-get upgrade -y \
&& apt-get -y install --no-install-recommends \
nginx \
openssl

COPY ./tools /tmp

RUN	openssl req -x509 -nodes -days 365 -newkey \
rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key \
-out /etc/ssl/certs/nginx-selfsigned.crt \
-subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=Codam/OU=Codam/CN=localhost"

# Remove default index page.
# disable daemon so that nginx will run in the foreground and keep the container alive.
RUN	rm /var/www/html/index.nginx-debian.html \
&& echo 'daemon off;' >> /etc/nginx/nginx.conf

# Copy website configuration and set up symlink
RUN mv /tmp/nginx.conf /etc/nginx/sites-available \
&& mv /tmp/entrypoint.sh /

RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

ENTRYPOINT	["bash", "/entrypoint.sh"]
