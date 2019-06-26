# Find path to this makefile for use in `usage` target.
# See https://stackoverflow.com/questions/18136918/how-to-get-current-relative-directory-of-your-makefile
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

usage:
	@echo "usage: make [-f ${current_dir}/Makefile] [TARGET]"
	@echo ""
	@echo "Valid Targets:"
	@echo "    - run-gui: Open the Octave GUI with the current directory mapped"
	@echo "      to the working directory inside the container. Add the argument"
	@echo "      PKG_PATH=... to mount the given path to /pkg."
	@echo "    - shell: Open a bash shell in the non-gui Octave image"
	@echo "    - build-base: Build the base image for Octave"
	@echo "    - push-base: Push the base image for Octave"
	@echo "    - build-latest: Build the non-gui image for Octave"
	@echo "    - push-latest: Push the non-gui image for Octave"
	@echo "    - build-gui: Build the GUI image for Octave"
	@echo "    - push-gui: Push the GUI image for Octave"

## Recipes for image build
DOCKER_USERNAME?=jgoldfar
DOCKER_REPO_BASE?=octave

# Base image for subsequent Octave build
build-base: Dockerfile.base
	docker build -f $< -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:base .

push-base:
	docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:base

base: build-base push-base

# No-GUI build
build-latest: Dockerfile.debian
	docker build -f $< -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:latest .

push-latest:
	docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:latest

latest: build-latest push-latest

# With-GUI build
build-gui: Dockerfile.gui
	docker build -f $< -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:gui .

push-gui:
	docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:gui

gui: build-gui push-gui

# host.docker.internal:0
PWD:=$(shell pwd)
PKG_PATH?=
ADD_PKG_PATH:=
ifneq (${PKG_PATH},)
ADD_PKG_PATH+=--volume=${PKG_PATH}:/pkg
endif

DISPLAY_PATH:=$(patsubst %:0,%,${DISPLAY})
run-gui:
	xhost + && \
	docker run \
       --rm \
       --tty \
       --interactive \
       --name octave \
       -e DISPLAY=host.docker.internal:0 \
       -e QT_GRAPHICSSYSTEM="native" \
       --workdir=/data \
       --volume=${PWD}:/data ${ADD_PKG_PATH}\
       --volume ${DISPLAY_PATH}:/tmp/.X11-unix:rw \
       --entrypoint="" \
       --privileged \
       ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:gui \
       octave --gui --traditional --verbose && \
	xhost - || xhost -

shell:
	docker run \
		--rm \
		--interactive \
		--tty \
		--workdir /home \
		--volume "$(pwd)/test":/home/ \
		--entrypoint /bin/bash \
		${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:latest
