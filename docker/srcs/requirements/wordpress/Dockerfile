# TODO: Should predownload tars and COPY instead
FROM	debian:buster
WORKDIR	/tmp

# Run installations
RUN export DEBIAN_FRONTEND="noninteractive" \
&& apt-get update \
&& apt-get upgrade -y \
&& apt-get -y install --no-install-recommends \
php-fpm \
php-mysql \
php-mbstring \
sendmail

COPY ./tools/ /tmp
RUN	mkdir -p /var/www/html /run/php

# Set bind address in php configuration
RUN	sed -e 's/\/run\/php\/php7.3-fpm.sock/0.0.0.0:9000/g' -i /etc/php/7.3/fpm/pool.d/www.conf

# Setup phpMyAdmin
RUN tar -xf /tmp/phpMyAdmin-5.0.1-english.tar.gz \
&& mv /tmp/phpMyAdmin-5.0.1-english /var/www/phpmyadmin \
&& mv /tmp/config.inc.php /var/www/phpmyadmin/config.inc.php

# Setup wordpress CLI tool
RUN chmod +x /tmp/wp-cli.phar \
&& mv /tmp/wp-cli.phar /usr/local/bin/wp-cli

# Setup wordpress
RUN tar -xzf /tmp/wordpress-5.8.tar.gz \
&& mv /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php \
&& mv /tmp/wordpress /var/www

# Set permissions for wordpress and php
RUN	userdel www-data \
&& useradd -u 82 www-data \
&& chmod -R 755 /var/www \
&& chown -R www-data:www-data /var/www

# Entrypoint
RUN mv /tmp/entrypoint.sh /

ENTRYPOINT ["bash", "/entrypoint.sh"]
