#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e

# ingest Sentinel-2
$BIN/ingest-sentinel2.sh && \
#
# ingest Landsat
$BIN/ingest-landsat.sh

exit 0

