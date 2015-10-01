#!/bin/sh

. ./test-support.sh

VERBOSE="--verbose"

if [ ! -z "$1" ] && [ "$1" = "--quiet" ]
then
  VERBOSE=""
fi

STEVE_CONFIG=test-steve.conf ../steve.sh $VERBOSE > $STEVE_OUTPUT 2>&1
