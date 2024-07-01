#!/bin/bash

PROG=$(basename "$0")
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "$PROG: $(date +"%Y-%m-%d %H:%M:%S")"
echo "-----------------------------------------------------------"

# make sure script exits if any process exits unsuccessfully
set -e


# get config file
if [ $# -lt 1 ] ; then 
  echo "configuration file is missing" 1>&2;
  exit 1
fi
CONFIG=$1


# parse config file
IMAGE=$("$BIN"/read-config.sh "FORCE_IMAGE" "$CONFIG")
DIR_WVP=$("$BIN"/read-config.sh "DIR_WVP" "$CONFIG")

# date
if [ $# -eq 1 ]; then
  YEAR=$(date --date yesterday +"%Y")
  MONTH=$(date --date yesterday +"%m")
  DAY=$(date --date yesterday +"%d")
  DAILY=false
  CLIMATOLOGY=true
elif [ $# -eq 4 ]; then
  YEAR=$2
  MONTH=$3
  DAY=$4
  DAILY=true
  CLIMATOLOGY=false
else
  echo "wrong number of args"
  exit 1
fi

echo "$YEAR $MONTH $DAY"

TEMPDIR="$DIR_WVP/hdf-$YEAR-$MONTH-$DAY"

mkdir -p "$TEMPDIR"

# download and process WVDB
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
force-lut-modis \
  -d "$YEAR$MONTH$DAY,$YEAR$MONTH$DAY" \
  -t "$DAILY" \
  -c "$CLIMATOLOGY" \
  "$DIR_WVP/wvdb/wrs-2-land.coo" \
  "$DIR_WVP/wvdb" \
  "$DIR_WVP/geo" \
  "$TEMPDIR"

rm -r "$TEMPDIR"

exit 0
