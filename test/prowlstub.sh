#!/bin/sh

. ./test-support.sh

app=$1
priority=$2
event=$3
description=$4

echo "$app|$priority|$event|$description" >> $PROWL_STUB_OUTPUT
