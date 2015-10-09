#!/bin/sh

# Source test support functions
. ./test-support.sh

# Source the configuration to get a reference to the queue
. ./test-steve.conf

# Make sure the queue directory exists
if [ ! -d $QUEUE ]
then
  mkdir $QUEUE
else
  rm -f $QUEUE/*.request
fi

# Make sure working directory exists and is empty
if [ ! -d $WORKING_DIR ]
then
  mkdir $WORKING_DIR
else
  rm -rf $WORKING_DIR/*
fi

# Remove the PID file, Steve will fail otherwise (See WhenSteveIsAlreadyRunningANewInstanceWillStop.test.sh) 
rm -f $STEVE_PID_FILE

# Remove output if the Prowl stub
rm -f $PROWL_STUB_OUTPUT

# Remove the output of the previous run
rm -f $STEVE_OUTPUT

# Clean up possible stale repository
if [ -d testdata/repo ]
then
  rm -rf testdata/repo
fi
