#!/bin/bash

IMAGE=davidfrantz/force:dev

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
force-level1-csd \
  -c 0,70 \
  -s S2A,S2B \
  -l /data/Dagobah/dc/deu/log \
  /data/Dagobah/dc/input \
  /data/Dagobah/dc/input/sentinel2/images \
  /data/Dagobah/dc/input/sentinel2/queue.txt \
  /data/Dagobah/dc/deu/vector/MGRS_allowed-footprints.txt

exit 0

