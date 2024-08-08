# Current oldsatble: Debian 11 Bullseye
FROM	debian:oldstable

# Update system and install necessary packages
RUN	apt update && apt upgrade -y && \
	apt install -y wget \
	tar mariadb-client \
	php php-fpm php-mysql \
	php-curl php-gd php-intl php-mbstring \
	php-soap php-xml php-xmlrpc php-zip

# Create folders website base folder
RUN	mkdir -p /var/www/html

# Install wp-cli.phar from PHP Archive (PHAR). This is a command-line 
# interface for managing WordPress installations
RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# Copies necessary files to run wordpress
COPY	tools/startup.sh /
COPY	conf/www.conf /etc/php/7.4/fpm/pool.debian
COPY 	conf/wp-config.php /

# Changes PHP-FPM to listen on a TCP/IP socket at 0.0.0.0 on port 9000
RUN	sed -ie "s/listen = \/run\/php\/php7.4-fpm.sock/listen = 0.0.0.0:9000/" /etc/php/7.4/fpm/pool.d/www.conf

# Open port to listen
EXPOSE	9000

# Set the command to run on container startup
CMD	["bash", "startup.sh"]