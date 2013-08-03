#!/bin/bash
#
# This script does the initial build of the various pnc-foundation projects, and builds the eclipse files.
#
# Assumes you have setup your settings.xml file with the following profiles as described here:
#  http://www.cqblueprints.com/xwiki/bin/view/Blue+Prints/Connecting+to+the+CQ+Blueprints+Repository
#  http://www.cqblueprints.com/xwiki/bin/view/Blue+Prints/Connecting+to+the+Adobe+Maven+Repository
#
# i.e. you have 'cq' and 'cqblueprints' profiles available
#


CURRENT_DIR="$( pwd )"
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# mvn/project init
function mvn-init {
  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== '$1' mvn/project setup'
  echo '>>-----------------------------------------------------------------------------'
  echo

  cd $PRJ_HOME/$1

  echo
  echo '===== mvn build'
  echo
  mvn clean install -P cq -P cqblueprints

  echo
  echo '===== eclipse setup'
  echo
  mvn eclipse:eclipse -DdownloadSources=true -DdownloadJavadocs=true -P cq -P cqblueprints

  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== '$1' mvn/project setup complete'
  echo '>>-----------------------------------------------------------------------------'
  echo
}

echo '-------------------------------------------------------------------------------'
echo 'pnc-foundation initial mvn/project setup'
echo
echo 'executing the following cmds for all pnc-foundation subprojects:'
echo '    mvn clean install -P cq -P cqblueprints'
echo '    mvn eclipse:eclipse '
echo '        -DdownloadSources=true -DdownloadJavadocs=true -P cq -P cqblueprints'
echo ''
echo 'pnc-foundation home: '
echo '  ' $PRJ_HOME
echo '-------------------------------------------------------------------------------'
echo

mvn-init pnc-foundation-config
mvn-init pnc-foundation-view
mvn-init pnc-foundation-services
mvn-init pnc-foundation-security
mvn-init pnc-foundation-workflows
mvn-init pnc-foundation-taglib

# back to scripts
cd $CURRENT_DIR
