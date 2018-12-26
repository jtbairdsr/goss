# BUILDS TO: registry.gitlab.com/ewb-development/ewb-microservices/goss or jtbaird/goss
FROM pitzcarraldo/alpine-node-mongo

# ------------------------------------------------- setup docker stuff -------------------------------------------------
RUN apk --update add --no-cache \
	autoconf \
	ca-certificates \
	bash \
	curl \
	git \
	py-pip \
	jq \
openssh-client

ENV DOCKER_CHANNEL edge
ENV DOCKER_VERSION 17.07.0-ce

COPY docker-entrypoint.sh /usr/local/bin/

COPY install.sh /usr/local/bin/
RUN install.sh && rm -rf /usr/local/bin/install.sh


ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]

# -------------------------------------------------- setup goss stuff --------------------------------------------------

# install goss
RUN curl -L https://github.com/aelsabbahy/goss/releases/download/v0.3.4/goss-linux-amd64 -o /usr/local/bin/goss && \
	chmod +rx /usr/local/bin/goss

# install dgoss
RUN curl -L https://raw.githubusercontent.com/aelsabbahy/goss/master/extras/dgoss/dgoss -o /usr/local/bin/dgoss && \
	chmod +rx /usr/local/bin/dgoss

ENV GOSS_PATH="/usr/local/bin/goss"
ENV GOSS_FILES_STRATEGY="cp"

# -------------------------------------------------- setup misc stuff --------------------------------------------------

RUN pip install jsmin
RUN npm install -g tslint eslint npm-run-all @angular/cli typescript @angular-devkit/build-angular

COPY getversion.sh /usr/local/bin/getversion
