#!/bin/bash

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
IMAGE=`./read-config.sh "IMAGE"`

# pull latest image
docker pull "$IMAGE"

exit 0

