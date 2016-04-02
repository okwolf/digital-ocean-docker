#!/bin/bash

if docker info &> /dev/null ; then
    docker build -t deploy deploy
	docker run --rm -ti -v ~/.ssh:/root/.ssh \
	-e DO_TOKEN -e DO_SSH_KEY_FINGERPRINT -e DO_DOCKER_BUILD_REPO \
	-e DO_DOCKER_RUN_OPTIONS deploy
else
    deploy/deploy.sh
fi