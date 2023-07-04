# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yoel <marvin@42.fr>                        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/11/15 16:36:11 by yoel              #+#    #+#              #
#    Updated: 2023/07/04 22:00:47 by ycornamu         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception

DOCKER_COMPOSE_FILE = srcs/docker-compose.yaml

D 	= docker
DC 	= docker compose

.PHONY : all build down clean re

all: $(NAME)

$(NAME): $(_OBJS)
	$(DC) -f $(DOCKER_COMPOSE_FILE) up -d

attach:
	$(DC) -f $(DOCKER_COMPOSE_FILE) up

build:
	$(DC) -f $(DOCKER_COMPOSE_FILE) up -d --build

down:
	$(DC) -f $(DOCKER_COMPOSE_FILE) down

clean:
	$(DC) -f $(DOCKER_COMPOSE_FILE) down -v
	$(D) image prune -a -f
	$(D) builder prune -a -f

re: clean all
