#!/bin/bash

# PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e

# parse config file
IMAGE=$("$BIN"/read-config.sh "FORCE_DEV_IMAGE")
PARAM=$()

YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY_START=01

case $MONTH in
  (01|03|05|07|08|10|12) DAY_END=31 ;;
  (04|06|09|11) DAY_END=30 ;;
  (02) if [ $(($YEAR % 4)) -eq 0 ]; then DAY_END=29; else DAY_END=28; fi ;;
  (*) echo 'unexpected month'; exit 1 ;;
esac

echo $YEAR $MONTH $DAY_END

TEMP_PARAM="composite-$YEAR-$MONTH.prm"

#sed "/^DATE_RANGE /c\\DATE_RANGE = $YEAR-$MONTH-$DAY_START $YEAR-$MONTH-$DAY_END" "$PARAM" > $TEMP_PARAM

# process

rm $TEMP_PARAM

exit 0

