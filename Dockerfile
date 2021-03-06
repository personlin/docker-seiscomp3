FROM debian:stretch-slim

ENV WORK_DIR /opt/seiscomp3
ENV BUILD_DIR /tmp/seiscomp3
ENV INSTALL_DIR $WORK_DIR
ENV SEISCOMP3_CONFIG /data/seiscomp3
ENV LOCAL_CONFIG /data/.seiscomp3
ENV INIT_STATE /data/init
ENV ENTRYPOINT_INIT /docker-entrypoint-init.d
ENV PATH $PATH:$INSTALL_DIR/bin:$INSTALL_DIR/sbin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$INSTALL_DIR/lib
ENV PYTHONPATH $PYTHONPATH:$INSTALL_DIR/lib/python

WORKDIR $WORK_DIR

RUN set -ex \
    # Create some directories to PostgreSQL install
    && mkdir -p /usr/share/man/man1 \
    && mkdir -p /usr/share/man/man7 \
    && buildDeps=' \
        build-essential \
        ca-certificates \
        cmake \
        default-libmysqlclient-dev \
        gfortran \
        git \
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
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        python-dev \
        wget \
    ' \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        # SeisComP3 dependencies
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
        # Database dependencies
        libmariadbclient18 \
        postgresql-9.6 \
        sqlite3 \
        # Graphical interface dependencies
        libqtgui4 \
        libqt4-xml \
        # Misc
        cron \
        gosu \
        lsyncd \
        rsync \
        supervisor \
        $buildDeps \
    && git clone --depth 1 https://github.com/SeisComP3/seiscomp3.git $BUILD_DIR \
    && mkdir -p $BUILD_DIR/build \
    && cd $BUILD_DIR/build \
    && cmake \
        -DSC_GLOBAL_GUI=ON \
        -DSC_TRUNK_DB_MYSQL=ON \
        -DSC_TRUNK_DB_POSTGRESQL=ON \
        -DSC_TRUNK_DB_SQLITE3=ON \
        -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
        .. \
    && make -j $(grep -c processor /proc/cpuinfo) \
    && make install \
    && apt-get purge -y --autoremove $buildDeps \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        $BUILD_DIR

RUN set -ex \
    && useradd -m -s /bin/bash sysop \
    && chown -R sysop:sysop $INSTALL_DIR \
    && mkdir -p /data \
    && chown sysop:sysop /data

COPY ./docker-entrypoint.sh $WORD_DIR

USER sysop

RUN set -ex \
    && mkdir -p $SEISCOMP3_CONFIG \
    && mkdir -p $LOCAL_CONFIG \
    && mkdir -p $INIT_STATE \
    && mkdir -p $HOME/.seiscomp3

USER root

COPY ./lsyncd.conf $WORK_DIR
COPY ./supervisord.conf $WORK_DIR

ENTRYPOINT ["./docker-entrypoint.sh"]
