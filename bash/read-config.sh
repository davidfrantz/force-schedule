#!/bin/bash

PROG=`basename $0`;
CONFIG=../config/config.txt

# config found?
if [ ! -r $CONFIG ]; then
  echo "$CONFIG not found by $PROG" 1>&2;
  exit 1
fi

# tag given?
if [ $# -ne 1 ] ; then 
  echo "$TAG not properly given to $PROG" 1>&2;
  exit 1
fi
TAG=$1

# search for tag in config and read value
VALUE=$(grep "^$TAG " "$CONFIG" | sed 's/.* *= *//')

# read successful?
if [ -z "$VALUE" ]; then
  echo "$TAG not found in config.txt" 1>&2;
  exit 1
fi

# print value
echo $VALUE

exit 0

