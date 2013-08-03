#!/bin/bash
#
# This script imports all pnc-foundation bundle projects into CQ
#


CURRENT_DIR="$( pwd )"
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"


echo '-------------------------------------------------------------------------------'
echo 'pnc-foundation import bundles into cq'
echo '-------------------------------------------------------------------------------'
echo ''
echo 'auto-deploys all bundles via:'
echo '  mvn -Pauto-deploy install'
echo ''
echo 'pnc-foundation home: ' 
echo '  ' $PRJ_HOME
echo '-------------------------------------------------------------------------------'
echo


echo '-------------------------------------------------------------------------------'
echo 'auto deploying bundles...'
echo '-------------------------------------------------------------------------------'

$PRJ_HOME/scripts/pf-deploy.sh $1 dependencies services security workflows taglib || exit

# back to original directory
cd $CURRENT_DIR
