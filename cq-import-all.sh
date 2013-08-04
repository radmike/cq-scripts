#!/bin/bash
#
# This script imports all sub projects into CQ
#


# Grab the current directory where the script was executed
CURRENT_DIR="$( pwd )"

# Figure out the actual project home
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"


# Start script execution

# Import all nodes
$PRJ_HOME/scripts/cq-import-nodes.sh $1 || exit

# Import all bundles
$PRJ_HOME/scripts/cq-import-bundles.sh $1 || exit

# End script execution


# Go back to the original directory
cd $CURRENT_DIR
