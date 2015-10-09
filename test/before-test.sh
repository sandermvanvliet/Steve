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

rm -f $STEVE_PID_FILE

rm -f $PROWL_STUB_OUTPUT

rm -f $STEVE_OUTPUT
