#!/bin/bash
#
# This script initializes the project w/ CQ
#
# imports initial config, and builds the entire parent project (and parent pom)
#


# Grab the current directory where the script was executed
CURRENT_DIR="$( pwd )"

# Figure out the actual project home
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"


# Start script execution

echo
echo '>>--------------------------------------------------------------------------------'
echo '===== initializing project - config, parent project'
echo '>>--------------------------------------------------------------------------------'
echo

# import config to set admin credentials for vlt
$PRJ_HOME/scripts/cq-deploy.sh $1 clean-bundles clean-clientlibs config || exit

# build parent project - no autodeploy
cd $PRJ_HOME
mvn clean install -P cq -P cqblueprints || exit $ERROR_CODE

# End script execution


# Go bck to the original directory
cd $CURRENT_DIR
