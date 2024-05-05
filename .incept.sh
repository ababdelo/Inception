#!/bin/bash

# ================================================= #
#                      COLORS                       #
# ================================================= #

RESET='\033[0m'
WHITE='\033[1;37m'
GREY='\033[1;90m'
BLACK='\033[1;30m'
MAROON='\033[1;38;5;88m'
ORANGE='\033[1;38;5;208m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
MAGENTA='\033[1;35m'

LIGHT_RED='\033[91m'
LIGHT_GREEN='\033[92m'
LIGHT_YELLOW='\033[93m'
LIGHT_BLUE='\033[94m'
LIGHT_MAGENTA='\033[95m'
LIGHT_CYAN='\033[96m'
LIGHT_GREY='\033[1;37m'

# ================================================= #
#                     VARIABLES                     #
# ================================================= #

# CMDS
if [ "${VERBOSE}" = "TRUE" ]; then
    HIDE="@"
else
    HIDE=""
fi

DCKRZR="${HIDE}docker-compose"  # Define the Docker Compose command
RM="${HIDE} rm -rf"
MKDIR="${HIDE} mkdir -p"
TCHFL="${HIDE} touch"
PRNT="${HIDE} printf"

# Define directories and files to be created
directories=("bonus" "mariadb" "nginx" "tools" "wordpress")
CMPSR="srcs/${DCKRZR}.yml"  # Define the path to the Docker Compose YAML file
files=("${CMPSR}" "Makefile" ".gitignore")  # Define files to be created

# Messages
CLN_MSG="${YELLOW}Clean-up${WHITE}: Successfully Removed Objects Files${RESET}\n"
BLD_MSG="${GREEN}Building${WHITE}: Successfully Created Directory structure and files.${RESET}\n"
ERR_MSG="${RED}[Error]${WHITE} : Wrong Number of Arguments${RESET}\n"
USG_MSG="${CYAN}[Usage]${WHITE} : ./.incept.sh [${YELLOW}clean${RESET} | ${CYAN}build${RESET} | ${GREEN}re${RESET}]${RESET}\n"

# ================================================= #
#                     FUNCTIONS                     #
# ================================================= #

# Function to clean up the project directory
clean(){
    ${RM} srcs Makefile .gitignore
    ${PRNT} "${CLN_MSG}"
}

rebuild(){
    clean # Clean up project directory
    build # Build project file structure
}

# Function to create directories and files
build() {
    # Create directories and files
    ${MKDIR} srcs/requirements  # Create requirements directory
    for directory in "${directories[@]}"; do
        # Create subdirectories for each component
        ${MKDIR} "srcs/requirements/$directory/conf" "srcs/requirements/$directory/tools"
        # Create Dockerfile and .dockerignore for each component
        ${TCHFL} "srcs/requirements/$directory/Dockerfile" "srcs/requirements/$directory/.dockerignore"
    done

    for file in "${files[@]}"; do
        ${TCHFL} "$file"  # Create files
    done

    # Create .gitignore file
    cat <<EOF > .gitignore
# Ignore editor and IDE-specific files
.vscode/
# Ignore OS-specific files
.DS_Store
# Ignore env file
*.env
# Ignore .incept.sh
.incept.sh
EOF

    # Create Makefile
    cat <<EOF > Makefile
# Makefile

DCKRZR="docker-compose"  # Define the Docker Compose command
CMPSR="srcs/${DCKRZR}.yml"  # Define the path to the Docker Compose YAML file

# Define default target
all : up
# Target to start containers
up : 
    \${DCKRZR} -f \${CMPSR} up -d

# Target to stop containers
down : 
    \${DCKRZR} -f \${CMPSR} down

# Target to stop containers
stop : 
    \${DCKRZR} -f \${CMPSR} stop

# Target to start containers
start : 
    \${DCKRZR} -f \${CMPSR} start

# Target to display container status
status : 
    ${HIDE}\docker ps
EOF

    ${PRNT} "${BLD_MSG}"
}

# Main script logic
if [ "$1" == "re" ]; then
    rebuild # re build project file structure
elif [ "$1" == "clean" ]; then
    clean # Clean up project directory
elif [ "$1" == "build" ]; then
    # Build project file structure
    build
else
    ${PRNT} "${ERR_MSG}"
    ${PRNT} "${USG_MSG}"
fi
