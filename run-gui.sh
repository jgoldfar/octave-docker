#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# XSOCK directory
XSOCK=/tmp/.X11-unix
if [ ! -d "${XSOCK}" ] ; then
# Assume MacOS (for now)
  open -a XQuartz &
fi


# Find IP of local machine
#IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
IP=$(ifconfig lo0 | grep inet | awk '$1=="inet" {print $2}')

# XAUTH directory
XAUTH=/tmp/.docker.xauth

chmod 755 $XAUTH

xauth nlist ${DISPLAY} | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Debian + Octave
DOCKER_USERNAME=jgoldfar
DOCKER_REPO_BASE=octave
IMG_TAG=gui

xhost +

docker run \
       --rm \
       --tty \
       --interactive \
       --name octave \
       --user $(id -u):$(id -g) \
       -e DISPLAY=host.docker.internal:0 \
       -e QT_GRAPHICSSYSTEM="native" \
       --workdir=/data \
       --volume=$(pwd):/data \
       --entrypoint="" \
       --privileged \
       ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} \
       octave --gui --traditional --verbose --debug
       
       #-e XAUTHORITY=${XAUTH} \
       #--volume ${XAUTH}:${XAUTH} \
       #--volume ${XSOCK}:${XSOCK} \
# --net=host \
