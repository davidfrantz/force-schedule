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
DIR_CSD_META=$("$BIN"/read-config.sh "DIR_CSD_META" "$CONFIG")

# update CSD metadata
docker run \
--rm \
-e FORCE_CREDENTIALS=/app/credentials \
-e BOTO_CONFIG=/app/credentials/.boto \
-v "$HOME:/app/credentials" \
-v /data:/data \
-v /force:/force \
-v /codede:/codede \
-v /mnt:/mnt \
-v "$HOME:$HOME" \
-w "$PWD" \
-u "$(id -u):$(id -g)" \
"$IMAGE" \
force-level1-csd -u "$DIR_CSD_META" -s s2a

exit 0
