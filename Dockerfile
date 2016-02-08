FROM alpine:3.3
# apt-get install -y \
#     festival \
#     net-tools \

MAINTAINER Fabien Engels <fabien.engels@unistra.fr>

COPY environment /etc/environment

WORKDIR /tmp

RUN apk update && apk upgrade && \
    apk add \
	bash \
	boost-dev \
	boost-filesystem \
	boost-iostreams \
	boost-program_options \
	boost-regex \
	boost-signals \
	boost-system \
	boost-thread \
	flex \
	flex-dev \
	git \
	libgfortran \
	libtirpc-dev \
	libxml2-dev \
	mariadb-dev \
	ncurses-dev \
	postgresql-dev \
	python-dev \
    	build-base \
    	cmake \
    	gcc \
        gfortran \
	wget && \
    wget https://github.com/SeisComP3/seiscomp3/archive/release/jakarta/2015.149.tar.gz && \
    tar xvzf 2015.149.tar.gz && \
    mkdir -p /tmp/seiscomp3-release-jakarta-2015.149/build

WORKDIR /tmp/seiscomp3-release-jakarta-2015.149/build

COPY CMakeLists.txt.ipgp /tmp/seiscomp3-release-jakarta-2015.149/src/ipgp/apps/CMakeLists.txt
COPY CMakeLists.txt.scconfig /tmp/seiscomp3-release-jakarta-2015.149/src/trunk/apps/tools/scconfig/CMakeLists.txt

RUN apk add mariadb-dev

COPY binarchive.cpp /tmp/seiscomp3-release-jakarta-2015.149/src/trunk/libs/seiscomp3/io/archive/binarchive.cpp
COPY diff.cpp /tmp/seiscomp3-release-jakarta-2015.149/src/trunk/libs/seiscomp3/datamodel/diff.cpp
COPY utils.cpp /tmp/seiscomp3-release-jakarta-2015.149/src/trunk/libs/seiscomp3/datamodel/utils.cpp
COPY sysdep1.h /tmp/seiscomp3-release-jakarta-2015.149/src/trunk/libs/3rd-party/locsat/lib/libf2c/sysdep1.h
RUN mv /usr/include/tirpc/* /usr/include/

RUN rm -rf /tmp/seiscomp3-release-jakarta-2015.149/src/ipgp/apps/ew2sc3

RUN cmake .. -DSC_GLOBAL_GUI=OFF -DSC_TRUNK_DB_POSTGRESQL=ON -DCMAKE_INSTALL_PREFIX=/
#     make -j $(grep -c processor /proc/cpuinfo) && \
#     make install


    # apt-get purge -y $(dpkg -l | awk '/-dev/ { print $2 }' | xargs) wget && \
    # apt-get autoremove -y --purge && \
    # apt-get clean && \
    # rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY global.cfg /etc/global.cfg
