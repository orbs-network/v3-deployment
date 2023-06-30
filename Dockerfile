# This creates a temp image to test the installer script

FROM ubuntu:22.10

WORKDIR /home

# Needed to allow crons to run in the container
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

COPY installer .

CMD ["/bin/bash"]