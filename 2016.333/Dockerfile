FROM debian:jessie

MAINTAINER Fabien Engels <fabien.engels@unistra.fr>

ENV SC_VERSION 2016.333
ENV WORK_DIR /tmp
ENV INSTALL_DIR /opt/seiscomp3
ENV PATH $PATH:$INSTALL_DIR/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$INSTALL_DIR/lib
ENV PYTHONPATH $PYTHONPATH:$INSTALL_DIR/lib/python

# Fix Debian  env
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV FAKE_CHROOT 1

COPY environment /etc/environment

WORKDIR $WORK_DIR

RUN echo 'force-unsafe-io' | tee /etc/dpkg/dpkg.cfg.d/02apt-speedup \
    && echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache \
    && apt-get update \
    && apt-get dist-upgrade -y --no-install-recommends \
    && apt-get install -y \
        build-essential \
        cmake \
        festival \
        flex \
        gfortran \
        libboost-dev \
        libboost-filesystem1.55.0 \
        libboost-filesystem-dev \
        libboost-iostreams1.55.0 \
        libboost-iostreams-dev \
        libboost-program-options1.55.0 \
        libboost-program-options-dev \
        libboost-regex1.55.0 \
        libboost-regex-dev \
        libboost-signals1.55.0 \
        libboost-signals-dev \
        libboost-system1.55.0 \
        libboost-system-dev \
        libboost-thread1.55.0 \
        libboost-thread-dev \
        libgfortran3 \
        libncurses5-dev \
        libpq5 \
        libpq-dev \
        libpython2.7 \
        libxml2 \
        libxml2-dev \
        python \
        python-dev \
	    python-twisted \
        net-tools \
        wget \
    && wget https://github.com/SeisComP3/seiscomp3/archive/release/jakarta/$SC_VERSION.tar.gz \
    && tar xvzf $SC_VERSION.tar.gz \
    && mkdir -p $WORK_DIR/seiscomp3-release-jakarta-$SC_VERSION/build \
    && cd $WORK_DIR/seiscomp3-release-jakarta-$SC_VERSION/build \
    && cmake .. -DSC_GLOBAL_GUI=OFF -DSC_TRUNK_DB_MYSQL=OFF -DSC_TRUNK_DB_POSTGRESQL=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    && make -j $(grep -c processor /proc/cpuinfo) \
    && make install \
    && apt-get purge -y \
        $(dpkg -l | awk '/-dev/ { print $2 }' | xargs) \
        build-essential \
        cmake \
        wget \
    && apt-get autoremove -y --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* $WORK_DIR/*

RUN useradd -m -s /bin/bash sysop \
    && chown -R sysop:sysop $INSTALL_DIR

USER sysop

COPY global.cfg $INSTALL_DIR/etc/global.cfg

ENTRYPOINT ["seiscomp"]
