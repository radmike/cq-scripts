#!/bin/bash
#
# This script imports all pnc-foundation sub projects into CQ
#
# see pf-import-nodes.sh and pf-import-bundles.sh 


CURRENT_DIR="$( pwd )"
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

$PRJ_HOME/scripts/pf-import-nodes.sh $1 || exit
$PRJ_HOME/scripts/pf-import-bundles.sh $1 || exit

# back to original directory
cd $CURRENT_DIR
