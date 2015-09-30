#!/bin/sh

# Make the name of the test available to the runner
export TEST_NAME="Version should be printed"

# Source test support functions
. ./test-support.sh

# Source the configuration to get a reference to the queue
. ./test-steve.conf


# Arrange goes here

# Ensure queue exists

# Act: Run steve
./execsteve.sh
EXITCODE=$?

# Assert: Check expected results
#AssertEqual $EXITCODE 0
OutputContains "Steve version"
