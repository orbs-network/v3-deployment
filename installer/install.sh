#!/bin/bash

# TODO
# - Do we need sudo?

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ----- Ensure config vars file is present -----
# if [ ! -f ".env" ]; then
#     echo -e "${RED}Please create a config.json file${NC}"
#     echo -e "${RED}Exiting...${NC}"
#     exit 1
# fi

#  ----- Install depedencies ----- 
echo -e "${NC}Installing depencies...${NC}"
apt-get update && apt-get -y upgrade
apt-get install -y podman docker-compose
# Need to explicitly add docker.io registry
echo "[registries.search]" > /etc/containers/registries.conf && echo "registries = ['docker.io']" >> /etc/containers/registries.conf

