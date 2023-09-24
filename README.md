# Octave docker container

[![Docker Pulls](https://img.shields.io/docker/pulls/jgoldfar/octave.svg)](https://hub.docker.com/r/jgoldfar/octave/)
[![Build and push images](https://github.com/jgoldfar/octave-docker/actions/workflows/build.yml/badge.svg)](https://github.com/jgoldfar/octave-docker/actions/workflows/build.yml)

This repository builds containers for [Octave](https://octave.org/), primarily for the purposes of running continuous integration processes against MATLAB code.

PRs welcome; this repository is otherwise minimally maintained.

> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

For more information, reach out to the team at [desert.frog.solutions@gmail.com](mailto:desert.frog.solutions@gmail.com) or [desertfrogsolutions.com](https://desertfrogsolutions.com)


## Setup

build:

```shell
docker build -t jgoldfar/octave -f Dockerfile.debian .
```

## Usage

```shell
docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v "$(pwd)":/data jgoldfar/octave:debian
```

Your current working directory is then mounted to `/data` inside the running container.

Why should I use this container?

- Easy setup, reduced need for locally installed dependencies

## Container Descriptions

* `latest` contains an Octave installation on top of Debian Stretch, without GUI components

* `gui` is the same as above, including GUI components. Run `make run-gui` to start the Octave GUI.
