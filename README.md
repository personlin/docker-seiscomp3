# docker-seiscomp3

A Dockerfile to create a SeisComP3 image for Docker, currently an **experimental** project, don't use it in production.

## Build

```bash
git clone https://github.com/eost/docker-seiscomp3.git
cd docker-seiscomp3/2017.334
docker build -t seiscomp3:2017.334 .
```

## Run

```bash
docker run --rm -it seiscomp3
```

If you want GUI:

```bash
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY seiscomp3
```

This allows to run graphical application:

```bash
docker exec seiscomp3 seiscomp exec scolv
```

## Configuration

A folder with the global configuration of seiscomp3 and custom plugins must be
mounted in `/data/seiscomp3`. The same file tree is used than SeisComP3.
Moreover, the local configuration can be mounted in `/data/.seiscomp3`.