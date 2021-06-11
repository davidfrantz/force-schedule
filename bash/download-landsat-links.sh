#!/bin/bash

PROG=`basename $0`;
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure script exits if any process exits unsuccessfully
set -e


# parse config file
DIR_LANDSAT_LINKS=`$BIN/read-config.sh "DIR_LANDSAT_LINKS"`
DIR_LANDSAT_IMAGES=`$BIN/read-config.sh "DIR_LANDSAT_IMAGES"`

function download (){

  LINK=$1
  DIR=$2

  wget --content-disposition -nc "$LINK" -P "$DIR"

}
export -f download


for s in TM ETM OLI; do

  if [ ! -r "$DIR_LANDSAT_LINKS/$s-links.txt" ]; then
    continue
  fi

  parallel -j8 -a "$DIR_LANDSAT_LINKS/$s-links.txt" download {} "$DIR_LANDSAT_IMAGES"

  rm "$DIR_LANDSAT_LINKS/$s-links.txt"

done

exit 0
