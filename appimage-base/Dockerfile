FROM docker.io/library/ubuntu:bionic as depbuilder
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update
RUN apt-get -y install curl
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test

RUN curl -o /tmp/cmake.sh https://cmake.org/files/v3.19/cmake-3.19.1-Linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh /tmp/cmake.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

RUN apt update
RUN apt-get install -y git
RUN apt-get install -y make gcc-10 g++-10

RUN apt-get install -y zlib1g-dev libglu-dev libcairo2-dev libpango1.0-dev libgtk2.0-dev
RUN apt-get install -y libgl1-mesa-dev
RUN apt-get install -y apt-file
RUN apt-file update
RUN apt-get install -y $(apt-file search --regex  /cairo.h$ | awk -F: '{print $1}')

ENV TZ="Europe/London"
COPY slic3r/deps /tmp/deps
RUN mkdir /opt/dependencies
WORKDIR /opt/dependencies
RUN cmake /tmp/deps
RUN make -j4

RUN apt-get install -y libdbus-1-dev

WORKDIR /src/slic3r

FROM docker.io/library/ubuntu:bionic
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test

# CircleCI Primary container image required packages
RUN apt-get install -y git bash ssh tar gzip ca-certificates
RUN apt-get install -y make gcc-10 g++-10
RUN apt-get install -y zlib1g-dev \
                       libglu-dev \
                       libcairo2-dev \
                       libpango1.0-dev \
                       libgtk2.0-dev \
                       libgl1-mesa-dev

COPY --from=depbuilder /opt/dependencies /opt/dependencies
COPY --from=depbuilder /opt/cmake /opt/cmake
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
COPY build-all.sh /opt/build-all.sh
RUN chmod +x /opt/build-all.sh
WORKDIR /build
