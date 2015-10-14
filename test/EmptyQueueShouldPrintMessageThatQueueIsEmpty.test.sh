#!/bin/sh

# Source test support functions
. ./test-support.sh

# Source the configuration to get a reference to the queue
. ./test-steve.conf

#### Arrange goes here

#### Act: Run steve
./execsteve.sh
EXITCODE=$?

#### Assert: Check expected results
OutputContains "No requests pending"
