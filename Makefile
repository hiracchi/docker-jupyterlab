PACKAGE=hiracchi/jupyterlab
TAG=latest
CONTAINER_NAME=jupyterlab


.PHONY: all build

all: build

build:
	docker build -t "${PACKAGE}:${TAG}" .


start:
	@\$(eval USER_ID := $(shell id -u))
	@\$(eval GROUP_ID := $(shell id -g))
	@echo "start docker as ${USER_ID}:${GROUP_ID}"
	docker run -d \
		--rm \
		--name ${CONTAINER_NAME} \
		-u $(USER_ID):$(GROUP_ID) \
		--publish "8888:8888" \
		--volume "${PWD}/work:/work" \
		"${PACKAGE}:${TAG}"

stop:
	docker rm -f ${CONTAINER_NAME}


term:
	docker exec -it ${CONTAINER_NAME} /bin/bash


logs:
	docker logs -f ${CONTAINER_NAME}


debug:
	docker run -it \
		--name ${CONTAINER_NAME} \
		--publish "8888:8888" \
		--volume "${PWD}/work:/work" \
		"${PACKAGE}:${TAG}" \
		/bin/bash
