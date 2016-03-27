#!
docker build -t deployment ${DO_DOCKER_BUILD_REPO}
docker run --restart=always ${DO_DOCKER_RUN_OPTIONS} deployment
