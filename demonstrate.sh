#!/usr/bin/env bash

set -e
[[ "$DEBUG" = true ]] && set -x

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

if [[ ! -f "$SCRIPT" ]]
then
    echo "$SCRIPT is not a file..."
    exit 1
fi

which "$INTERPRETER" 2>&1 > /dev/null
if [[ $? -ne 0 ]]
then
    echo "$INTERPRETER was not found on path."
    echo "Maybe you should specify the full path to it?"
    exit 1
fi

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

# Setup the long running process to communicate with
# And capture it's PID for waiting and killing
"$INTERPRETER" $ARGS < $FIFONAME &
PID=$!

# Only open the fifo for writing
exec 4> $FIFONAME

# Save current stdout to FD 3
exec 3>&1

case "$INTERPRETER" in
    bash    ) PROMPT='${GREEN}"demonstrating@$SCRIPT"${ENDC}" "${BLUE}$(pwd | python util/butlast.py)"\$"${ENDC}' ;;
    python* ) PROMPT='>>>' ;;
    irb     ) N=1; PROMPT='"irb(main):"$(printf "%03d" $N)":0>"; N=$((N + 1))' ;;
    node    ) PROMPT='>' ;;
    coffee  ) PROMPT='coffee>' ;;
esac

PROMPT="echo -e -n $PROMPT"

GREEN='\033[1;32m'
BLUE='\033[1;34m'
WHITE='\033[0;37m'
ENDC='\033[0m'

[[ "$DEBUG" = true ]] && set +x
sleep 0.1

# Now, while there are lines left in $SCRIPT
while read line
do
    if [[ "$line" = "" ]]
    then
        continue
    fi

    sleep 0.1
    eval "$PROMPT"
    util/faketype "$line"
    read <&3
    echo $line >&4
done < "$SCRIPT"

[[ "$DEBUG" = true ]] && set -x
sleep 0.1

echo
echo "----------------"
echo "Done with script"
echo
echo "Closing the FIFO"
exec 4>&-

echo "Wait on the interpreter PID"
wait $PID

[[ -p "$FIFONAME" ]] && rm $FIFONAME
