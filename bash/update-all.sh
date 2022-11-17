#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
IMAGE1=$($BIN/read-config.sh "FORCE_IMAGE")
IMAGE2=$($BIN/read-config.sh "LANDSATLINKS_IMAGE")

# pull latest image
docker pull "$IMAGE1"
docker pull "$IMAGE2"

exit 0

