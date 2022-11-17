#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e

# process Sentinel-2
$BIN/process-sentinel2.sh && \
#
# process Landsat
$BIN/process-landsat.sh && \
#
# generate processing report
$BIN/ard-report.sh && \
#
# delete logfiles that are not OK -> redownload
$BIN/ard-delete-logs.sh

exit 0

