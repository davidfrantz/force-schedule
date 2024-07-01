#!/bin/bash

PROG=$(basename "$0")
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "$PROG: $(date +"%Y-%m-%d %H:%M:%S")"
echo "-----------------------------------------------------------"

# make sure script exits if any process exits unsuccessfully
set -e


# get config file
if [ $# -ne 1 ] ; then 
  echo "configuration file is missing" 1>&2;
  exit 1
fi
CONFIG=$1


# parse config file
IMAGE=$("$BIN"/read-config.sh "FORCE_IMAGE" "$CONFIG")
PARAM=$("$BIN"/read-config.sh "FILE_COMPOSITE_PARAM" "$CONFIG")
LATENCY=$("$BIN"/read-config.sh "COMPOSITE_LATENCY" "$CONFIG")

# get current date
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY_START=01

# get target month
MONTH=$((MONTH-LATENCY))

# account for turn of the year
if [ $MONTH -le 0 ]; then
  MONTH=$((12+MONTH))
  YEAR=$((YEAR-1))
fi

# make sure month is 0-padded
MONTH=$(printf "%02d" $MONTH)

# how many days in month?
case $MONTH in
  (01|03|05|07|08|10|12) DAY_END=31 ;;
  (04|06|09|11) DAY_END=30 ;;
  (02) if [ $((YEAR % 4)) -eq 0 ]; then DAY_END=29; else DAY_END=28; fi ;;
  (*) echo 'unexpected month'; exit 1 ;;
esac

DOY_START=(1 32 60 91 121 152 182 213 244 274 305 335)
DOY_MID=(15 45 74 105 135 166 196 227 258 288 319 349)
DOY_END=(31 59 90 120 151 181 212 243 273 304 334 365)

# substitute and create temporary parameter file
TEMP_PARAM="composite-$YEAR-$MONTH.prm"
sed "/^DATE_RANGE /c\\DATE_RANGE = $YEAR-$MONTH-$DAY_START $YEAR-$MONTH-$DAY_END" "$PARAM" > "$TEMP_PARAM"
sed "/^DOY_RANGE /c\\DOY_RANGE = ${DOY_START[(($MONTH-1))]} ${DOY_END[(($MONTH-1))]}" "$PARAM" > "$TEMP_PARAM"
sed "/^YEAR_TARGET /c\\YEAR_TARGET = $YEAR" "$PARAM" > "$TEMP_PARAM"
sed "/^DOY_STATIC /c\\DOY_STATIC = ${DOY_START[(($MONTH-1))]} ${DOY_MID[(($MONTH-1))]} ${DOY_END[(($MONTH-1))]}" "$PARAM" > "$TEMP_PARAM"

# process
docker run \
--rm \
-e FORCE_CREDENTIALS=/app/credentials \
-e BOTO_CONFIG=/app/credentials/.boto \
-v "$HOME:/app/credentials" \
-v /data:/data \
-v /mnt:/mnt \
-v "$HOME:$HOME" \
-w "$PWD" \
-u "$(id -u):$(id -g)" \
"$IMAGE" \
force-higher-level \
  "$TEMP_PARAM"

# delete parameter file again
rm "$TEMP_PARAM"

exit 0
