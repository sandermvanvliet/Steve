#!/bin/sh

# Source test support functions
. ./test-support.sh

# Source the configuration to get a reference to the queue
. ./test-steve.conf

#### Arrange goes here
if [ ! -d $QUEUE ]
then
  mkdir $QUEUE
else
  rm -f $QUEUE/*.request
fi

touch $QUEUE/20150102125050.request
touch $QUEUE/20150102122020.request
touch $QUEUE/20150102123030.request

#### Act: Run steve
./execsteve.sh
EXITCODE=$?

#### Assert: Check expected results
OutputContains "Running request 20150102122020"
OutputContains "Running request 20150102123030"
OutputContains "Running request 20150102125050"
