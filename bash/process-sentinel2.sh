#!/bin/bash

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
DIR_SENTINEL2_IMAGES=`./read-config.sh "DIR_SENTINEL2_IMAGES"`
FILE_SENTINEL2_QUEUE=`./read-config.sh "FILE_SENTINEL2_QUEUE"`

# renamed queue
DIR_QUEUE=`dirname "$FILE_MV_QUEUE"`
BASE_QUEUE=`basename "$FILE_MV_QUEUE"`
TIME=$(date +"%Y%m%d%H%M%S")
FILE_MV_QUEUE="$DIR_QUEUE/.queue-$TIME-$BASE_QUEUE.txt"

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


# generate ARD parameter file
./ard-parameter.sh && \
# process L1C to ARD
./ard-sentinel2.sh && \
#
# generate processing report
./log-sentinel2.sh && \
#
# move the queue
mv "$FILE_SENTINEL2_QUEUE" "$FILE_MV_QUEUE" && \
#
# delete && remake L1C
rm -rf "$DIR_SENTINEL2_IMAGES" && mkdir "$DIR_SENTINEL2_IMAGES" && \
#
# delete logfiles that are not OK -> redownload



exit 0

