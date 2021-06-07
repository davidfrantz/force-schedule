#!/bin/bash

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
IMAGE=`./read-config.sh "IMAGE"`
FILE_ARD_SENTINEL2_PARAM=`./read-config.sh "FILE_ARD_SENTINEL2_PARAM"`

# preprocess the S2 L1C to L2 ARD
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
force-level2 \
  $FILE_ARD_SENTINEL2_PARAM

exit 0
