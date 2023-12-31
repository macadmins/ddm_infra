#!/bin/bash
# This is a simple script to run docker-compose on the target project with the
# correct set of override files. Set CLOUD_ENV to the override file you want to
# use, and the first argument to this program is the project to run in.
# Everything else is passed to docker-compose.

# Source our env variables
source ./set_envs

# If we need to add secrets to pass through to docker, they should go here
if [ ! -f ./set_secrets ]; then
    echo "Secrets not found, aborting!"
    exit 1
fi
source ./set_secrets

project="$1"
shift
compose_args="-f $project/docker-compose.yml"
if [ -f $project/docker-compose.$CLOUD_ENV.yml ]; then
  compose_args="$compose_args -f $project/docker-compose.$CLOUD_ENV.yml"
fi
# Warning: docker-compose can't handle DOCKER_HOST=ssh://<profile>
exec docker compose $compose_args "$@"
