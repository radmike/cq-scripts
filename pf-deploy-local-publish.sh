#!/bin/bash
#
# This script imports all pnc-foundation bundle projects into CQ publish
#


CURRENT_DIR="$( pwd )"
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"


echo '-------------------------------------------------------------------------------'
echo 'pnc-foundation deploy to local publish'
echo '-------------------------------------------------------------------------------'
echo ''
echo 'pnc-foundation home: ' 
echo '  ' $PRJ_HOME
echo '-------------------------------------------------------------------------------'
echo

$PRJ_HOME/scripts/pf-deploy.sh local-publish $@ || exit

# back to original directory
cd $CURRENT_DIR
