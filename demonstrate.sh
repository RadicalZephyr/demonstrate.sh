#!/usr/bin/env bash

set -e

# Process the arguments, should be:
#   demonstrate.sh <script> <interpreter> [<args...>]

SCRIPT="$1"
INTERPRETER="$2"

shift 2
ARGS="$@"

unshift

# Setup the long running process to communicate with
# And capture it's PID for waiting and killing

$INTERPRETER <&3 "$ARGS" &
PID=$!

# Now, while there are lines left in $SCRIPT
while read $line
do
    echo $line
done < "$SCRIPT"
