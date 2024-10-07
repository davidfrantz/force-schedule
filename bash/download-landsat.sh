#!/bin/bash

PROG=$(basename "$0")
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "$PROG: $(date +"%Y-%m-%d %H:%M:%S")"
echo "-----------------------------------------------------------"

# make sure script exits if any process exits unsuccessfully
set -e


# get config file
if [ $# -ne 1 ] ; then 
  echo "configuration file is missing" 1>&2;
  exit 1
fi
CONFIG=$1


# parse config file
IMAGE=$("$BIN"/read-config.sh "FORCE_IMAGE" "$CONFIG")
DIR_ARD_LOG=$("$BIN"/read-config.sh "DIR_ARD_LOG" "$CONFIG")
DIR_LANDSAT_IMAGES=$("$BIN"/read-config.sh "DIR_LANDSAT_IMAGES" "$CONFIG")
FILE_LANDSAT_AOI=$("$BIN"/read-config.sh "FILE_LANDSAT_AOI" "$CONFIG")
DATE_RANGE=$("$BIN"/read-config.sh "DATE_RANGE" "$CONFIG")

# query USGS M2M API for Landsat product bundles and download what hasn't been processed to ARD yet
docker run \
  --rm \
  -v "$HOME:/app/credentials" \
  -v /data:/data \
  -v /force:/force \
  -v /mnt:/mnt \
  -v "$HOME:$HOME" \
  -v /codede:/codede \
  -w "$PWD" \
  -u "$(id -u):$(id -g)" \
  "$IMAGE" \
  force-level1-landsat search \
    "$FILE_LANDSAT_AOI" \
    "$DIR_LANDSAT_IMAGES" \
    --cloudcover 0,70 \
     --daterange "$DATE_RANGE" \
    --level L1TP \
    --tier T1 \
    --forcelogs "$DIR_ARD_LOG" \
    --secret "$HOME/.usgs.txt" \
    --download

exit 0
