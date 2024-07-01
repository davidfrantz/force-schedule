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
DIR_LANDSAT_IMAGES=$("$BIN"/read-config.sh "DIR_LANDSAT_IMAGES" "$CONFIG")
FILE_LANDSAT_QUEUE=$("$BIN"/read-config.sh "FILE_LANDSAT_QUEUE" "$CONFIG")

function extract (){

  TAR=$1
  
  IMG=${TAR%%.*}

  mkdir -p "$IMG"
  if ! tar -xf "$TAR" -C "$IMG"; then
    echo "something wrong with this archive. Delete again"
    rm "$TAR"
    if [ -d "$IMG" ]; then
      rm -r "$IMG"
    fi
    exit
  fi

  # not removing to enable -nc option in wget
  #rm "$TAR"

}
export -f extract


ls "$DIR_LANDSAT_IMAGES"/*.tar | parallel -j8 extract {}

ls -d "$DIR_LANDSAT_IMAGES"/*/ > "$FILE_LANDSAT_QUEUE"
sed -i 's/$/ QUEUED/' "$FILE_LANDSAT_QUEUE"

exit 0
