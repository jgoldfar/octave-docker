Octave docker container
=====

[![Docker Build Status](https://img.shields.io/docker/build/jgoldfar/octave.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/jgoldfar/octave.svg)](https://hub.docker.com/r/jgoldfar/octave/)
[![Build Status](https://travis-ci.org/jgoldfar/octave-docker.svg?branch=master)](https://travis-ci.org/jgoldfar/octave-docker)

This repository builds containers for Octave, primarily for the purposes of running continuous integration processes against MATLAB code.

Setup
-----
First, add your local user to docker group:

```shell
sudo usermod -aG docker YOURUSERNAME
```

build:

```shell
docker build -t jgoldfar/octave .
```

Usage:
-----

```shell
docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v "$(pwd)":/data jgoldfar/octave
```

`WORKDIRs` match, mounted to `/data` inside container.

Why should I use this container?

-----

- Easy setup

## Container Descriptions

* `debian` contains an Octave installation on top of Debian Stretch

* `alpine` contains an Octave installation on top of Alpine Linux Edge
