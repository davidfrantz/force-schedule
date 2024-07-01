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
DIR_LANDSAT_IMAGES=$("$BIN"/read-config.sh "DIR_LANDSAT_IMAGES" "$CONFIG")
FILE_LANDSAT_QUEUE=$("$BIN"/read-config.sh "FILE_LANDSAT_QUEUE" "$CONFIG")

# renamed queue
DIR_QUEUE=$(dirname "$FILE_LANDSAT_QUEUE")
BASE_QUEUE=$(basename "$FILE_LANDSAT_QUEUE")
TIME=$(date +"%Y%m%d%H%M%S")
FILE_MV_QUEUE="$DIR_QUEUE/.queue-$TIME-$BASE_QUEUE"

# is there a queue?
if [ ! -w "$FILE_LANDSAT_QUEUE" ]; then
  echo "No queue. Nothing to do. Going back to sleep."
  exit 0
fi

# is there an input data directory?
if [ ! -d "$DIR_LANDSAT_IMAGES" ]; then
  echo "No input data. But there is a queue. Inspect!"
  exit 1
fi


# process L1C to ARD
"$BIN"/ard-landsat.sh "$CONFIG" && \
#
# generate processing report
#"$BIN"/ard-report.sh "$CONFIG" && \
#
# move the queue
mv "$FILE_LANDSAT_QUEUE" "$FILE_MV_QUEUE" && \
#
# delete && remake L1C
rm -rf "$DIR_LANDSAT_IMAGES" && mkdir -p "$DIR_LANDSAT_IMAGES" 
#
# delete logfiles that are not OK -> redownload
#"$BIN"/ard-delete-logs.sh "$CONFIG"

exit 0
