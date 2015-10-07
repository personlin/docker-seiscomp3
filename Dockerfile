FROM ubuntu:14.04

MAINTAINER Fabien Engels <fabien.engels@unistra.fr>

# Fix Ubuntu env
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV FAKE_CHROOT 1
RUN mv /usr/bin/ischroot /usr/bin/ischroot.original && \
    ln -s /bin/true /usr/bin/ischroot && \
    echo 'force-unsafe-io' | tee /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache && \
    apt-get update && apt-get dist-upgrade -y --no-install-recommends

# Set locales
COPY environment /etc/environment

WORKDIR /tmp
RUN apt-get install -y \
        build-essential \
        cmake \
        festival \
        flex \
	gfortran \
	libboost-filesystem-dev \
	libboost-iostreams-dev \
	libboost-program-options-dev \
	libboost-regex-dev \
	libboost-signals-dev \
	libboost-system-dev \
	libboost-thread-dev \
        libboost-dev \
        libmysqlclient-dev \
        libncurses5-dev \
        libpq-dev \
	libqt4-dev \
        libxml2-dev \
        python-dev \
        wget && \
    wget https://github.com/SeisComP3/seiscomp3/archive/release/jakarta/2015.149.tar.gz && \
    tar xvzf 2015.149.tar.gz && \
    mkdir -p /tmp/seiscomp3-release-jakarta-2015.149/build

WORKDIR /tmp/seiscomp3-release-jakarta-2015.149/build

RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local && make -j $(grep processor /proc/cpuinfo | wc -l) && make install

# Clean up APT when done.
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get purge -y $(dpkg -l | awk '/-dev/ { print $2 }' | xargs) wget
