#!/bin/bash

# make sure script exits if any process exits unsuccessfully
set -e

# update metadata catalogue
./update-metadata-csd.sh && \
#
# download data
./download-sentinel2.sh

exit 0

