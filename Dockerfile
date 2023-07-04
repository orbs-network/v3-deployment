# This creates a temp image to test the installer script

FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa

# Install Python 3.11
RUN apt-get update \
    && apt-get install -y python3.11 python3-pip

WORKDIR /home

# Needed to allow crons to run in the container
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

COPY installer .

CMD ["/bin/bash"]