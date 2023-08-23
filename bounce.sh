#!/bin/bash

# Super lazy way to compose down and back up again

source ./set_envs

# If we need to add secrets to pass through to docker, they should go here
if [ ! -f ./set_secrets ]; then
    echo "Secrets not found, aborting!"
    exit 1
fi
source ./set_secrets

./compose.sh $1 down && ./compose.sh $1 up -d
