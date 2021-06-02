#!/bin/bash

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
IMAGE=`./read-config.sh "IMAGE"`
DIR_CSD_META=`./read-config.sh "DIR_CSD_META"`
DIR_ARD_LOG=`./read-config.sh "DIR_ARD_LOG"`
DIR_SENTINEL2_IMAGES=`./read-config.sh "DIR_SENTINEL2_IMAGES"`
FILE_SENTINEL2_QUEUE=`./read-config.sh "FILE_SENTINEL2_QUEUE"`
FILE_SENTINEL2_AOI=`./read-config.sh "FILE_SENTINEL2_AOI"`

# download Sentinel-2 L1C images that weren't processed to ARD yet
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
force-level1-csd \
  -c 0,70 \
  -s S2A,S2B \
  -l $DIR_ARD_LOG \
  $DIR_CSD_META \
  $DIR_SENTINEL2_IMAGES \
  $FILE_SENTINEL2_QUEUE \
  $FILE_SENTINEL2_AOI

exit 0

