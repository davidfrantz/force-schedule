#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e

maxtry=10
if [ $# -eq 1 ]; then
  ntry=$1
else
  ntry=0
fi

if [ $ntry -ge $maxtry ]; then
  echo "max. tries reached. suspend for now."
  exit 1
fi

# parse config file
IMAGE=`$BIN/read-config.sh "FORCE_IMAGE"`
DIR_WVP=`$BIN/read-config.sh "DIR_WVP"`

# start and end dates
#d=2000-02-24
d=2021-06-01
#d=2021-01-01
#d=2021-06-19
#d=$(date --date "30 days ago")
y=$(date -I --date yesterday)
#y=2021-06-21
#echo "$d" "$y"
TIME=$(date +"%Y%m%d%H%M%S")

CMD="$DIR_WVP/cmds.sh"
if [ -r $CMD ]; then
  echo "warning: $CMD already exists. Deleting it now."
  rm $CMD
fi

while [ "$d" != "$y" ]; do 

  YEAR=$(date -d $d +"%Y")
  MONTH=$(date -d $d +"%m")
  DAY=$(date -d $d +"%d")
  echo $BIN/download-wvdb.sh $YEAR $MONTH $DAY >> $CMD

  d=$(date -I -d "$d + 1 day")

done


# download and compile
LOG="$DIR_WVP/log/force-lut-modis_$TIME-try$ntry.log"

set +e
parallel -a $CMD -j 8 > $LOG
set -e

rm $CMD


# if failed, delete uncomplete files, and try again
fail=$(grep "unable to open image" $LOG | sed 's/^.*unable to open image //')
nfail=$(echo $fail | wc -l)
echo "$nfail failed"
echo $fail 

if [ $nfail -gt 0 ]; then
  echo "failed to download $nfail images (tries: $ntry)"
  ((++ntry))
  rm $fail
  $BIN/update-wvdb.sh $ntry
fi

# once again to build climatology
$BIN/download-wvdb.sh

exit 0
