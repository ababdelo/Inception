#******************************************************************************#
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ababdelo <ababdelo@student.1337.ma>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/05/18 15:00:03 by ababdelo          #+#    #+#              #
#    Updated: 2024/10/28 11:30:36 by ababdelo         ###   ########.fr        #
#                                                                              #
#******************************************************************************#

# ================================================= #
#                     GENERICS                      #
# ================================================= #

# Phony targets to prevent conflicts with files named like targets
.PHONY: all build clean fclean re status start stop logs help evaluate shell

# Default target: Display help message
.DEFAULT_GOAL := help

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
all:
	${HIDE}printf "${CYAN}Creating necessary directories...${RESET}\n"
	${MKDIR} $(WORDPRESS_VLM) $(MARIADB_VLM)
	${HIDE}printf "${CYAN}Building Docker containers...${RESET}\n"
	${HIDE}docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --build
	${HIDE}printf "${GREEN}Docker containers have been successfully built.${RESET}\n"

# Target to stop and remove containers and associated images
clean:
	${HIDE}printf "${RED}Stopping and removing Docker containers and images...${RESET}\n"
	${HIDE}docker-compose -f $(DOCKER_COMPOSE_FILE) down --rmi all
	${HIDE}printf "${GREEN}Docker containers and associated images have been cleaned up.${RESET}\n"

# Target to perform a full cleanup (including volumes and directories and building cache)
fclean: clean
	${HIDE}printf "${RED}Stopping all containers...${RESET}\n"
	${HIDE}if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa) || echo "Failed to stop containers"; fi
	${HIDE}printf "${RED}Removing all containers...${RESET}\n"
	${HIDE}if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa) || echo "Failed to remove containers"; fi
	${HIDE}printf "${RED}Deleting local data directories...${RESET}\n"
	${HIDE}${RM} -r $(MARIADB_VLM) $(WORDPRESS_VLM)
	${HIDE}printf "${RED}Removing Docker Build cache...${RESET}\n"
	${HIDE}docker builder prune --all -f || echo "Failed to prune Docker build cache"
	${HIDE}printf "${RED}Removing all images...${RESET}\n"
	${HIDE}if [ -n "$$(docker images -qa)" ]; then docker rmi $$(docker images -qa) || echo "Failed to remove images"; fi
	${HIDE}printf "${RED}Removing all volumes...${RESET}\n"
	${HIDE}if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q) || echo "Failed to remove volumes"; fi
	${HIDE}printf "${RED}Removing all networks...${RESET}\n"
	${HIDE}if [ -n "$$(docker network ls -q)" ]; then docker network rm $$(docker network ls -q) 2>/dev/null || echo "No user-defined network to remove"; fi
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

# Target to open a bash shell in the chosen container
shell:
	${HIDE}printf "${CYAN}Choose a service to open a shell:${RESET}\n"
	${HIDE}printf "${GREEN}1) mariadb${RESET}\n"
	${HIDE}printf "${YELLOW}2) wordpress${RESET}\n"
	${HIDE}printf "${BLUE}3) nginx${RESET}\n"
	${HIDE}read -p "Enter your choice (1-3): " choice; \
	case $$choice in \
		1) printf "${GREEN}Opening shell for mariadb...${RESET}\n"; \
		   docker-compose -f $(DOCKER_COMPOSE_FILE) exec mariadb bash ;; \
		2) printf "${YELLOW}Opening shell for wordpress...${RESET}\n"; \
		   docker-compose -f $(DOCKER_COMPOSE_FILE) exec wordpress bash ;; \
		3) printf "${BLUE}Opening shell for nginx...${RESET}\n"; \
		   docker-compose -f $(DOCKER_COMPOSE_FILE) exec nginx bash ;; \
		*) printf "${RED}Invalid choice. Please select a valid option.${RESET}\n"; \
	esac

evaluate:
	${HIDE}printf "${YELLOW}Stopping all containers...${RESET}\n"
	${HIDE}if [ -n "$$(docker ps -qa)" ]; then \
		docker stop $$(docker ps -qa) || printf "${RED}Couldn't stop some containers${RESET}\n"; \
	else \
		printf "${GREY}No containers to stop${RESET}\n"; \
	fi
	${HIDE}printf "${YELLOW}Removing all containers...${RESET}\n"
	${HIDE}if [ -n "$$(docker ps -qa)" ]; then \
		docker rm $$(docker ps -qa) || printf "${RED}Couldn't remove some containers${RESET}\n"; \
	else \
		printf "${GREY}No containers to remove${RESET}\n"; \
	fi
	${HIDE}printf "${YELLOW}Removing all images...${RESET}\n"
	${HIDE}if [ -n "$$(docker images -qa)" ]; then \
		docker rmi -f $$(docker images -qa) || printf "${RED}Couldn't remove some images${RESET}\n"; \
	else \
		printf "${GREY}No images to remove${RESET}\n"; \
	fi
	${HIDE}printf "${YELLOW}Removing all volumes...${RESET}\n"
	${HIDE}if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q) || printf "${RED}Couldn't remove some volumes${RESET}\n"; \
	else \
		printf "${GREY}No volumes to remove${RESET}\n"; \
	fi
	${HIDE}printf "${YELLOW}Removing custom networks...${RESET}\n"
	${HIDE}if [ -n "$$(docker network ls --filter 'type=custom' -q)" ]; then \
		docker network rm $$(docker network ls --filter 'type=custom' -q) || printf "${RED}Couldn't remove some custom networks${RESET}\n"; \
	else \
		printf "${GREY}No custom networks to remove${RESET}\n"; \
	fi
	${HIDE}printf "${GREEN}Environment cleanup completed. Ready for evaluation.${RESET}\n"

# Target to display help information
help:
	${HIDE}printf "${WHITE}\nUsage: make [target]\n\n${RESET}"
	${HIDE}printf "Targets:\n"
	${HIDE}printf "  ${GREEN}all${RESET}       : Build and start Docker containers\n"
	${HIDE}printf "  ${CYAN}evaluate${RESET}  : Clean up all Docker containers, images, volumes, and networks for evaluation ${GREEN}(default)${RESET}\n"
	${HIDE}printf "  ${YELLOW}clean${RESET}     : Stop and remove only containers and images\n"
	${HIDE}printf "  ${RED}fclean${RESET}    : Full cleanup (containers, images, volumes, and directories)\n"
	${HIDE}printf "  ${CYAN}re${RESET}        : Run fclean, then rebuild and start containers\n"
	${HIDE}printf "  ${ORANGE}status${RESET}    : Display the status of Docker containers\n"
	${HIDE}printf "  ${GREEN}start${RESET}     : Start all Docker containers without rebuilding\n"
	${HIDE}printf "  ${RED}stop${RESET}      : Stop all running Docker containers\n"
	${HIDE}printf "  ${BLUE}logs${RESET}      : Display real-time logs from containers\n"
	${HIDE}printf "  ${MAGENTA}shell${RESET}     : Open a shell for a selected container (options: mariadb, wordpress, nginx)\n"
	${HIDE}printf "  ${WHITE}help${RESET}      : Display this help message\n"
	${HIDE}printf "${WHITE}\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n${RESET}"
