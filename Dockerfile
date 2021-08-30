FROM ubuntu:20.04 AS release
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y

RUN apt install -y openssh-client curl git
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh

# Install Crystal
RUN curl -fsSL https://crystal-lang.org/install.sh | bash
RUN apt install -y crystal libz-dev libgmp-dev libyaml-dev libxml2-dev libssl-dev \
  autoconf autotools-dev automake libtool build-essential

# Remove the static libgc.a
RUN rm /usr/lib/crystal/lib/libgc.a
# Install bdw-gc for fix by commit 9245e1154d271b9fd69c5c6de75c6ac37f3badc4
RUN git clone https://github.com/ivmai/bdwgc.git && \
  cd bdwgc && \
  git checkout 9245e1154d271b9fd69c5c6de75c6ac37f3badc4 && \
  git clone git://github.com/ivmai/libatomic_ops.git && \
  ./autogen.sh && \
  ./configure --enable-large-config --prefix=/usr && \
  make -j CFLAGS=-DNO_GETCONTEXT && \
  make install

WORKDIR /opt

# FROM release AS tester

ENV CRYSTAL_LOAD_DWARF=1

RUN apt-get update -qq --fix-missing
RUN apt-get install -y --no-install-recommends apt-utils ruby-public-suffix \
  python3-pymysql python3-psycopg2 python3-pymssql python3-pymongo python3-sqlalchemy \
  python3 locales curl build-essential git zlib1g-dev


# Configure Python3 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

# Set Locale
RUN locale-gen en_US.UTF-8

# Install SQLMAP for needed integration
RUN git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap
WORKDIR /opt/sqlmap
RUN git pull --tags && git checkout 1.4.8
RUN ln -s /opt/sqlmap/sqlmap.py /usr/bin/sqlmap

# Install NodeJS 12.
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash && \
 apt-get install -y nodejs

# Install RetireJS for JavaScript opensource issues
RUN npm install -g retire@2.2.1

# Install Wappalyzer
ENV PUPPETEER_SKIP_DOWNLOAD=1
RUN npm install -g wappalyzer@5.9.31

WORKDIR /
# Build and install sslscan
RUN git clone -b 2.0.8 --depth 1 https://github.com/rbsec/sslscan.git && \
	cd sslscan && \
	make clean && \
	make static && \
	make install && \
	cd / && \
	rm -rf /sslscan

RUN apt-get update && apt-get install -y \
  ca-certificates \
  binutils-dev \
  libcurl4-openssl-dev \
  zlib1g-dev \
  libdw-dev \
  libiberty-dev \
  cmake

# Install kcov from source.
RUN git clone https://github.com/SimonKagstrom/kcov.git \
  && cd ./kcov \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make \
  && make install

RUN apt-get update -qq --fix-missing
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ~/developer/neuralegion

CMD ["/bin/bash"]