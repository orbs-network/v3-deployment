# This creates a temp image to test the installer script

FROM ubuntu:22.10
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common python3 python3-pip

WORKDIR /home

# Needed to allow crons to run in the container
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

COPY installer .

CMD ["/bin/bash"]
