#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Debian + Octave
DOCKER_REPO_BASE=octave
IMG_TAG=latest

# First, the builder (which is not pushed to docker hub)
IMG_TARGET=builder
docker build -f Dockerfile.debian --target ${IMG_TARGET} -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} .


# Build main entrypoint
IMG_TARGET=octave
docker build -f Dockerfile.debian --target ${IMG_TARGET} -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} .
docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG}


# Add alternative entrypoint for mkoctfile
IMG_TARGET=mkoctfile
docker build -f Dockerfile.debian --target ${IMG_TARGET} -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG}-${IMG_TARGET} .
docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG}-${IMG_TARGET}

# Alpine + Octave (Source)
# Use Docker Hub's infrastructure
#curl -X POST -L https://cloud.docker.com/api/build/v1/source/4813e645-4451-4874-b8d4-88e787c41597/trigger/d09a812d-6a8f-4176-bf23-19141ed9e24e/call/
