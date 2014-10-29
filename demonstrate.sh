#!/usr/bin/env bash

set -e

# Process the arguments, should be:
#   demonstrate.sh <script> <interpreter> [<args...>]
if [[ $# -lt 2 ]]
then
    echo "Usage: demonstrate.sh <script> <interpreter> [<args...>]"
    echo "  Must supply both a script and an interpreter"
    exit 1
fi

SCRIPT="$1"
INTERPRETER="$2"

shift 2
#ARGS="$@"


# Make a temporary FIFO to allow communication between this shell and
# the interpreter
FIFONAME=$(mktemp -u)
mkfifo -m 0600 $FIFONAME

exec 4<> $FIFONAME

# Setup the long running process to communicate with
# And capture it's PID for waiting and killing
$INTERPRETER <&4 "$ARGS" &
PID=$!

# Save current stdout to FD 3
exec 3>&1

# Now, while there are lines left in $SCRIPT
while read line
do
    read input <&3
    echo $line
    #echo $line >&4
done < "$SCRIPT"

# Cleanup FIFO
rm $FIFONAME
