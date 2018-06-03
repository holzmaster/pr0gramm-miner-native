FROM node:alpine

# install bash git cmake make gcc libc-dev libuv-dev
RUN apk add --no-cache bash git cmake make gcc g++ libc-dev libuv-dev tini \
	&& npm -g i forever \
	&& git clone --depth=1 https://github.com/xmrig/xmrig /xmrig \
	&& cd /xmrig \
	&& sed -i 's/DonateLevel = ./DonateLevel = 0/g' src/donate.h \
	&& cmake . -DWITH_HTTPD=OFF \
	&& make

# Add Node.js proxy server to container
ADD xm /xm
RUN cd /xm \
	&& npm i

ADD run.sh /xmrig
ENTRYPOINT ["/sbin/tini", "-g", "--", "/bin/ash", "/xmrig/run.sh"]
