# create_admin_user [USERNAME] [PASSWORD]
create_admin_user() {
	mysql -u root -e "CREATE USER '${1}'@'localhost' IDENTIFIED BY '${2}';"
	mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${1}'@'localhost' IDENTIFIED BY '${2}';"
	mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${1}'@'%' IDENTIFIED BY '${2}';"
	mysql -u root -e "FLUSH PRIVILEGES"
}

# create_user [USERNAME] [PASSWORD]
create_user() {
	mysql -u root -e "CREATE USER ${1}@'localhost';"
	mysql -u root -e "SET PASSWORD FOR '${1}'@'localhost' = PASSWORD('${2}');"
	mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO ${1}@'localhost' IDENTIFIED BY '${2}';"
	mysql -u root -e "GRANT ALL ON ${DB_NAME}.* TO ${1}@'%' IDENTIFIED BY '${2}';"
	mysql -u root -e "FLUSH PRIVILEGES"
}

setup_db() {
	# This should be done if the volume is not present as in DB doesn't exist
	echo Setting up database...

	service mysql start
	sleep 15

	# Set up database
	mysql -u root -e "CREATE DATABASE ${DB_NAME};"
	create_admin_user ${DB_USER} ${DB_PASSWORD}
	create_user ${DB_USER2} ${DB_PASSWORD2}
	mysql -u root -e "update mysql.user set plugin='' where user='root';"

	# Set up root password
	mysql -u root -e "SET PASSWORD FOR root@'localhost' = PASSWORD('${DB_ROOT_PASSWORD}');"

	service mysql stop

	# MySQL ownership and permissions
	chmod -R ug+rw /var/lib/mysql
	chown -R mysql:mysql /var/lib/mysql
}

DIR='/var/lib/mysql/wordpress'
if [ ! -d "${DIR}" ]; then
	setup_db
	echo  setup successful!
fi

# Run MySQL in foreground
mysqld
