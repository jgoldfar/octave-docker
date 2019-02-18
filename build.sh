#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Debian + Octave
DOCKER_REPO_BASE="octave"
for IMG_TAG in debian alpine ; do
docker build -f Dockerfile.${IMG_TAG} -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG} .
docker push ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:${IMG_TAG}
done

# Alpine + Octave (Source)
# Use Docker Hub's infrastructure
#curl -X POST -L https://cloud.docker.com/api/build/v1/source/4813e645-4451-4874-b8d4-88e787c41597/trigger/d09a812d-6a8f-4176-bf23-19141ed9e24e/call/
