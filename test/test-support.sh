#!/bin/sh
# vim: set ts=4 :

function AssertEqual {
    if [ -z $1 ] || [ -z $2 ]
    then
        echo "AssertEqual expects two arguments" > /dev/stderr
        exit 1
    fi

    if [ "$1" -ne "$2" ]
    then
        TestFailure "Expected \"$1\" to be \"$2\""
        exit 1
    fi

    exit 0
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

    exit 0
}

function TestFailure {
    if [ -z "$1" ]
    then
        echo "TestFailure expects message parameter" > /dev/stderr
        exit 1
    fi

    echo "\033[0;31m[FAILED]\033[0m $1" > /dev/stderr
}