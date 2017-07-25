FROM debian:stretch
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends curl ca-certificates gnupg

RUN echo "deb http://deb.nodesource.com/node_8.x stretch main" >> /etc/apt/sources.list.d/nodejs.list
RUN curl --silent -o nodesource.gpg.key https://deb.nodesource.com/gpgkey/nodesource.gpg.key
RUN apt-key add nodesource.gpg.key
RUN rm nodesource.gpg.key

# RUN curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends git-core build-essential cmake
RUN apt-get install -y --no-install-recommends nodejs libuv1-dev

RUN npm -g i forever

RUN git clone https://github.com/Fusl/xmrig /xmrig
WORKDIR /xmrig
RUN cmake .
RUN make

ADD xm /xm
WORKDIR /xm
RUN npm i

ADD run.sh /xmrig

ENTRYPOINT ["./run.sh"]
