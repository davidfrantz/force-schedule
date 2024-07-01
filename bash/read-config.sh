#!/bin/bash

PROG=$(basename "$0")
#BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# get config file
if [ $# -ne 2 ] ; then 
  echo "wrong number of arguments" 1>&2;
  echo "1: tag" 1>&2;
  echo "2: configuration file" 1>&2;
  exit 1
fi
TAG=$1
CONFIG=$2

# config found?
if [ ! -r "$CONFIG" ]; then
  echo "$CONFIG not found by $PROG" 1>&2;
  exit 1
fi


# search for tag in config and read value
VALUE=$(grep "^$TAG " "$CONFIG" | sed 's/.* *= *//')

# read successful?
if [ -z "$VALUE" ]; then
  echo "$TAG not found in config.txt" 1>&2;
  exit 1
fi

# print value
echo "$VALUE"

exit 0

