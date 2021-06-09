#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e

# update metadata catalogue
$BIN/update-metadata-csd.sh && \
#
# download data
$BIN/download-sentinel2.sh

exit 0

