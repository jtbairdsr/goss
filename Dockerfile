# BUILDS TO: registry.gitlab.com/ewb-development/ewb-microservices/goss or jtbaird/goss
FROM docker/compose:alpine-1.28.5

MAINTAINER "Jonathan Baird <jtbairdsr@me.com>"
LABEL maintainer "Jonathan Baird <jtbairdsr@me.com>" architecture="AMD64/x86_64"

ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 20.10.5
ENV GOSS_PATH="/usr/local/bin/goss"
ENV GOSS_FILES_STRATEGY="cp"
ENV MONGOMS_SYSTEM_BINARY /usr/bin/mongod
ENV MONGOMS_SYSTEM_BINARY /usr/bin/mongod

EXPOSE 27017 28017
VOLUME /data/db

# tool for getting the version of a project from the package.json
COPY getversion.sh /usr/local/bin/getversion

# installer for the latest version of docker
COPY install.sh /usr/local/bin/

COPY docker-entrypoint.sh /usr/local/bin/


# install general dependencies
RUN echo http://dl-4.alpinelinux.org/alpine/v3.9/main >> /etc/apk/repositories && \
	echo http://dl-4.alpinelinux.org/alpine/v3.9/community >> /etc/apk/repositories && \
	apk --update add --no-cache \
	autoconf \
	bash \
	ca-certificates \
	cargo \
	curl \
	git \
	jq \
	openssh-client \
	rust \
	sed \
	mongodb \
	yaml-cpp=0.6.2-r2 \
	nodejs \
	npm


# install latest docker
RUN install.sh && rm -rf /usr/local/bin/install.sh

# install goss
RUN curl -L https://github.com/aelsabbahy/goss/releases/download/v0.3.4/goss-linux-amd64 -o /usr/local/bin/goss && \
	chmod +rx /usr/local/bin/goss

# install dgoss
RUN curl -L https://raw.githubusercontent.com/aelsabbahy/goss/master/extras/dgoss/dgoss -o /usr/local/bin/dgoss && \
	chmod +rx /usr/local/bin/dgoss

# install latest docker context/compose commands (allows us to deploy to AWS via the ecs docker context)
RUN ln /usr/local/bin/docker* /usr/bin && \
	curl -L https://raw.githubusercontent.com/docker/compose-cli/main/scripts/install/install_linux.sh | sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
