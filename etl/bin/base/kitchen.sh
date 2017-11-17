#!/bin/bash
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
. ${BASEDIR}/init.sh
FILE=$1
shift
sh kitchen.sh -file="$REPO_HOME/$FILE" "$@"
