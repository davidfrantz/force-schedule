#!donotrun

# Do not execute this file!

# Schedule processes with Cron
crontab -e

# Replace all occurences of "force-schedule" below with the full file path of this repository!

# Replace the times and frequencies to your needs
# Google "cronjob" if you do not know how this works

# Add lines like these to the crontab

# Update FORCE each evening
# 20:00 PM each night
0 20 * * * force-schedule/bash/update-force.sh

# Update Google Cloud Storage metadata, and
# download all Sentinel-2 images that were not already processed to ARD
# 21:00 PM each night
0 21 * * * force-schedule/bash/ingest-sentinel2.sh

# generate Landsat links for images that were not already processed to ARD
# download images that were not already downloaded
# extract the images
# 23:00 PM each day
0 23 * * * /data/Dagobah/dc/force-schedule/bash/ingest-landsat.sh

# Preprocess Sentinel-2 L1C to ARD
# Generate processing report
# Delete downloaded L1C data after preprocessing
# 01:00 AM each monday morning
0 1 * * 1 force-schedule/bash/process-sentinel2.sh

