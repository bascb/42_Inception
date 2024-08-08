# Current oldsatble: Debian 11 Bullseye
FROM	debian:oldstable

# Update system and install necessary packages
RUN	apt update && apt upgrade -y && \
	apt install -y wget \
	curl tar mariadb-client \
	php php-fpm php-mysql \
	php-curl php-gd php-intl php-mbstring \
	php-soap php-xml php-xmlrpc php-zip

# Get Wordpress
RUN	wget https://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz