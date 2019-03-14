#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# XSOCK directory
XSOCK=/tmp/.X11-unix
if [ ! -f "${XSOCK}" ] ; then
# Assume MacOS (for now)
  open -a XQuartz &
fi

# Find IP of local machine
IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

# XAUTH directory
XAUTH=/tmp/.docker.xauth

chmod 755 $XAUTH

#xauth nlist ${DISPLAY} | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Debian + Octave
DOCKER_USERNAME=jgoldfar
DOCKER_REPO_BASE=octave
IMG_TAG=gui

xhost +

       #--volume ${XSOCK}:${XSOCK} \
       #-e XAUTHORITY=${XAUTH} \
       #--volume ${XAUTH}:${XAUTH} \
docker run \
       --rm \
       --tty \
       --interactive \
       --name octave \
       --user $(id -u):$(id -g) \
       -e DISPLAY=host.docker.internal:0 \
       -e QT_GRAPHICSSYSTEM="native" \
       --net=host \
       --workdir=/data \
       --volume=$(pwd):/data \
       --entrypoint="" \
       --privileged \
       ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} \
       octave --gui

#      ldd /usr/local/libexec/octave/4.4.1/exec/x86_64-pc-linux-gnu/octave-gui
# && octave --gui --traditional
