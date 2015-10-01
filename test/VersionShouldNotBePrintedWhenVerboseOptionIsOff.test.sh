#!/bin/sh

# Source test support functions
. ./test-support.sh

# Source the configuration to get a reference to the queue
. ./test-steve.conf


# Arrange goes here

# Ensure queue exists

# Act: Run steve
./execsteve.sh --quiet
EXITCODE=$?

# Assert: Check expected results
#AssertEqual $EXITCODE 0
OutputDoesNotContain "Steve version"
