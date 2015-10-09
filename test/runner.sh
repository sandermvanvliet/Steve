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
TESTS_PASSED=0
TESTS_FAILED=0

if [ ! -z "$1" ]
then
    TESTS="$1"
else
    TESTS=`find . -type f \( -name "*.test.sh" \)`
fi

for testfile in $TESTS 
do
    testname=`echo $testfile | sed -e 's/\.test\.sh//' | sed -e 's/\.\///'`

    echo "[$testname] \c"

    if [ -f "before-test.sh" ]
    then
      /bin/sh before-test.sh
    fi

    TESTERROR="$(/bin/sh $testfile 2>&1 > /dev/null)"

    if [ $? -ne 0 ]
    then
      echo "\033[0;31m[FAILED]\033[0m $TESTERROR" > /dev/stderr
      let TESTS_FAILED=$TESTS_FAILED+1
    else
      echo "\033[0;32m[PASSED]\033[0m"
      let TESTS_PASSED=$TESTS_PASSED+1
    fi

    let COUNTER=$COUNTER+1
done

echo "\nTest run completed"
echo "$TESTS_PASSED tests passed"
echo "$TESTS_FAILED tests failed"

exit 0
