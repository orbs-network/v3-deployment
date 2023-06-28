# v3-infra-spec

WIP

## Developing

1. Build the test image - `docker build -t test-ubuntu .`
2. Run the test container - `docker run --rm -it --privileged test-ubuntu`
3. Give write permissions to install script - `chmod +x ./install.sh`
4. Run script - `./install.sh`
