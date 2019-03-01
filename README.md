# Octave docker container

[![Docker Build Status](https://img.shields.io/docker/automated/jgoldfar/octave.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/jgoldfar/octave.svg)](https://hub.docker.com/r/jgoldfar/octave/)
[![Build Status](https://travis-ci.org/jgoldfar/octave-docker.svg?branch=master)](https://travis-ci.org/jgoldfar/octave-docker)

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

* `debian` contains an Octave installation on top of Debian Stretch

* `alpine` contains an Octave installation on top of Alpine Linux Edge
