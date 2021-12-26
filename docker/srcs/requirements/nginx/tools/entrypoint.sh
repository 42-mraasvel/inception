# Set domain name in configuration
NGINX_CONF='/etc/nginx/sites-available/nginx.conf'
PATTERN='DOMAIN_NAME'
sed "s/${PATTERN}/${DOMAIN_NAME}/g" -i ${NGINX_CONF}

# Start service in foreground
echo Starting nginx...
nginx
