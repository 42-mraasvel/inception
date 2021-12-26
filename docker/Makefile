NAME = inception

CONTAINERS = $(shell docker ps -aq)
NETWORK = $(shell docker network ls -qf 'name=$(NAME)')
VOLUMES = $(shell docker volume ls -q)
IMAGES = $(shell docker images -q)
COMPOSE_VAR = COMPOSE_FILE=./srcs/docker-compose.yml

ifeq ($(shell uname),Linux)
	RM_VOLUME = sudo rm -rf
else
	RM_VOLUME = rm -rf
endif

all: $(NAME)

$(NAME): clean
	$(COMPOSE_VAR) docker-compose build
	$(COMPOSE_VAR) docker-compose up -d

clean:	delete_containers \
		delete_network \
		delete_volume

delete_containers:
	@if [ ! -z "$(CONTAINERS)" ]; then \
		docker stop $(CONTAINERS) && docker rm $(CONTAINERS); \
	fi
delete_network:
	@if [ ! -z "$(NETWORK)" ]; then \
		docker network rm "$(NETWORK)" ; \
	fi
delete_volume:
	@if [ ! -z "$(VOLUMES)" ]; then \
		docker volume rm $(VOLUMES) ; \
	fi

delete_images:
	@if [ ! -z "$(IMAGES)" ]; then \
		docker rmi $(IMAGES) ; \
	fi

reset_volumes:
	@${RM_VOLUME} ${HOME}/data/*
	@mkdir -p ${HOME}/data/wordpress
	@mkdir -p ${HOME}/data/mariadb

fclean:	clean \
		reset_volumes
re:	fclean \
	all
