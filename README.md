# docker-seiscomp3

A Dockerfile to create a SeisComP3 image for Docker, currently an **experimental** project, don't use it in production.

## Build

```bash
git clone https://github.com/eost/docker-seiscomp3.git
cd docker-seiscomp3
docker build -t seiscomp3 .
```

## Run

```bash
docker run --rm -it seiscomp3 /bin/bash
```
