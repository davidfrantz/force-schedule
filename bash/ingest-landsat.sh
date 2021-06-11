#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e


# retrieve links
$BIN/retrieve-landsat-links.sh && \
#
# download the data
$BIN/download-landsat-links.sh && \
#
# extract the data, build queue
$BIN/extract-landsat-links.sh 

exit 0
