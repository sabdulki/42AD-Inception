#!bin/bash
# echo "Checking if /var/www/html/wp-config.php exist"
# ls -l /var/www/html/wp-config.php

until mysqladmin ping -h"mariadb" --silent; do
  sleep 1
done

# cat /tmp/setup.sql

# echo "DB_NAME=${DB_NAME}, DB_USER=${DB_USER}, DB_USER_PASS=${DB_USER_PASS}, DB_ROOT_PASS=${DB_ROOT_PASS}"
# echo "WORDPRESS_ADMIN=${WORDPRESS_ADMIN}, WORDPRESS_ADMIN_PASS=${WORDPRESS_ADMIN_PASS}, WORDPRESS_ADMIN_EMAIL=${WORDPRESS_ADMIN_EMAIL}"
# echo "WORDPRESS_USER=${WORDPRESS_USER}, WORDPRESS_USER_PASS=${WORDPRESS_USER_PASS}, WORDPRESS_USER_EMAIL=${WORDPRESS_USER_EMAIL}"

rm -f /var/www/html/wp-config.php

if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create --dbname=$DB_NAME --dbuser=$DB_USER \
        --dbpass=$DB_USER_PASS --dbhost=mariadb --allow-root

    wp core install --url=$DOMAIN_NAME --title=$BRAND --admin_user=$WORDPRESS_ADMIN \
        --admin_password=$WORDPRESS_ADMIN_PASS --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --allow-root

    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=author --user_pass=$WORDPRESS_USER_PASS --allow-root

 #   wp config  set WP_DEBUG true  --allow-root

    wp config set FORCE_SSL_ADMIN 'false' --allow-root

    wp config  set WP_CACHE 'true' --allow-root

    chmod 755 /var/www/html/wp-content

    # install theme

    wp theme install twentyfifteen

    wp theme activate twentyfifteen

    wp theme update twentyfifteen
fi

echo "✅ WordPress initialized. Starting PHP-FPM... new version!"

mkdir -p /run/php
chown www-data:www-data /run/php

exec /usr/sbin/php-fpm7.3 -F

# echo "Current wp-config content:"
# cat /var/www/html/wp-config.php

# echo "⏳ Waiting for WordPress to be ready..."
while [ ! -f /var/www/html/wp-config.php ]; do
    sleep 2
done

echo "✅ wp-config.php found. Disabling email notifications..."

THEME_DIR=$(find /var/www/html/wp-content/themes -maxdepth 1 -type d | grep -vE '/themes$')

if [ -f "$THEME_DIR/functions.php" ]; then
  cat <<EOF >> "$THEME_DIR/functions.php"

  // Disable comment email notifications
  remove_filter('comment_notification_text', 'wp_notify_postauthor');
  remove_action('comment_post', 'wp_notify_postauthor');
  remove_action('comment_post', 'wp_new_comment_notify_moderator');
EOF
  echo "✅ Email notifications disabled in functions.php"
else
  echo "⚠️ Could not find functions.php"
fi