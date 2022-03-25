# Octave docker container

[![Docker Build Status](https://img.shields.io/docker/automated/jgoldfar/octave.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/jgoldfar/octave.svg)](https://hub.docker.com/r/jgoldfar/octave/)

This repository builds containers for [Octave](https://octave.org/), primarily for the purposes of running continuous integration processes against MATLAB code.

## Setup

build:

```shell
docker build -t jgoldfar/octave -f Dockerfile.debian .
```

## Usage

```shell
docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v "$(pwd)":/data jgoldfar/octave:debian
```

Your current working directory should be mounted to `/data` inside the running container.

Why should I use this container?

- Easy setup, reduced need for locally installed dependencies

## Container Descriptions

* `latest` contains an Octave installation on top of Debian Stretch, without GUI components

* `gui` is the same as above, including GUI components. Run `make run-gui` to start the Octave GUI.

* `base` is a base image for Octave software compilation.
