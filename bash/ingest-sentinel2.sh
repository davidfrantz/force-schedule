#!/bin/bash

# update metadata catalogue
bash /data/Dagobah/dc/force-schedule/bash/update-metadata-csd.sh && \
#
# download data
bash /data/Dagobah/dc/force-schedule/bash/download-sentinel2.sh

exit 0

