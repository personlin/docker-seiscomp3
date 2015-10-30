FROM debian:8.2

MAINTAINER Fabien Engels <fabien.engels@unistra.fr>

COPY environment /etc/environment
COPY CMakeLists.txt /tmp/CMakeLists.txt

WORKDIR /tmp

# Fix Debian  env
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV FAKE_CHROOT 1

RUN mv /usr/bin/ischroot /usr/bin/ischroot.original && \
    ln -s /bin/true /usr/bin/ischroot && \
    echo 'force-unsafe-io' | tee /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache && \
    apt-get update && apt-get dist-upgrade -y --no-install-recommends && \
    apt-get install -y \
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
        libmysqlclient18 \
        libmysqlclient-dev \
        libncurses5-dev \
        libpq5 \
        libpq-dev \
        libxml2-dev \
        python-dev \
        python \
        libpython2.7 \
        net-tools \
        wget && \
    wget https://github.com/SeisComP3/seiscomp3/archive/release/jakarta/2015.149.tar.gz && \
    tar xvzf 2015.149.tar.gz && \
    mkdir -p /tmp/seiscomp3-release-jakarta-2015.149/build && \
    mv -v /tmp/CMakeLists.txt /tmp/seiscomp3-release-jakarta-2015.149/src/trunk/apps/tools/scconfig/CMakeLists.txt && \
    cd /tmp/seiscomp3-release-jakarta-2015.149/build && \
    cmake .. -DSC_GLOBAL_GUI=OFF -DSC_TRUNK_DB_POSTGRESQL=ON -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make -j $(grep -c processor /proc/cpuinfo) && \
    make install && \
    apt-get purge -y $(dpkg -l | awk '/-dev/ { print $2 }' | xargs) wget && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
