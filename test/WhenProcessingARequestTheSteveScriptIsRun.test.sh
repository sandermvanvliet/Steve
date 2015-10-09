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
echo "2daf88fda470d38d85ac39f8e3446a5e50c27cd9" >> $QUEUE/20150102122020.request

#### Act: Run steve
./execsteve.sh
EXITCODE=$?

#### Assert: Check expected results
AssertEqual $EXITCODE 0

if [ ! -f "$WORKING_DIR/20150102122020/output.steve" ]
then
  TestFailure "Expected output.steve to exist in the working directory but it was not found"
  exit 1
fi
