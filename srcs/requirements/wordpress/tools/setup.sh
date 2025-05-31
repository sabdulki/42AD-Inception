#!bin/bash

# wait for mysql to start
# sleep 10
until mysqladmin ping -h"mariadb" --silent; do
  sleep 1
done
# Install Wordpress

echo "DB_NAME=${DB_NAME}, DB_USER=${DB_USER}, DB_USER_PASS=${DB_USER_PASS}, DB_ROOT_PASS=${DB_ROOT_PASS}"


if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create --dbname=$DB_NAME --dbuser=$DB_USER \
        --dbpass=$DB_USER_PASS --dbhost=mariadb --allow-root --skip-check

    wp core install --url=$DOMAIN_NAME --title=$BRAND --admin_user=$WORDPRESS_ADMIN \
        --admin_password=$WORDPRESS_ADMIN_PASS --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --allow-root

    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=author --user_pass=$WORDPRESS_USER_PASS --allow-root

 #   wp config  set WP_DEBUG true  --allow-root

    wp config set FORCE_SSL_ADMIN 'false' --allow-root

    wp config  set WP_CACHE 'true' --allow-root

    chmod 777 /var/www/html/wp-content

    # install theme

    wp theme install twentyfifteen

    wp theme activate twentyfifteen

    wp theme update twentyfifteen
fi

echo "✅ WordPress initialized. Starting PHP-FPM... new version!"

mkdir -p /run/php
chown www-data:www-data /run/php

if ! /usr/sbin/php-fpm7.3 -F; then
    echo "php-fpm path: $(which php-fpm)"
    echo "php-fpm7.3 path: $(which php-fpm7.3)"
    echo "❌ Failed to run /usr/sbin/php-fpm7.3 -F"
fi
# /usr/sbin/php-fpm7.3 -F

