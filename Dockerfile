FROM ubuntu:16.04

MAINTAINER Erik Garrison <erik.garrison@gmail.com>

# Make sure the en_US.UTF-8 locale exists, since we need it for tests
RUN locale-gen en_US en_US.UTF-8 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

RUN apt-get -qq update \
	&& apt-get -qq install -y \
		build-essential \
		pkg-config \
		sudo \
		git \
		make \
		libjansson-dev \
		libbz2-dev \
		libncurses5-dev \
		automake libtool jq samtools curl unzip redland-utils \
		librdf-dev cmake pkg-config wget bc gtk-doc-tools raptor2-utils rasqal-utils bison flex zlib1g-dev

# Copy the whole repo into /vg
RUN mkdir /vg
COPY . /vg
WORKDIR /vg

# Build
RUN make get-deps
RUN . ./source_me.sh && make -j$(nproc) && make test && make static

# Set up entrypoint
ENV PATH /vg/bin:$PATH
ENTRYPOINT ["/vg/bin/vg"]

