# Do not execute this file!

# Schedule processes with Cron
crontab -e

# Replace all occurences of "force-schedule" below with the full file path!

# Replace the times and frequencies to your needs
# Google "cronjob" if you do not know how this works

# Add lines like these to the crontab

# Update FORCE each evening
0 20 * * * force-schedule/bash/update-force.sh

# Update Google Cloud Storage metadata, and
# download all Sentinel-2 images that were not already processed to ARD
30 20 * * * force-schedule/bash/ingest-sentinel2.sh
 

