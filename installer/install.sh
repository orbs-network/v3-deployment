#!/bin/bash

# TODO
# - Do we need sudo?
# - Finalise minimum machine specs

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

# ----- Check minimum machine specs -----
echo -e "${BLUE}Checking machine meets minimum hardware requirements...${NC}"
# Min specs
MIN_CPU=4   # in cores
MIN_MEMORY=8   # in GB
MIN_DISK=20 # in GB

# Get current machine specs
CPU=$(nproc --all)
RAM=$(free -g | awk '/^Mem:/{print $2}')
DISK=$(df -BG / | awk 'NR==2{print substr($4, 1, length($4)-1)}')

# Check CPU
if [ $CPU -lt $MIN_CPU ]; then
    echo -e "${RED}Insufficient CPU cores. Required: $MIN_CPU, Available: $CPU.${NC}"
    exit 1
fi

# Check RAM
if [ $RAM -lt $MIN_MEMORY ]; then
    echo -e "${RED}Insufficient memory. Required: $MIN_MEMORY GB, Available: $RAM GB."
    exit 1
fi

# Check Disk
if [ $DISK -lt $MIN_DISK ]; then
    echo -e "${RED}Insufficient Disk space. Required: $MIN_DISK GB, Available: $DISK GB.${NC}"
    exit 1
fi

echo -e "${GREEN}System meets minimum requirements!${NC}"
echo "------------------------------------"

#  ----- Install depedencies ----- 
echo -e "${BLUE}Installing dependencies...${NC}"

apt-get update && apt-get -y upgrade
apt-get install -y podman docker-compose git
# Need to explicitly add docker.io registry
echo "[registries.search]" > /etc/containers/registries.conf && echo "registries = ['docker.io']" >> /etc/containers/registries.conf

echo -e "${GREEN}Finished installing dependencies!${NC}"
echo "------------------------------------"

# ----- Clone repo -----
echo -e "${BLUE}Cloning repo...${NC}"
# git clone 

