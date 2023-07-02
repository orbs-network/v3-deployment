#!/bin/bash

# TODO
# - Do we need sudo?
# - Finalise minimum machine specs
# - Seperate into two different repos (installer, descriptors)
# - Double check cron job gets persisted between reboots

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ----- ENSURE CONFIG VARS FILE IS PRESENT -----
# if [ ! -f ".env" ]; then
#     echo -e "${RED}Please create a config.json file${NC}"
#     echo -e "${RED}Exiting...${NC}"
#     exit 1
# fi

# ----- CHECK MINIMUM MACHINE SPECS -----
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

#  ----- INSTALL DEPEDENCIES ----- 
echo -e "${BLUE}Installing dependencies...${NC}"
# TODO: I suspect it is dangerous to run upgrade each time installer script is run
apt-get update -qq && apt-get -y upgrade -qq 
echo -e "${YELLOW}This may take a few minutes. Please wait...${NC}"
apt-get install -qq -y software-properties-common podman docker-compose git cron > /dev/null
systemctl enable cron

# Need to explicitly add docker.io registry
echo "[registries.search]" > /etc/containers/registries.conf && echo "registries = ['docker.io']" >> /etc/containers/registries.conf

# This is needed so Docker Compose can interact with Podman instead of the default Docker daemon
mkdir -p /run/podman
podman system service -t 0 unix:///run/podman/podman.sock &
export DOCKER_HOST=unix:///run/podman/podman.sock

echo -e "${GREEN}Finished installing dependencies!${NC}"
echo "------------------------------------"

# ----- FETCH LATEST VERSION OF DESCRIPTORS -----
echo -e "${BLUE}Downloading node descriptor files...${NC}"
# TODO: this is the wrong repo
git clone https://github.com/orbs-network/v3-node-setup.git descriptors
# Disable detached head warning. This is fine as we are checking out tags
cd /home/descriptors && git config advice.detachedHead false
python3 /home/orchestrator.py

echo -e "${GREEN}Latest node descriptor files downloaded!${NC}"
echo "------------------------------------"

# ----- SETUP ORCHESTRATOR ON CRON -----
echo -e "${BLUE}Setting up orchestrator...${NC}"

chmod +x /home/orchestrator.py
crontab /home/descriptor-poll.cron
service cron restart

echo -e "${GREEN}Orchestrator running!${NC}"
echo "------------------------------------"

echo -e "${GREEN}Installation complete!${NC}"
