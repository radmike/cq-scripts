#!/bin/bash
#
# This script imports all pnc-foundation bundle projects into CQ publish
#


CURRENT_DIR="$( pwd )"
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"


echo '-------------------------------------------------------------------------------'
echo 'pnc-foundation deploy to authoring'
echo '-------------------------------------------------------------------------------'
echo ''
echo 'pnc-foundation home: '
echo '  ' $PRJ_HOME
echo '-------------------------------------------------------------------------------'
echo

$PRJ_HOME/scripts/pf-deploy.sh authoring config dependencies view services security workflows taglib || exit

# back to original directory
cd $CURRENT_DIR
