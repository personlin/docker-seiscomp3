FROM debian:stretch-slim

MAINTAINER Fabien Engels <fabien.engels@unistra.fr>

ENV SC_VERSION 2017.124.02
ENV WORK_DIR /tmp
ENV INSTALL_DIR /opt/seiscomp3
ENV PATH $PATH:$INSTALL_DIR/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$INSTALL_DIR/lib
ENV PYTHONPATH $PYTHONPATH:$INSTALL_DIR/lib/python

WORKDIR $WORK_DIR

RUN set -ex \
    && buildDeps=' \
        build-essential \
        ca-certificates \
        cmake \
        gfortran \
        libboost-dev \
        libboost-filesystem-dev \
        libboost-iostreams-dev \
        libboost-program-options-dev \
        libboost-regex-dev \
        libboost-signals-dev \
        libboost-thread-dev \
        libfl-dev \
        libpq-dev \
        libqt4-dev \
        libssl-dev \
        libxml2-dev \
        python-dev \
        wget \
    ' \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        flex \
        libboost-filesystem1.62.0 \
        libboost-iostreams1.62.0 \
        libboost-program-options1.62.0 \
        libboost-regex1.62.0 \
        libboost-signals1.62.0 \
        libboost-thread1.62.0 \
        libpq5 \
        libpython2.7 \
        libxml2 \
        python \
        python-dateutil \
        python-twisted \
        $buildDeps \
    && wget https://github.com/SeisComP3/seiscomp3/archive/release/jakarta/$SC_VERSION.tar.gz \
    && tar xvzf $SC_VERSION.tar.gz \
    && mkdir -p $WORK_DIR/seiscomp3-release-jakarta-$SC_VERSION/build \
    && cd $WORK_DIR/seiscomp3-release-jakarta-$SC_VERSION/build \
    && cmake .. -DSC_TRUNK_DB_MYSQL=OFF -DSC_TRUNK_DB_POSTGRESQL=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    && make -j $(grep -c processor /proc/cpuinfo) \
    && make install \
    && apt-get purge -y --autoremove $buildDeps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* $WORK_DIR/*

RUN useradd -m -s /bin/bash sysop \
    && chown -R sysop:sysop $INSTALL_DIR

USER sysop

COPY global.cfg $INSTALL_DIR/etc/global.cfg

ENTRYPOINT ["seiscomp"]
