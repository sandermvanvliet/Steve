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
fi

rm -f $QUEUE/*.request

touch $QUEUE/20150102122020.request

#### Act: Run steve
./execsteve.sh
EXITCODE=$?

#### Assert: Check expected results
AssertEqual $? 0

if [ ! -d $WORKING_DIR/20150102122020 ]
then
  TestFailure "Working directory not created for request"
  exit 1
fi
