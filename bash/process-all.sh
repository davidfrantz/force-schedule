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


# process Sentinel-2
"$BIN"/process-sentinel2.sh "$CONFIG" && \
#
# process Landsat
"$BIN"/process-landsat.sh "$CONFIG" && \
#
# generate processing report
"$BIN"/ard-report.sh "$CONFIG" && \
#
# delete logfiles that are not OK -> redownload
"$BIN"/ard-delete-logs.sh "$CONFIG"

exit 0
