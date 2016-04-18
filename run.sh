#!/bin/bash

if docker info &> /dev/null ; then
	# If Docker available, use it for maximum sanity
    docker build -t deploy deploy
	docker run --rm -ti -v ~/.ssh:/root/.ssh \
	-e DO_TOKEN -e DO_SSH_KEY_FINGERPRINT \
	-e DO_NAME_PREFIX -e DO_REGION -e DO_SIZE -e DO_CHANNEL \
	-e DO_DOCKER_BUILD_REPO -e DO_DOCKER_RUN_OPTIONS \
	deploy
else
	# Without Docker, run directly
	# Hope that you have all dependencies the script needs already!
    deploy/deploy.sh
fi