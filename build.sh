#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Debian + Octave
DOCKER_REPO_BASE="octave"
IMG_TAG=debian-latest

docker build -f Dockerfile.debian -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} .
docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG}

# Alpine + Octave
IMG_TAG=alpine-latest

docker build -f Dockerfile.alpine -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} .
docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG}

# Alpine + Octave (Source)
# Use Docker Hub's infrastructure
#curl -X POST -L https://cloud.docker.com/api/build/v1/source/4813e645-4451-4874-b8d4-88e787c41597/trigger/d09a812d-6a8f-4176-bf23-19141ed9e24e/call/

# # To build locally, run
#IMG_TAG=alpine-source-latest
#docker build -f Dockerfile.alpine-source -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} .
#docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG}
