#!/bin/bash

# input
DIR_INPUT=/data/Dagobah/dc/input/sentinel2
PARAM=/data/Dagobah/dc/deu/param/ard/germany-operational-sentinel2.prm

# current time
TIME=$(date +"%Y%m%d%H%M%S")

# renamed queue
INP_QUEUE="$DIR_INPUT/queue.txt"
OUT_QUEUE="$DIR_INPUT/.queue_$TIME.txt"

# input L1C directory
INP_L1C="$DIR_INPUT/images"

# is there a queue?
if [ ! -w "$INP_QUEUE" ]; then
  echo "No queue. Nothing to do. Going back to sleep."
  exit 0
fi

# is there input data?
if [ ! -d "$INP_L1C" ]; then
  echo "No input data. But there is a queue. Inspect!"
  exit 1
fi


# process L1C to ARD
bash /data/Dagobah/dc/force-schedule/ard-sentinel2.sh && \
#
# generate processing report
bash /data/Dagobah/dc/force-schedule/log-sentinel2.sh && \
#
# move the queue
mv "$INP_QUEUE" "$OUT_QUEUE" && \
#
# delete && remake L1C
rm -rf "$INP_L1C" && mkdir "$INP_L1C"


exit 0

