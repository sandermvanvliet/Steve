#!/bin/sh

# Source test support functions
. ./test-support.sh

# Source the configuration to get a reference to the queue
. ./test-steve.conf

#### Arrange goes here
# Clean up possible stale repository
if [ -d testdata/repo ]
then
  rm -rf testdata/repo
fi

# Extract test repository
tar -zxf testdata/repo.tar.gz -C testdata

# Git seems to require absolute path to repository
PATH_TO_REPO="`pwd -P`/testdata/repo"
echo "PATH_TO_REPO: $PATH_TO_REPO"
echo "file:////$PATH_TO_REPO" > $QUEUE/20150102122020.request
echo "480b39a77acaaa3484892b07808e12cbb177f08e" >> $QUEUE/20150102122020.request

#### Act: Run steve
./execsteve.sh
EXITCODE=$?

#### Assert: Check expected results
AssertEqual $EXITCODE 0
MESSAGE=`tail -n 1 $PROWL_STUB_OUTPUT`
AssertEqual "$MESSAGE" "Steve|2|Build failed|480b39a Changed script so that it fails"
