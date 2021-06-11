#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
IMAGE=`$BIN/read-config.sh "LANDSATLINKS_IMAGE"`
DIR_ARD_LOG=`$BIN/read-config.sh "DIR_ARD_LOG"`
DIR_LANDSAT_LINKS=`$BIN/read-config.sh "DIR_LANDSAT_LINKS"`
FILE_LANDSAT_AOI=`$BIN/read-config.sh "FILE_LANDSAT_AOI"`

for s in TM ETM OLI; do

  # retrieve landsat links that weren't processed to ARD yet
  docker run \
  --rm \
  -v /data:/data \
  -v /mnt:/mnt \
  -v $HOME:$HOME \
  -w $PWD \
  -u $(id -u):$(id -g) \
  $IMAGE \
  landsatlinks \
      -c 0,70 \
      -l L1TP \
      -t T1 \
      -s $HOME/.usgs.txt \
      -f $DIR_ARD_LOG \
      -o $DIR_LANDSAT_LINKS/$s-links.txt \
      $DIR_LANDSAT_LINKS/$s-results.txt \
      $s \
      $FILE_LANDSAT_AOI
      #-r \

  rm $DIR_LANDSAT_LINKS/$s-results.txt

done

exit 0
