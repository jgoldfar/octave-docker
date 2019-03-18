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

PWD:=$(shell pwd)
run-gui:
	xhost +local: && \
	docker run \
       --rm \
       --tty \
       --interactive \
       --name octave \
       -e DISPLAY=host.docker.internal:0 \
       -e QT_GRAPHICSSYSTEM="native" \
       --workdir=/data \
       --volume=${PWD}:/data \
       --entrypoint="" \
       --privileged \
       ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} \
       octave --gui --traditional

shell:
	docker run \
		--rm \
		--interactive \
		--tty \
		--workdir /home \
		--volume "$(pwd)/test":/home/ \
		--entrypoint /bin/bash \
		${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:latest
