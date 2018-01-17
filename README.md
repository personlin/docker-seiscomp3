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

It can be useful to mount the following volumes:

- `/data/seiscomp3`
- `/data/.seiscomp3`
- `/data/init`
- `/opt/seiscomp3/etc` (without `/opt/seiscomp3/etc/defaults`,
  `/opt/seiscomp3/etc/descriptions` and `/opt/seiscomp3/etc/init`)
- `/opt/seiscomp3/share/maps`
- `/opt/seiscomp3/share/locsat`
- `/opt/seiscomp3/var`
- `/home/sysop/.seiscomp3/log`
- `/tmp/.X11-unix`

The `/data/seiscomp3`, `/data/.seiscomp3` and `/data/init` folders are copied
at the start of the container respectively in `/opt/seiscomp3`,
`/home/sysop/.seiscomp3` and `/opt/seiscomp3/etc/init`. The `/data/init` is
used to keep the state of the different modules. A daemon is running to copy
every `*.auto` file of the `/opt/seiscomp3/etc/init` in the `/data/init` so
that the container can be restarted in the same state.