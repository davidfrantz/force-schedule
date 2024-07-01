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
IMAGE1=$("$BIN"/read-config.sh "FORCE_IMAGE" "$CONFIG")
IMAGE2=$("$BIN"/read-config.sh "LANDSATLINKS_IMAGE" "$CONFIG")

# pull latest image
docker pull "$IMAGE1"
docker pull "$IMAGE2"

exit 0
