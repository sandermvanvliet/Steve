#!/bin/sh

# Source test support functions
. ./test-support.sh

# Source the configuration to get a reference to the queue
. ./test-steve.conf

#### Arrange goes here
if [ ! -d $QUEUE ]
then
  mkdir $QUEUE
fi

rm -f $QUEUE/*.request

touch $QUEUE/1.request
touch $QUEUE/2.request
touch $QUEUE/3.request

#### Act: Run steve
./execsteve.sh
EXITCODE=$?

#### Assert: Check expected results
OutputContains "3 requests pending"
