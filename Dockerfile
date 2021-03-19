# BUILDS TO: registry.gitlab.com/ewb-development/ewb-microservices/goss or jtbaird/goss
FROM jtbaird/alpine-node-mongo:latest

MAINTAINER "Jonathan Baird <jtbairdsr@me.com>"
LABEL maintainer "Jonathan Baird <jtbairdsr@me.com>" architecture="AMD64/x86_64"

# ------------------------------------------------- setup docker stuff -------------------------------------------------
RUN apk --update add --no-cache \
	autoconf \
	bash \
	ca-certificates \
	cargo \
	curl \
	gcc \
	git \
	jq \
	libc-dev \
	libffi-dev \
	make \
	openssh-client \
	openssl-dev \
	py-pip \
	python-dev \
	python3-dev \
	rust \
	sed


ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 20.10.5

COPY docker-entrypoint.sh /usr/local/bin/

# -------------------------------------------------- setup misc stuff --------------------------------------------------
COPY getversion.sh /usr/local/bin/getversion
ENV MONGOMS_SYSTEM_BINARY /usr/bin/mongod

RUN curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

COPY install.sh /usr/local/bin/
RUN install.sh && rm -rf /usr/local/bin/install.sh

# -------------------------------------------------- setup goss stuff --------------------------------------------------

# install goss
RUN curl -L https://github.com/aelsabbahy/goss/releases/download/v0.3.4/goss-linux-amd64 -o /usr/local/bin/goss && \
	chmod +rx /usr/local/bin/goss

# install dgoss
RUN curl -L https://raw.githubusercontent.com/aelsabbahy/goss/master/extras/dgoss/dgoss -o /usr/local/bin/dgoss && \
	chmod +rx /usr/local/bin/dgoss

ENV GOSS_PATH="/usr/local/bin/goss"
ENV GOSS_FILES_STRATEGY="cp"

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
