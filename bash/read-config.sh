#!/bin/bash
# use: read-config.sh PARAMETER_NAME config.txt [DEFAULT_VALUE]
PROG=$(basename "$0")

# get config file
if [ $# -lt 2 ] || [ $# -gt 3 ];  then 
  echo "wrong number of arguments ($#)" 1>&2;
  echo "1: tag" 1>&2;
  echo "2: configuration file" 1>&2;
  echo "3: default value (optional)" 1>&2
  exit 1
fi

TAG=$1
CONFIG=$2
DEFAULT=$3

# config found?
if [ ! -r "$CONFIG" ]; then
  echo "$CONFIG not found by $PROG" 1>&2;
  exit 1
fi


# search for tag in config and read value
VALUE=$(grep "^$TAG " "$CONFIG" | sed 's/.* *= *//')

# read successful?
if [ -z "$VALUE" ]; then
  if [ -n "$DEFAULT" ]; then
    VALUE="$DEFAULT"
  else
    echo "$TAG not found in $CONFIG" 1>&2
    exit 1
  fi
fi

# print value
echo "$VALUE"

exit 0

