## Recipes for image build
DOCKER_USERNAME?=jgoldfar
DOCKER_REPO_BASE?=octave
build-builder: Dockerfile.debian
	docker build -f $< --target=builder -t ${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:builder .

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

shell:
	docker run \
		--rm \
		--interactive \
		--tty \
		--workdir /home \
		--volume "$(pwd)/test":/home/ \
		--entrypoint /bin/bash \
		${DOCKER_USERNAME}/${DOCKER_REPO_BASE}:latest
