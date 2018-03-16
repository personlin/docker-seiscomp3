# docker-seiscomp3

A Dockerfile to create a SeisComP3 image for Docker.

## Build

```bash
git clone https://github.com/eost/docker-seiscomp3.git
cd docker-seiscomp3
docker build -t seiscomp3:latest .
```

## Configuration

Here is a docker-compose example file:

```yml
version: '2.1'

services:
    # Define database docker
    db:
        image: postgres:10-alpine
        environment:
            POSTGRES_USER: sysop
            POSTGRES_PASSWORD: sysop
            POSTGRES_DB: seiscomp3
        volumes:
            # Mount database in a permanent volume
            - db:/var/lib/postgresql/data
        ports:
            - "10000:5432"

    seiscomp3:
        image: seiscomp3:latest
        environment:
            # Used to start GUI applications
            DISPLAY: unix$DISPLAY
        volumes:
            # `/data/seiscomp3` is copied at the start of the docker in
            # `/opt/seiscomp3`.
            - ./seiscomp3:/data/seiscomp3
            # `/data/.seiscomp3` is copied at the start of the docker in
            # `/home/sysop/.seiscomp3`.
            - ./.seiscomp3:/data/.seiscomp3
            # This volume is used to keep the state of the modules. A deamon is
            # running to copy every `*.auto` file of the
            # `/opt/seiscomp3/etc/init` folder in the `/data/init` folder so
            #that the container can be restarted in the same state.
            - ./init:/data/init
            # Configuration folder
            - ./etc:/opt/seiscomp3/etc
            # Mount etc/defaults, etc/descriptions and etc/init in volumes to
            # keep the files of the docker.
            - defaults:/opt/seiscomp3/etc/defaults
            - descriptions:/opt/seiscomp3/etc/descriptions
            - init:/opt/seiscomp3/etc/init
            # Mount eventually maps folder
            - path/to/maps:/opt/seiscomp3/share/maps
            # Mount locsat folder
            - path/to/seiscomp3/share/locsat:/opt/seiscomp3/share/locsat
            - ./var:/opt/seiscomp3/var
            - ./.seiscomp3/log:/home/sysop/.seiscomp3/log
            # Used to start GUI applications
            - /tmp/.X11-unix:/tmp/.X11-unix
        ports:
            - "10001:4803"

volumes:
    # Define external volume for database
    db:
        external: True
        name: project_db
    # define named volumes which can be remove with `docker-compose down -v`
    defaults:
    descriptions:
    init:
```

With this docker-compose, seiscomp3 applications like scolv can be started on
the user computer:

```bash
seiscomp exec scolv -H localhost:10001 -d postgresql://sysop:sysop@localhost:10000/seiscomp3
```

or in the docker:

```bash
docker exec -it project_seiscomp3_1 seiscomp exec scolv
```