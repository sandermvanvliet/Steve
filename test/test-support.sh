#!/bin/sh
# vim: set ts=4 :
STEVE_OUTPUT=steve-output
PROWL_STUB_OUTPUT=`pwd -P`/prowl-output

function AssertEqual {
    if [ -z "$1" ] || [ -z "$2" ]
    then
        echo "AssertEqual expects two arguments" > /dev/stderr
        exit 1
    fi

    if [ "$1" != "$2" ]
    then
        TestFailure "Expected \"$1\" to be \"$2\""
        exit 1
    fi

    return 0
}

function OutputContains {
    if [ -z "$1" ]
    then
        echo "OutputContains expects message parameter" > /dev/stderr
        exit 1
    fi

    grep "$1" steve-output > /dev/null

    if [ $? -ne 0 ]
    then
        TestFailure "Expected \"$1\" to be present in output but it wasn't found"
        exit 1
    fi

    return 0
}

function OutputDoesNotContain {
    if [ -z "$1" ]
    then
        echo "OutputDoesNotContain expects message parameter" > /dev/stderr
        exit 1
    fi

    grep "$1" steve-output > /dev/null

    if [ $? -eq 0 ]
    then
        TestFailure "Expected \"$1\" to be absent in output but it was found"
        exit 1
    fi

    return 0
}

function TestFailure {
    if [ -z "$1" ]
    then
        echo "TestFailure expects message parameter" > /dev/stderr
        exit 1
    fi

    echo "$1" > /dev/stderr
}
