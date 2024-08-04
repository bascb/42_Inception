NAME = inception

create_volume_folder:
	@if [ ! -d /home/bcastelo/data/mariadb ]; then \
		mkdir -p /home/bcastelo/data/mariadb; \
	fi
	@if [ ! -d /home/bcastelo/data/wordpress ]; then \
		mkdir -p /home/bcastelo/data/wordpress; \
	fi

build: create_volume_folder
	docker-compose -f srcs/docker-compose.yml up --build -d

start: 
	docker-compose -f srcs/docker-compose.yml start

stop: 
	docker-compose -f srcs/docker-compose.yml stop

clean: 
	docker-compose -f srcs/docker-compose.yml down --volumes --rmi all

fclean: clean
	docker system prune -a --volumes --force
	docker network ls -q -f "driver=custom" | xargs -r docker network rm 2>/dev/null
	sudo rm -rf /home/bcastelo/data/mariadb/*
	sudo rm -rf /home/bcastelo/data/wordpress/*

re: fclean build

.PHONY: create_volume_folder build up down clean fclean re