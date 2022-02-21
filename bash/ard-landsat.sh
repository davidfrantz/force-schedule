#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
IMAGE=`$BIN/read-config.sh "FORCE_IMAGE"`
FILE_ARD_LANDSAT_OLI_PARAM=`$BIN/read-config.sh "FILE_ARD_LANDSAT_OLI_PARAM"`
FILE_ARD_LANDSAT_TM_PARAM=`$BIN/read-config.sh "FILE_ARD_LANDSAT_TM_PARAM"`
FILE_LANDSAT_QUEUE=`$BIN/read-config.sh "FILE_LANDSAT_QUEUE"`

# renamed queue TM
FILE_LANDSAT_QUEUE_TM=${FILE_LANDSAT_QUEUE%%.*}"_TM.txt"

if ! grep -q "LE07_\|LT05_\|LT04_" $FILE_LANDSAT_QUEUE; then
    echo "No L7, L5 or L4 files in queue."
else
    grep "LE07_\|LT05_\|LT04_"  $FILE_LANDSAT_QUEUE > $FILE_LANDSAT_QUEUE_TM
fi


# renamed queue OLI
FILE_LANDSAT_QUEUE_OLI=${FILE_LANDSAT_QUEUE%%.*}"_OLI.txt"
if ! grep -q "LC08_\|LC09_" $FILE_LANDSAT_QUEUE; then
    echo "No OLI or OLI2 files in queue."
else
    grep "LC08_\|LC09_"  $FILE_LANDSAT_QUEUE > $FILE_LANDSAT_QUEUE_OLI
fi


# preprocess Landsat TM/ETM L1TP to L2 ARD
if [ -f $FILE_LANDSAT_QUEUE_TM ]; then
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
    $FILE_ARD_LANDSAT_TM_PARAM
fi



# preprocess Landsat OLI L1TP to L2 ARD
if [ -f $FILE_LANDSAT_QUEUE_OLI ]; then
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
    $FILE_ARD_LANDSAT_OLI_PARAM
fi

if [ -f $FILE_LANDSAT_QUEUE_TM ]; then
	rm $FILE_LANDSAT_QUEUE_TM
fi


if [ -f $FILE_LANDSAT_QUEUE_OLI ]; then
	rm $FILE_LANDSAT_QUEUE_OLI
fi

exit 0
