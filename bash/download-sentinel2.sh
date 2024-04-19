#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
IMAGE=$($BIN/read-config.sh "FORCE_IMAGE")
DIR_CSD_META=$($BIN/read-config.sh "DIR_CSD_META")
DIR_ARD_LOG=$($BIN/read-config.sh "DIR_ARD_LOG")
DIR_SENTINEL2_IMAGES=$($BIN/read-config.sh "DIR_SENTINEL2_IMAGES")
FILE_SENTINEL2_QUEUE=$($BIN/read-config.sh "FILE_SENTINEL2_QUEUE")
FILE_SENTINEL2_AOI=$($BIN/read-config.sh "FILE_SENTINEL2_AOI")
DATE_RANGE=$("$BIN"/read-config.sh "DATE_RANGE")

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
  -d $DATE_RANGE \
  -s S2A,S2B \
  -l $DIR_ARD_LOG \
  $DIR_CSD_META \
  $DIR_SENTINEL2_IMAGES \
  $FILE_SENTINEL2_QUEUE \
  $FILE_SENTINEL2_AOI

exit 0

