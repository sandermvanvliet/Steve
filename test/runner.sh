#!/bin/sh
# vim: set filetype=sh, ts=2 :

STEVE_CONFIG=test-steve.conf

NUMBER_OF_TESTS=`find . -type f \( -name "*.test.sh" \) | wc -l | tr -d '[[:space:]]'`

if [ $NUMBER_OF_TESTS -eq 0 ]
then
    echo "No tests to run"
    exit 1
fi

COUNTER=1
TESTS_SUCCEEDED=0
TESTS_FAILED=0

for testfile in `find . -type f \( -name "*.test.sh" \)`
do
    testname=`echo $testfile | sed -e 's/\.test\.sh//' | sed -e 's/\.\///'`

    echo "[$testname] \c"

    /bin/sh $testfile

    if [ $? -eq 1 ]
    then
      let TESTS_FAILED=$TESTS_FAILED+1
    fi
    if [ $? -eq 0 ]
    then
      let TESTS_SUCCEEDED=$TESTS_SUCCEEDED+1
    fi

    let COUNTER=$COUNTER+1
done

echo "\nTest run completed"
echo "$TESTS_SUCCEEDED tests succeeded"
echo "$TESTS_FAILED tests failed"

exit 0
