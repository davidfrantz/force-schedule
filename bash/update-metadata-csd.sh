#!/bin/bash

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
IMAGE=`./read-config.sh "IMAGE"`
DIR_CSD_META=`./read-config.sh "DIR_CSD_META"`

# update CSD metadata
docker run \
--rm \
-e FORCE_CREDENTIALS=/app/credentials \
-e BOTO_CONFIG=/app/credentials/.boto \
-v $HOME:/app/credentials \
-v /data:/data \
-v /mnt:/mnt \
-v $HOME:$HOME \
-w $PWD \
-u $(id -u):$(id -g) \
$IMAGE \
force-level1-csd -u $DIR_CSD_META

exit 0

