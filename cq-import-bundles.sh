#!/bin/bash
#
# This script imports all bundle projects into CQ
#


# Grab the current directory where the script was executed
CURRENT_DIR="$( pwd )"

# Figure out the actual project home
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"


# Start script execution

echo '-------------------------------------------------------------------------------'
echo 'import all bundles into cq'
echo '-------------------------------------------------------------------------------'
echo ''
echo 'auto-deploys all bundles via:'
echo '  mvn -Pauto-deploy install'
echo ''
echo 'project home: '
echo '  ' $PRJ_HOME
echo '-------------------------------------------------------------------------------'
echo


echo '-------------------------------------------------------------------------------'
echo 'auto deploying bundles...'
echo '-------------------------------------------------------------------------------'

$PRJ_HOME/scripts/cq-deploy.sh $1 clean-bundles services taglib || exit

# End script execution


# Back to the original directory
cd $CURRENT_DIR
