#!/bin/bash

set -ex
apk add --no-cache --virtual .fetch-deps tar

apkArch="$(apk --print-arch)"
case "$apkArch" in
	x86_64) dockerArch='x86_64' ;;
	s390x)  dockerArch='s390x' ;;
	*)      echo >&2 "error: unsupported architecture ($apkArch)"; exit ;;
esac

if ! curl -fL -o docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then
	echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
	exit 1
fi

tar --extract \
	--file docker.tgz \
	--strip-components 1 \
	--directory /usr/local/bin/

rm docker.tgz;

apk del .fetch-deps;

dockerd -v
docker -v
