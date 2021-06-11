#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
DIR_SENTINEL2_IMAGES=`$BIN/read-config.sh "DIR_SENTINEL2_IMAGES"`
FILE_SENTINEL2_QUEUE=`$BIN/read-config.sh "FILE_SENTINEL2_QUEUE"`

# renamed queue
DIR_QUEUE=`dirname "$FILE_SENTINEL2_QUEUE"`
BASE_QUEUE=`basename "$FILE_SENTINEL2_QUEUE"`
TIME=$(date +"%Y%m%d%H%M%S")
FILE_MV_QUEUE="$DIR_QUEUE/.queue-$TIME-$BASE_QUEUE"

# is there a queue?
if [ ! -w "$FILE_SENTINEL2_QUEUE" ]; then
  echo "No queue. Nothing to do. Going back to sleep."
  exit 0
fi

# is there an input data directory?
if [ ! -d "$DIR_SENTINEL2_IMAGES" ]; then
  echo "No input data. But there is a queue. Inspect!"
  exit 1
fi


# process L1C to ARD
$BIN/ard-sentinel2.sh && \
#
# generate processing report
$BIN/ard-report.sh && \
#
# move the queue
mv "$FILE_SENTINEL2_QUEUE" "$FILE_MV_QUEUE" && \
#
# delete && remake L1C
rm -rf "$DIR_SENTINEL2_IMAGES" && mkdir "$DIR_SENTINEL2_IMAGES" #&& \
#
# delete logfiles that are not OK -> redownload
# todo

exit 0
