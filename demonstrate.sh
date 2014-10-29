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

# If we have enough arguments, then pass the extras along to the
# interpreter
if [[ $# -ge 3 ]]
then
    shift 2
    ARGS="$@"
fi

# Make a temporary FIFO to allow communication between this shell and
# the interpreter
FIFONAME=$(mktemp -u)
mkfifo -m 0600 $FIFONAME

exec 4<> $FIFONAME

# Setup the long running process to communicate with
# And capture it's PID for waiting and killing
"$INTERPRETER" $ARGS <&4 &
PID=$!

# Save current stdout to FD 3
exec 3>&1

GREEN='\e[1;32m'
BLUE='\e[1;34m'
WHITE='\e[0;37m'

# Now, while there are lines left in $SCRIPT
while read line
do
    read -p ${GREEN}"demonstrating@$SCRIPT"" "${BLUE}$(pwd | python butlast.py)"\$"${WHITE}" $line" input <&3
    #echo $line >&4
done < "$SCRIPT"

# Cleanup FIFO
rm $FIFONAME
