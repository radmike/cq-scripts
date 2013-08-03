#!/bin/bash
#
# This script imports all sub projects into CQ
#


# Grab the current directory where the script was executed
CURRENT_DIR="$( pwd )"

# Figure out the actual project home
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Import all nodes
$PRJ_HOME/scripts/pf-import-nodes.sh $1 || exit

# Import all bundles
$PRJ_HOME/scripts/pf-import-bundles.sh $1 || exit

# Go back to the original directory
cd $CURRENT_DIR
