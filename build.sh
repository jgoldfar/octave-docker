#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Debian + Octave
DOCKER_REPO_BASE=octave
IMG_TAG=latest

# First, the builder (which is not pushed to docker hub)
#IMG_TARGET=builder
# docker build -f Dockerfile.debian --target ${IMG_TARGET} -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} .


# Build main entrypoint
IMG_TARGET=octave
docker build -f Dockerfile.debian --target ${IMG_TARGET} -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} .
docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG}


# Add alternative entrypoint for mkoctfile
#IMG_TARGET=mkoctfile
#docker build -f Dockerfile.debian --target ${IMG_TARGET} -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG}-${IMG_TARGET} .
#docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG}-${IMG_TARGET}

## Add GUI build
#IMG_TAG=gui
#docker build -f Dockerfile.${IMG_TAG} --target=builder -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} .

#docker build -f Dockerfile.${IMG_TAG} -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} .
#docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG}

# GUI build on Docker Hub's infrastructure.
curl -X POST -L https://cloud.docker.com/api/build/v1/source/ecd4368d-cffd-4145-9eff-b104ec7f697b/trigger/28c2a1c1-a191-482e-b1fb-c06290d6fc7f/call/
