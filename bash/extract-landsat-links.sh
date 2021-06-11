#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e


# parse config file
DIR_LANDSAT_IMAGES=`$BIN/read-config.sh "DIR_LANDSAT_IMAGES"`
FILE_LANDSAT_QUEUE=`$BIN/read-config.sh "FILE_LANDSAT_QUEUE"`

function extract (){

  TAR=$1
  
  IMG=${TAR%%.*}

  mkdir -p "$IMG"
  tar -xf "$TAR" -C "$IMG"
  if [ $? -ne 0 ]; then
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


ls $DIR_LANDSAT_IMAGES/*.tar | parallel -j8 extract {}

ls -d $DIR_LANDSAT_IMAGES/*/ > $FILE_LANDSAT_QUEUE
sed -i 's/$/ QUEUED/' $FILE_LANDSAT_QUEUE

exit 0
