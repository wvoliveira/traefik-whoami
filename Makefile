.PHONY: all run build restart

NAME ?= betraefik
VERSION ?= 0.0.1
TRAEFIK_IMAGE_VERSION ?= 2.0.5

all: build push

restart:
	docker restart "${NAME}"
	docker logs -f "${NAME}"

run:
	docker run --rm --name "${NAME}" -p 8080:8080 -p 80:80 -p 443:443 -p 8082:8082 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v "${PWD}/conf":/etc/traefik \
	traefik:${TRAEFIK_IMAGE_VERSION}

build:
	docker build -t ${NAME}:${VERSION} .

push:
	docker push ${NAME}:${VERSION}

run_whoami:
	docker run --rm --name whoami \
	-l traefik.enable="true" \
	-l traefik.port="80" \
	containous/whoami:v1.4.0
