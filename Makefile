name = inception
all:
	@printf "Launch configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml  up --build -d

build:
	@printf "Building configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml  build

up:
	@printf "Run configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml  up -d

stop:
	@printf "Stopping configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml  stop

clean:
	@printf "Cleaning configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml  down

re: clean
	@printf "Rebuild configuration ${name}...\n"
	@$(MAKE) all

fclean:
	@printf "Total clean of all configurations docker\n"
	@docker-compose -f ./srcs/docker-compose.yml down -v
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf $(HOME)/data/wordpress/*
	@sudo rm -rf $(HOME)/data/mariadb/*

.PHONY	: all build up stop re clean fclean