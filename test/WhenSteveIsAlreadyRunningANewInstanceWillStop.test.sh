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

if [ ! -d $WORKING_DIR ]
then
  mkdir $WORKING_DIR
else
  rm -rf $WORKING_DIR/*
fi

rm -f $QUEUE/*.request

# Create a new request in the queue
touch $QUEUE/20150102122020.request

# Touch the PID file to simulate a running Steve instance
touch $STEVE_PID_FILE

#### Act: Run steve
./execsteve.sh
EXITCODE=$?

#### Assert: Check expected results
AssertEqual $EXITCODE 0
OutputContains "Steve already running, stopping this instance"
