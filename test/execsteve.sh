#!/bin/sh

. ./test-support.sh

STEVE_CONFIG=test-steve.conf ../steve.sh > $STEVE_OUTPUT 2>&1
