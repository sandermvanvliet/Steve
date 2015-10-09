#!/bin/sh

# Source test support functions
. ./test-support.sh

# Source the configuration to get a reference to the queue
. ./test-steve.conf

#### Arrange goes here
touch $QUEUE/20150102125050.request
touch $QUEUE/20150102122020.request
touch $QUEUE/20150102123030.request

#### Act: Run steve
./execsteve.sh
EXITCODE=$?

#### Assert: Check expected results
arr=()
while read -r line;
do
  arr+=("$line")
done <<< "`grep "Running request" $STEVE_OUTPUT`"

AssertEqual "${arr[0]}" "Running request 20150102122020"
AssertEqual "${arr[1]}" "Running request 20150102123030"
AssertEqual "${arr[2]}" "Running request 20150102125050"
