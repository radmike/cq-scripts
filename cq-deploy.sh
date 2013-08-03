#!/bin/bash
#
# This script deploys a single project into CQ, detect whether to use maven (for bundle project),
# or vlt (for node projects)
#


# Grab the current directory where the script was executed
CURRENT_DIR="$( pwd )"

# Figure out the actual project home
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Environment Defaults
project=add-project-name-here
cqhost='localhost'
cqport=4502
cquser='admin'
cqpassword='admin'

# Function to read environment properties
function read_props {
  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== reading props: ' $1.properties
  echo '>>-----------------------------------------------------------------------------'
  echo

  while read -r line; do eval $line; done <$PRJ_HOME/scripts/$1.properties
}

# Function for VLT import of a sub-project
function vlt-import {
  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== vlt-import for '$1
  echo '>>-----------------------------------------------------------------------------'
  echo

  cd $PRJ_HOME
  vlt --credentials $cquser:$cqpassword import -v http://$cqhost:$cqport/crx $1/src/main/content /

  # TODO Trap error conditions from vlt

  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== vlt-import for '$1' complete'
  echo '>>-----------------------------------------------------------------------------'
  echo
}

# Function to auto-deploy via mvn
function auto-deploy {
  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== auto-deploy for '$1
  echo '>>-----------------------------------------------------------------------------'
  echo

  cd $PRJ_HOME/$1

  mvn clean install -P cq -P cqblueprints -Pauto-deploy -Dcq.host=$cqhost -Dcq.port=$cqport -Dcq.user=$cquser -Dcq.password=$cqpassword || exit $ERROR_CODE

  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== auto-deploy for '$1' complete'
  echo '>>-----------------------------------------------------------------------------'
  echo
}

# Function to delete nodes in CQ
function delete_nodes {
  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== deleting nodes at: '$1
  echo '>>-----------------------------------------------------------------------------'
  echo

  curl --user $cquser:$cqpassword -F":operation=delete" http://$cqhost:$cqport/$1 > delete.log

  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== delete for '$1' complete'
  echo '>>-----------------------------------------------------------------------------'
  echo
}

# Script execution

echo
echo '>>-----------------------------------------------------------------------------'
echo '===== DEPLOYING PROJECT: ' $project
echo '>>-----------------------------------------------------------------------------'
echo

# Loop through subprojects passed in via cmd line arguments
for subprj in $*; do

  # Clean up project install directory (clean old versions of OSGI bundles)
  if [ $subprj = 'clean-bundles' ]; then
    delete_nodes apps/$project/install

  # Clean up generated clientlibs from the project
  elif [ $subprj = 'clean-clientlibs' ]; then
    delete_nodes var/clientlibs/etc/designs/$project/clientlibs

  # Check if subprj name matches an enviroment file
  elif [ -e $PRJ_HOME/scripts/$subprj.properties ]; then
    read_props $subprj

  # Check if subproject exists
  elif [ -d $PRJ_HOME/$project-$subprj ]; then

    # Either a node or bundle project
    if [ -d $PRJ_HOME/$project-$subprj/src/main/content ]; then
      vlt-import $project-$subprj
    else
      auto-deploy $project-$subprj
    fi
  else
    echo
    echo '>>-----------------------------------------------------------------------------'
    echo '===== project not found: ' $subprj
    echo '>>-----------------------------------------------------------------------------'
    echo
  fi

done

# Go back to the original directory
cd $CURRENT_DIR
