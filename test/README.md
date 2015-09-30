# Automated testing
The scripts here run tests on Steve.

To write a new test copy and paste the following to a new file:

```
#!/bin/sh

# Source test support functions
. ./test-support.sh

# Source the configuration to get a reference to the queue
. ./test-steve.conf

#### Arrange goes here
echo "foo" > $QUEUE/20150102.request

#### Act: Execute steve
./execsteve.sh
EXITCODE=$?

#### Assert: Check expected results
AssertEqual $EXITCODE 0
```

Filename of the test should be in the format **\<Name>**.test.sh
