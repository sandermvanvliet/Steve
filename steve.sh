#!/bin/bash
# vim: set ts=4 :

VERSION="0.0.1"
VERBOSE=0

function LogInfo {
    if [ ! -z "$1" ] && [ $VERBOSE -eq 1 ]
    then
      echo "$1"
    fi
}

function LogError {
    if [ ! -z "$1" ]
    then
      echo "$1" 1>&2
    fi
}

function Exit {
    EXIT_CODE=$1
    if [ -z "$EXIT_CODE" ]
    then
      EXIT_CODE=1
    fi

    rm -f $STEVE_PID_FILE

    exit $EXIT_CODE
}

if [ ! -z "$1" ] && [ "$1" = "--verbose" ]
then
    VERBOSE=1
fi

if [ -z $STEVE_CONFIG ]
then
    STEVE_CONFIG=./steve.conf
fi

LogInfo "Steve version $VERSION"

if [ ! -f $STEVE_CONFIG ]
then
  LogError "Config not found at $STEVE_CONFIG, refusing to run"
  Exit 1
fi

. $STEVE_CONFIG

if [ -f "$STEVE_PID_FILE" ]
then
  LogInfo "Steve already running, stopping this instance"
  Exit 0
fi

if [ -z $QUEUE ]
then
  QUEUE=/var/spool/steve
fi

LogInfo "Looking in queue: $QUEUE"

if [ ! -d $QUEUE ]
then
  LogError "Queue not found or not a directory"
  Exit 1
fi

NUMBER_OF_REQUESTS=`find $QUEUE -type f | wc -l | tr -d '[[:space;]]'`

if [ $NUMBER_OF_REQUESTS -eq 0 ]
then
  LogInfo "No requests pending"
  Exit 0
fi

LogInfo "$NUMBER_OF_REQUESTS requests pending"

for request in `find $QUEUE -type f \( -name *.request \) -exec basename {} \; | sed -e 's/\.request//' | sort`
do
    LogInfo "Running request $request"
    REQUEST_WORKING_DIR="$WORKING_DIR/$request"

    if [ ! -d $WORKING_DIR ]
    then
      LogInfo "Working directory \"$WORKING_DIR\" doesn't exist, creating..."
      mkdir $WORKING_DIR
    fi

    if [ ! -d $REQUEST_WORKING_DIR ]
    then
      LogInfo "Creating working directory for request..."
      mkdir $REQUEST_WORKING_DIR
    fi

    REPO_URI=`head -n 1 "$QUEUE/$request.request"`
    COMMIT=`tail -n 1 "$QUEUE/$request.request"`

    LogInfo "Cloning from $REPO_URI"
    git clone "$REPO_URI" "$REQUEST_WORKING_DIR" -q

    CWD=`pwd -P`
    cd "$REQUEST_WORKING_DIR"

    LogInfo "Checking out to commit $COMMIT"
    git checkout $COMMIT -q

    COMMIT_SHORT_HASH=`git log -1 --format=%h $COMMIT`
    COMMIT_MESSAGE=`git log -1 --format=%s $COMMIT`

    BUILD_STATUS=0

    if [ -f "buildandpublish.steve" ]
    then
      /bin/sh "buildandpublish.steve" 2>&1 $QUEUE/$request.log
      BUILD_STATUS=$?
    else
      LogInfo "Steve script not found"
    fi

    cd $CWD

    rm "$QUEUE/$request.request"

    if [ $BUILD_STATUS -ne 0 ]
    then
      $NOTIFIER "Steve" 2 "Build failed" "$COMMIT_SHORT_HASH $COMMIT_MESSAGE"
    else
      $NOTIFIER "Steve" 0 "Build completed" "$COMMIT_SHORT_HASH $COMMIT_MESSAGE"
    fi

    if [ -f "$STEVE_PID_FILE" ]
    then
        rm $STEVE_PID_FILE
    fi
done

Exit 0
