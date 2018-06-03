FROM python:2.7.9

MAINTAINER Wan-Ping Lee <wan-ping.lee@jax.org>

# Packaged dependencies
RUN apt-get update && apt-get install -y \
	git \
	libxpm-dev \
	libxft-dev \
	libbz2-dev \
	libroot-core-dev \
	vim \
	perl \
	python2.7-dev \
	python-numpy \
	openjdk-7-* \
	gawk \
	libgd-gd2-perl \
	liblzo2-dev \
	zlib1g-dev

# Make a folder for tools
RUN cd / && mkdir -p tools && cd /tools

# Install cmake 3.10
RUN cd /tools \
	&& wget https://cmake.org/files/v3.10/cmake-3.10.0-rc5.tar.gz \
	&& tar -zxvf cmake-3.10.0-rc5.tar.gz \
	&& cd cmake-3.10.0-rc5 \
	&& ./bootstrap \
	&& make -j8 \
	&& make install

# Install ROOT
RUN cd /tools \
	&& git clone https://github.com/root-project/root.git \
	&& cd root/build \
	&& cmake .. \
	&& cmake --build . -- -j8 \
	&& cmake --build . --target install -- -j8

# Set the ROOT path
ENV ROOTSYS=/tools/root/build
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib

RUN pip install --upgrade pip
RUN pip install numpy
RUN pip install HTSeq \
	scipy \
	subprocess32 \
	bx-python \
	CrossMap \
	mygene \
	biopython


# Install R-3.3.3
RUN cd /tools \
        && git clone --recursive https://github.com/TheJacksonLaboratory/SVE.git \
        && cd SVE \
        && make R-install

# Copy R to /usr/bin
RUN ln -s -t /usr/bin/ /tools/SVE/src/R-package/R-3.3.3/bin/R
RUN ln -s -t /usr/bin/ /tools/SVE/src/R-package/R-3.3.3/bin/Rscript


# Install SVE
RUN cd /tools/SVE \
        && make

# Upgrade bx-python; otherwise CrossMap won't work
# Build FusorSV
RUN cd /tools/SVE/scripts/FusorSV \
	&& wget https://pypi.python.org/packages/55/db/fa76af59a03c88ad80494fc0df2948740bbd58cd3b3ed5c31319624687cc/bx-python-0.7.3.tar.gz \
	&& pip install bx-python-0.7.3.tar.gz --upgrade \
	&& python setup.py build_ext --inplace \
	&& tar -zxvf data.tar.gz

# Define default command.
CMD ["/tools/SVE/bin/sve"]
