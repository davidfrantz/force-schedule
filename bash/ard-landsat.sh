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
FILE_ARD_LANDSAT_OLI_PARAM=$("$BIN"/read-config.sh "FILE_ARD_LANDSAT_OLI_PARAM" "$CONFIG")
FILE_ARD_LANDSAT_TM_PARAM=$("$BIN"/read-config.sh "FILE_ARD_LANDSAT_TM_PARAM" "$CONFIG")
FILE_LANDSAT_QUEUE=$("$BIN"/read-config.sh "FILE_LANDSAT_QUEUE" "$CONFIG")

# renamed queue
FILE_LANDSAT_QUEUE_TM=${FILE_LANDSAT_QUEUE%%.*}"_TM.txt"
FILE_LANDSAT_QUEUE_OLI=${FILE_LANDSAT_QUEUE%%.*}"_OLI.txt"

# split queue
set +e
grep "LE07_\|LT05_\|LT04_"  "$FILE_LANDSAT_QUEUE" > "$FILE_LANDSAT_QUEUE_TM"
grep "LC08_\|LC09_"  "$FILE_LANDSAT_QUEUE" > "$FILE_LANDSAT_QUEUE_OLI"
set -e

# count queue
NUM_TM=$(echo "$FILE_LANDSAT_QUEUE_TM" | wc -w)
NUM_OLI=$(echo "$FILE_LANDSAT_QUEUE_OLI" | wc -w)

# preprocess Landsat TM/ETM L1TP to L2 ARD
if [ "$NUM_TM" -gt 0 ]; then
docker run \
  --rm \
  -e FORCE_CREDENTIALS=/app/credentials \
  -e BOTO_CONFIG=/app/credentials/.boto \
  -v "$HOME:/app/credentials" \
  -v /data:/data \
  -v /mnt:/mnt \
  -v "$HOME:$HOME" \
  -w "$PWD" \
  -u "$(id -u):$(id -g)" \
  "$IMAGE" \
  force-level2 \
    "$FILE_ARD_LANDSAT_TM_PARAM"
fi

# preprocess Landsat OLI L1TP to L2 ARD
if [ "$NUM_OLI" -gt 0 ]; then
  docker run \
  --rm \
  -e FORCE_CREDENTIALS=/app/credentials \
  -e BOTO_CONFIG=/app/credentials/.boto \
  -v "$HOME:/app/credentials" \
  -v /data:/data \
  -v /mnt:/mnt \
  -v "$HOME:$HOME" \
  -w "$PWD" \
  -u "$(id -u):$(id -g)" \
  "$IMAGE" \
  force-level2 \
    "$FILE_ARD_LANDSAT_OLI_PARAM"
fi

rm "$FILE_LANDSAT_QUEUE_TM"
rm "$FILE_LANDSAT_QUEUE_OLI"

exit 0
