#!/bin/bash
#
# This script does the initial build of the various sub-projects, and builds the eclipse files.
#


# Grab the current directory where the script was executed
CURRENT_DIR="$( pwd )"

# Figure out the actual project home
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Environment Defaults
project=add-project-name-here


# Function to initialize a mvn project
function mvn-init {
  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== '$1' eclipse setup'
  echo '>>-----------------------------------------------------------------------------'
  echo

  cd $PRJ_HOME/$1

  echo
  echo '===== eclipse setup'
  echo
  mvn eclipse:eclipse -DdownloadSources=true -DdownloadJavadocs=true -P cq -P cqblueprints || exit $ERROR_CODE

  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== '$1' mvn/project setup complete'
  echo '>>-----------------------------------------------------------------------------'
  echo
}


# Start script execution

echo '-------------------------------------------------------------------------------'
echo 'initial mvn/project/eclipse setup'
echo '-------------------------------------------------------------------------------'
echo ''
echo 'first, all projects are built via the top-level project:'
echo '    mvn clean install -P cq -P cqblueprints'
echo ''
echo 'secondly, all sub-project eclipse .project & .classpath files are built via:'
echo '    mvn eclipse:eclipse '
echo '        -DdownloadSources=true -DdownloadJavadocs=true -P cq -P cqblueprints'
echo ''
echo 'project home: '
echo '  ' $PRJ_HOME
echo '-------------------------------------------------------------------------------'
echo


echo
echo '===== mvn build starting'
echo

cd $PRJ_HOME
mvn clean install -P cq -P cqblueprints || exit $ERROR_CODE

mvn-init $project-config
mvn-init $project-view
mvn-init $project-services
mvn-init $project-taglib

# End script execution


# Go back to the original directory
cd $CURRENT_DIR
