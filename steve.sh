#!/bin/sh
# vim: set ts=4

VERSION="0.0.1"

if [ -z $STEVE_CONFIG ]
then
    STEVE_CONFIG=/etc/conf.d/steve
fi

echo "Steve version $VERSION"

if [ ! -f $STEVE_CONFIG ]
then
  echo "Config not found at $STEVE_CONFIG, refusing to run" > /dev/stderr
  exit 1
fi

. $STEVE_CONFIG

if [ -z $QUEUE ]
then
  QUEUE=/var/spool/steve
fi

echo "Looking in queue: $QUEUE"

if [ ! -d $QUEUE ]
then
  echo "Queue not found or not a directory" > /dev/stderr
  exit 1
fi

NUMBER_OF_REQUESTS=`find $QUEUE -type f | wc -l | tr -d '[[:space;]]'`

if [ $NUMBER_OF_REQUESTS -eq 0 ]
then
  echo "No requests pending"
  exit 0
fi

echo "$NUMBER_OF_REQUESTS requests pending"

for request in `find $QUEUE -type f \( -name *.request \) -exec basename {} \; | sort`
do
    echo "Running request $request"
done
