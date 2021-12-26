WP_DIR='/var/www/html/'
HTML_DIR='/var/www/html'

# create_user <login> <email> <password>
create_user() {

	# Create user using the WP CLI tool
	wp-cli --allow-root \
	user create $1 $2 --user_pass=$3 \
	--path="$WP_DIR"
}

set_config() {
	WP_CONF='/var/www/wordpress/wp-config.php'
	# Adjusting the wp-config settings
	sed -i "s/database_name_here/$DB_NAME/g" $WP_CONF
	sed -i "s/username_here/$DB_USER/g" $WP_CONF
	sed -i "s/password_here/$DB_PASSWORD/g" $WP_CONF
	sed -i "s/localhost/$DB_HOST/g" $WP_CONF
}

initialize_wordpress() {
	echo Setting up Wordpress...
	OWP_DIR='/var/www/wordpress'
	PHP_DIR='/var/www/phpmyadmin'

	# Configuration
	set_config

	# Move the directories into volume
	mv "${OWP_DIR}"/* "${HTML_DIR}"
	mv "${PHP_DIR}" "${HTML_DIR}"

	echo Installing Wordpress...
	# Install wordpress
	wp-cli core install \
	--allow-root \
	--title="Wordpress" \
	--admin_name="${WP_ADMIN}" \
	--admin_password="${WP_PASSWORD}" \
	--path="${WP_DIR}" \
	--admin_email="${WP_EMAIL}" \
	--url="${DOMAIN_NAME}"

	echo Creating WP user...
	# New user for the subject
	create_user $WP_USER1 $WP_USER1_EMAIL $WP_USER1_PASSWORD
}

# Check if wordpress was already installed
WP_CONFIG=${WP_DIR}/wp-config.php
if [ ! -f "${WP_CONFIG}" ]; then
	initialize_wordpress
	echo Wordpress initialization successful!
fi

echo Starting php-fpm...
# Run php-fpm in the foreground
php-fpm7.3 -F -R
