#!/bin/sh

# Source test support functions
. ./test-support.sh

# Source the configuration to get a reference to the queue
. ./test-steve.conf

#### Arrange goes here

# Extract test repository
tar -zxf testdata/repo.tar.gz -C testdata

# Git seems to require absolute path to repository
PATH_TO_REPO="`pwd -P`/testdata/repo"
echo "PATH_TO_REPO: $PATH_TO_REPO"
echo "file:////$PATH_TO_REPO" > $QUEUE/20150102122020.request

#### Act: Run steve
./execsteve.sh
EXITCODE=$?

#### Assert: Check expected results
AssertEqual $EXITCODE 0
OutputContains "Cloning from file:////$PATH_TO_REPO"
