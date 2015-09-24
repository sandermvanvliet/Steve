#!/bin/sh

VERSION="0.0.1"

if [ -z $STEVE_CONFIG ]
then
    STEVE_CONFIG=/etc/conf.d/steve
fi

echo "Steve version $VERSION"

if [ ! -f $STEVE_CONFIG ]
then
  echo "Config not found at $STEVE_CONFIG, refusing to run." > /dev/stderr
  exit 1
fi
