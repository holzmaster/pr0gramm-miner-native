FROM debian:stretch
ENV DEBIAN_FRONTEND noninteractive

# install curl ca-certificates gnupg apt-transport-https
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends curl ca-certificates gnupg apt-transport-https

# Add nodesource for latest Node.js
RUN echo "deb https://deb.nodesource.com/node_8.x stretch main" >> /etc/apt/sources.list.d/nodejs.list
RUN curl --silent -o nodesource.gpg.key https://deb.nodesource.com/gpgkey/nodesource.gpg.key
RUN apt-key add nodesource.gpg.key
RUN rm nodesource.gpg.key

# install compiler, Node.js and dependencies
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends git-core build-essential cmake
RUN apt-get install -y --no-install-recommends nodejs libuv1-dev

# Node.js package to keep the proxy running in case of failure
RUN npm -g i forever

# clone and install Fusl's fork of xmrig
RUN git clone https://github.com/Fusl/xmrig /xmrig
WORKDIR /xmrig
RUN cmake .
RUN make

# Add Node.js proxy server to container
ADD xm /xm
WORKDIR /xm
RUN npm i

ADD run.sh /xmrig

WORKDIR /xmrig
ENTRYPOINT ["./run.sh"]
