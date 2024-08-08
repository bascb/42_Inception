# Current oldsatble: Debian 11 Bullseye
FROM debian:oldstable

# install necessary packages
RUN apt update && apt upgrade -y && \
    apt install -y \
    nginx openssl

# Create necessary folders
RUN mkdir -p /etc/nginx/ssl && \
    mkdir -p /var/www/html

# Create SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 \  
    -keyout /etc/nginx/ssl/bcastelo.key \
    -out /etc/nginx/ssl/bcastelo.crt \
    -subj "/C=PT/L=Lisbon/O=42Lisboa/OU=bcastelo/CN=bcastelo.42.fr" 

# Copy configuraion file
COPY conf/nginx.conf /etc/nginx/conf.d

# Open port 443 to receive requests    
EXPOSE 443

# Set the command to run on container startup
ENTRYPOINT ["nginx", "-g", "daemon off;"]