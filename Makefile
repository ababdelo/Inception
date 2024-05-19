#******************************************************************************#
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ababdelo <ababdelo@student.1337.ma>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/05/18 15:00:03 by ababdelo          #+#    #+#              #
#    Updated: 2024/05/19 14:12:59 by ababdelo         ###   ########.fr        #
#                                                                              #
#******************************************************************************#

# ================================================= #
#                     GENERICS                      #
# ================================================= #

# Phony targets to prevent conflicts with files named like targets
.PHONY: all build clean fclean re status start stop logs help

# Hide calls
export VERBOSE = TRUE
ifeq ($(VERBOSE),FALSE)
    HIDE =
else
    HIDE = @
endif

# ================================================= #
#                      COLORS                       #
# ================================================= #

RESET			= \033[0m
WHITE			= \033[1;37m
GREY    		= \033[1;90m
BLACK			= \033[1;30m
BROWN			= \033[1;38;5;88m
ORANGE			= \033[1;38;5;208m
YELLOW			= \033[1;33m
RED				= \033[1;31m
BLUE			= \033[1;34m
CYAN			= \033[1;36m
GREEN			= \033[1;32m
MAGENTA			= \033[1;35m

LIGHT_RED		= \033[91m
LIGHT_GREEN		= \033[92m
LIGHT_YELLOW	= \033[93m
LIGHT_BLUE		= \033[94m
LIGHT_MAGENTA	= \033[95m
LIGHT_CYAN		= \033[96m
LIGHT_GREY		= \033[1;37m

# ================================================= #
#                     VARIABLES                     #
# ================================================= #

# Paths
DOCKER_COMPOSE_FILE := srcs/docker-compose.yml
MARIADB_VLM := /home/ababdelo/data/mariadb
WORDPRESS_VLM := /home/ababdelo/data/wordpress

# Commands
RM = ${HIDE}sudo rm -rf
MKDIR = ${HIDE}mkdir -p

# ================================================= #
#                       RULES                       #
# ================================================= #

# Default target: builds the Docker containers
all: build
	${HIDE}printf "${GREEN}All containers have finished building.${RESET}\n"

# Target to build Docker containers
build:
	${HIDE}printf "${CYAN}Creating necessary directories...${RESET}\n"
	${MKDIR} $(WORDPRESS_VLM) $(MARIADB_VLM)
	${HIDE}printf "${CYAN}Building Docker containers...${RESET}\n"
	${HIDE}docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --build
	${HIDE}printf "${GREEN}Docker containers have been successfully built.${RESET}\n"

# Target to stop and remove containers and associated images
clean:
	${HIDE}printf "${YELLOW}Stopping and removing Docker containers and images...${RESET}\n"
	${HIDE}docker-compose -f $(DOCKER_COMPOSE_FILE) down --rmi all
	${HIDE}printf "${GREEN}Docker containers and associated images have been cleaned up.${RESET}\n"

# Target to perform a full cleanup (including volumes and directories)
fclean: clean
	${HIDE}printf "${RED}Removing Docker volumes...${RESET}\n"
	${HIDE}docker-compose -f $(DOCKER_COMPOSE_FILE) down -v
	${HIDE}printf "${RED}Deleting local data directories...${RESET}\n"
	${RM} $(MARIADB_VLM) $(WORDPRESS_VLM)
	${HIDE}printf "${GREEN}All Docker volumes and directories have been removed.${RESET}\n"
	${HIDE}printf "${RED}Removing Docker Build cache...${RESET}\n"
	${HIDE}docker builder prune --all -f
	${HIDE}printf "${GREEN}Full cleanup successfully finished.${RESET}\n"

# Target to perform a full clean and rebuild containers
re: fclean all

# Target to display the status of containers
status:
	${HIDE}printf "${BLUE}Displaying the status of Docker containers...${RESET}\n"
	${HIDE}docker-compose -f $(DOCKER_COMPOSE_FILE) ps

# Target to start all containers
start:
	${HIDE}printf "${GREEN}Starting all Docker containers...${RESET}\n"
	${HIDE}docker-compose -f $(DOCKER_COMPOSE_FILE) start
	${HIDE}printf "${GREEN}All Docker containers have been started.${RESET}\n"

# Target to stop all containers
stop:
	${HIDE}printf "${RED}Stopping all Docker containers...${RESET}\n"
	${HIDE}docker-compose -f $(DOCKER_COMPOSE_FILE) stop
	${HIDE}printf "${RED}All Docker containers have been stopped.${RESET}\n"

# Target to display logs of containers
logs:
	${HIDE}printf "${CYAN}Displaying Docker container logs...${RESET}\n"
	${HIDE}docker-compose -f $(DOCKER_COMPOSE_FILE) logs

nginx:
	${HIDE}docker-compose -f srcs/docker-compose.yml exec nginx bash

mariadb:
	${HIDE}docker-compose -f srcs/docker-compose.yml exec mariadb bash

wordpress:
	${HIDE}docker-compose -f srcs/docker-compose.yml exec wordpress bash

# Target to display help information
help:
	${HIDE}printf "${WHITE}\nUsage: make [target]\n\n${RESET}"
	${HIDE}printf "Targets:\n"
	${HIDE}printf "  ${GREEN}all${RESET}       : Build Docker containers (default)\n"
	${HIDE}printf "  ${CYAN}build${RESET}     : Build Docker containers\n"
	${HIDE}printf "  ${YELLOW}clean${RESET}     : Stop and remove containers and images\n"
	${HIDE}printf "  ${RED}fclean${RESET}    : Perform a full cleanup (including volumes and directories)\n"
	${HIDE}printf "  ${CYAN}re${RESET}        : Perform a full clean and rebuild containers\n"
	${HIDE}printf "  ${ORANGE}status${RESET}    : Display the status of containers\n"
	${HIDE}printf "  ${GREEN}start${RESET}     : Start all containers\n"
	${HIDE}printf "  ${RED}stop${RESET}      : Stop all containers\n"
	${HIDE}printf "  ${BLUE}logs${RESET}      : Display logs of containers\n"
	${HIDE}printf "  ${WHITE}help${RESET}      : Display this help message\n"
	${HIDE}printf "${WHITE}\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n${RESET}"
