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
  rmdir $WORKING_DIR/*
fi

rm -f $QUEUE/*.request

PATH_TO_REPO="`pwd -P`/testdata/repo"
echo "PATH_TO_REPO: $PATH_TO_REPO"
echo "file:////$PATH_TO_REPO" > $QUEUE/20150102122020.request

#### Act: Run steve
./execsteve.sh
EXITCODE=$?

#### Assert: Check expected results
AssertEqual $EXITCODE 0

if [ ! -d $WORKING_DIR/20150102122020/.git ]
then
  TestFailure "Expected .git folder to be present after clone but it was not found"
  exit 1
fi
