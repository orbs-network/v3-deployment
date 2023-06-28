# This creates a temp image to test the installer script

FROM ubuntu:22.10

COPY installer/install.sh .

CMD ["/bin/bash"]