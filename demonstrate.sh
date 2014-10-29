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

$INTERPRETER <&3 &
PID=
