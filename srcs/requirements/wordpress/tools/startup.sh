# creates necessary folders
mkdir -p /var/run/
mkdir -p /run/php/

# Check if wordpress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
	
    # Changes to the website main folder
	cd /var/www/html/
	
    # Downloads the WordPress core files
	wp core download --allow-root
 
    # Waits until mariadb be operational
	until mysqladmin -hmariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} ping; do
       sleep 2
    done
    
    # Creates the Wordpress config file wp-config.php
	wp config create --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=mariadb:3306 --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
	# Install a WordPress site
    wp core install --url=${WP_URL} --title="${WP_TITLE}" --admin_user=${WP_ADMIN} --admin_password=${WP_ADMIN_PASSWORD} --admin_email="$WP_ADMIN@student.42.fr" --allow-root
	# Create a new user in WordPress
    wp user create ${WP_USER} "$WP_USER"@user.com --role=author --user_pass=${WP_USER_PASSWORD} --allow-root
    # Install a theme to show the website
    wp theme install inspiro --activate --allow-root
    # Changes the ownership of folder /var/www/html/wp-content to webserver user www-data
	chown -R www-data:www-data /var/www/html/wp-content
fi

# Starts PHP-FPM in the foreground and replaces the shell process
exec /usr/sbin/php-fpm7.4 -F