#!/bin/bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ENV_DIR=$BASE_DIR/../../environments
PENTAHO_ENV="${PENTAHO_ENV:-local}"
PENTAHO_EXEC_RUNTIME="${PENTAHO_EXEC_RUNTIME:-development}"
KETTLE_HOME=$ENV_DIR/$PENTAHO_ENV/$PENTAHO_EXEC_RUNTIME
REPO_HOME=$BASE_DIR/../../repository

# check if the environment folder exists
if [[ -d "$KETTLE_HOME" ]]; then
  echo Running with $PENTAHO_ENV/$PENTAHO_EXEC_RUNTIME environment settings
else
  echo Please configure the $PENTAHO_ENV/$PENTAHO_EXEC_RUNTIME environment correctly
  exit 1
fi

# load environment configuration
. $KETTLE_HOME/boot.conf

# check if a valid PDI installation folder variable has been provided
if [[ -z "$PENTAHO_HOME" ]]; then
  echo Please set the default PENTAHO_HOME
  exit 1
fi

# check if a valid PDI installation folder has been provided
if [[ -f "$PENTAHO_HOME/spoon.sh" ]]; then
  echo Found spoon.sh continuing initialization
else
  echo Invalid PENTAHO_HOME folder, could not find spoon.sh
  exit 1
fi

# check if a valid environment startup has been provided
if [[ -z "$PENTAHO_DI_JAVA_OPTIONS" ]]; then
  echo Please set the default PENTAHO_DI_JAVA_OPTIONS
  exit 1
else
  export PENTAHO_DI_JAVA_OPTIONS="$PENTAHO_DI_JAVA_OPTIONS -DPENTAHO_METASTORE_FOLDER=$KETTLE_HOME -DREPO_HOME=$REPO_HOME"
fi

# check if there is a custom JAVA_HOME set
if [[ -z "$PENTAHO_JAVA_HOME" ]]; then
  echo No PENTAHO_JAVA_HOME set, continuing with system wide default
else
  export PENTAHO_JAVA_HOME=$PENTAHO_JAVA_HOME
fi

# set the KETTLE_HOME to the project environment folder
export KETTLE_HOME=$KETTLE_HOME

# finish up by moving to the PDI folder
cd $PENTAHO_HOME
