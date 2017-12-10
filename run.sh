#!/bin/bash -ex

# This script will wait for a file to exist, once it does it will copy it
# to the specified directory and exit with success code. If the file is not
# found in the predefined time period it will timeout and exit with unsuccessful
# status code.
# The first param is the file to watch for, the second param is the path to
# copy the file to once it is found.

# The command to start the app should be passed in as the first arg to the script
COMMAND="$APP_START_COMMAND"

# If CONFIG_PATH_IN if set then it will wait for that file and copy it to the
# destintion directory when it is found. If CONFIG_PATH_IN is not found it
# will skip that and just execute the command to start the app (which will use
# the default config file already contained within the container).
FILE="$CONFIG_PATH_IN"
APP_DIR="$CONFIG_PATH"
if [ ${#FILE} -ge 1 ]; then
    x=0
    while [ "$x" -lt 100 -a ! -e $FILE ]; do
        x=$((x+1))
        echo "Waiting for file to exist: $FILE"
        sleep .5
    done
    if [ -e $FILE ]
    then
        echo "Found: $FILE, copying to application directory: $APP_DIR"
        cp $FILE $APP_DIR
        rm $FILE
    else
        echo "File $FILE not found within time limit!"
        exit 1 # Did not find file within specified time, exit as failure
    fi
else
    echo "Using local config.edn, copying to application directory: $APP_DIR"
    cp /usr/src/app/env/dev/resources/config.edn $APP_DIR
fi

# Use exec so the signal commands (sigterm ,etc) get passed down into the actual command
exec $COMMAND
