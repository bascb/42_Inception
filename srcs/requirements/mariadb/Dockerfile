# Current oldsatble: Debian 11 Bullseye
FROM	debian:oldstable

# Update system and install necessary packages
RUN	apt update && apt upgrade -y && apt install mariadb-server -y

# Copies startup script
COPY	tools/startup.sh .

# Open port to communicate
EXPOSE	3306

# Set the command to run on container startup
CMD	["bash", "startup.sh"]