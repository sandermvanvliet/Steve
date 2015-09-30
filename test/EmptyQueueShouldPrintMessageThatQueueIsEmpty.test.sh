#!/bin/sh

# Make the name of the test available to the runner
export TEST_NAME="Empty queue should print message that queue is empty"

# Source test support functions
. ./test-support.sh

# Source the configuration to get a reference to the queue
. ./test-steve.conf


# Arrange goes here

# Ensure queue exists
if [ ! -d $QUEUE ]
then
  mkdir $QUEUE
fi

rm -f $QUEUE/*.request

# Act: Run steve
./execsteve.sh
EXITCODE=$?

# Assert: Check expected results
#AssertEqual $EXITCODE 0
OutputContains "No requests pending"
