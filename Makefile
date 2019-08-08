# Find path to this makefile for use in `usage` target.
# See https://stackoverflow.com/questions/18136918/how-to-get-current-relative-directory-of-your-makefile
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

usage:
	@echo "usage: make [-f ${current_dir}/Makefile] [TARGET]"
	@echo ""
	@echo "Valid Targets:"
	@echo " Container Management:"
	@echo "    - run-gui: Open the Octave GUI with the current directory mapped"
	@echo "      to the working directory inside the container. Add the argument"
	@echo "      PKG_PATH=... to mount the given path to /pkg."
	@echo "    - run-shell: Open a bash shell in the non-gui Octave image."
	@echo "      To change the image, set DOCKER_RUN_TAG=.... Default: ${DOCKER_RUN_TAG}"
	@echo "    - run-script: Run a script using the image with DOCKER_RUN_TAG."
	@echo "      Default script: DOCKER_RUN_SCRIPT=${DOCKER_RUN_SCRIPT}."
	@echo "    - run-command: Run/evaluate a given command in Octave."
	@echo "      Default command: DOCKER_RUN_COMMAND=${DOCKER_RUN_COMMAND}."
	@echo " By default, the run-script and run-command targets call octave with the"
	@echo " arguments OCTAVE_RUN_ARGS=${OCTAVE_RUN_ARGS}."
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

# Tag to use when running examples/scripts/etc.
DOCKER_RUN_TAG?=gui
# User information to pass to docker container
DOCKER_RUN_USER:=$(id -u):$(id -g)
# Display path for X11
DISPLAY_PATH:=$(patsubst %:0,%,${DISPLAY})

# Run gui for octave
run-gui:
	xhost + && \
	docker run \
       --rm \
       --tty \
       --interactive \
       --name octave \
       -e DISPLAY=host.docker.internal:0 \
       -e QT_GRAPHICSSYSTEM="native" \
			 --user="${DOCKER_RUN_USER}" \
       --workdir=/data \
       --volume=${PWD}:/data ${ADD_PKG_PATH}\
       --volume ${DISPLAY_PATH}:/tmp/.X11-unix:rw \
       --entrypoint="" \
       --privileged \
       ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${DOCKER_RUN_TAG} \
       octave --gui --traditional --verbose && \
	xhost - || xhost -

# Run shell in given image
run-shell:
	docker run \
		--rm \
		--interactive \
		--tty \
		--name octave \
		--net=none \
		--workdir /data \
		--user="${DOCKER_RUN_USER}" \
		--volume "${PWD}":/data/ \
		--entrypoint /bin/bash \
		${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${DOCKER_RUN_TAG}

# Arguments for octave inside the container for run-script and
# run-command:
OCTAVE_RUN_ARGS?=--no-gui --no-window-system --no-line-editing --traditional --verbose

# Run Main.m file
DOCKER_RUN_SCRIPT?=Main.m
run-script: ${PWD}/${DOCKER_RUN_SCRIPT}
	docker run \
       --rm \
       --tty \
       --name octave \
       --workdir=/data \
			 --user="${DOCKER_RUN_USER}" \
       --volume=${PWD}:/data ${ADD_PKG_PATH}\
       --entrypoint="" \
       --privileged \
       ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${DOCKER_RUN_TAG} \
       octave ${OCTAVE_RUN_ARGS} ${DOCKER_RUN_SCRIPT}

DOCKER_RUN_COMMAND?=
ifeq (${DOCKER_RUN_COMMAND},)
run-command:
	@echo "Usage: make -f ${current_dir}/Makefile $@ DOCKER_RUN_COMMAND=\"...\""
else
run-command:
	docker run \
       --rm \
       --tty \
       --name octave \
       --workdir=/data \
			 --user="${DOCKER_RUN_USER}" \
       --volume=${PWD}:/data ${ADD_PKG_PATH}\
       --entrypoint="" \
       --privileged \
       ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${DOCKER_RUN_TAG} \
       octave ${OCTAVE_RUN_ARGS} --eval "${DOCKER_RUN_COMMAND}"
endif
