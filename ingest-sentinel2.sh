#!/bin/bash

# update metadata catalogue
bash /data/Dagobah/dc/force-schedule/update-metadata-csd.sh && \
#
# download data
bash /data/Dagobah/dc/force-schedule/download-sentinel2.sh

exit 0

