NAME = inception

all: build
# Creates the necessary folders for docker volumes
create_volume_folder:
	@if [ ! -d /home/bcastelo/data/mariadb ]; then \
		mkdir -p /home/bcastelo/data/mariadb; \
	fi
	@if [ ! -d /home/bcastelo/data/wordpress ]; then \
		mkdir -p /home/bcastelo/data/wordpress; \
	fi

# Uses the docker compose file to build the images and start the containers in background (Detached mode)
build: create_volume_folder
	docker-compose -f srcs/docker-compose.yml up --build -d

# Starts the containers following the docker compase file
start: 
	docker-compose -f srcs/docker-compose.yml start

# Stops the containers following the docker compase file
stop: 
	docker-compose -f srcs/docker-compose.yml stop

# Stop and remove containers. Also remove volumes and all images
clean: 
	docker-compose -f srcs/docker-compose.yml down --volumes --rmi all

# Removes all unused containers, volumes and images
# Check if any custom network exists, and remove them, if they exist
# Finally, removes all folders used by removes volumes
fclean: clean
	docker system prune -a --volumes --force
	docker network ls -q -f "driver=custom" | xargs -r docker network rm 2>/dev/null
	sudo rm -rf /home/bcastelo/data/mariadb/*
	sudo rm -rf /home/bcastelo/data/wordpress/*

re: fclean build

.PHONY: create_volume_folder build clean fclean re