#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
IMAGE=`$BIN/read-config.sh "FORCE_IMAGE"`
DIR_WVP=`$BIN/read-config.sh "DIR_WVP"`

# date
if [ $# -eq 0 ]; then
  YEAR=$(date --date yesterday +"%Y")
  MONTH=$(date --date yesterday +"%m")
  DAY=$(date --date yesterday +"%d")
  DAILY=false
  CLIMATOLOGY=true
elif [ $# -eq 3 ]; then
  YEAR=$1
  MONTH=$2
  DAY=$3
  DAILY=true
  CLIMATOLOGY=false
else
  echo "wrong number of args"
  exit 1
fi

echo $YEAR $MONTH $DAY

TEMPDIR="$DIR_WVP/hdf-$YEAR-$MONTH-$DAY"

mkdir -p $TEMPDIR

# download and process WVDB
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
force-lut-modis \
  -d $YEAR$MONTH$DAY,$YEAR$MONTH$DAY \
  -t $DAILY \
  -c $CLIMATOLOGY \
  $DIR_WVP/wvdb/wrs-2-land.coo \
  $DIR_WVP/wvdb \
  $DIR_WVP/geo \
  $TEMPDIR

rm -r $TEMPDIR

exit 0
