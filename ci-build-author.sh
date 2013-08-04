#!/bin/bash
#
# This script allows the CI builder to automatically build all approriate projects to the author instance
#


# Grab the current directory where the script was executed
CURRENT_DIR="$( pwd )"

# Figure out the actual project home
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"


# Start script execution

echo '-------------------------------------------------------------------------------'
echo 'CI deploy to author'
echo '-------------------------------------------------------------------------------'
echo ''
echo 'project home: '
echo '  ' $PRJ_HOME
echo '-------------------------------------------------------------------------------'
echo

$PRJ_HOME/scripts/cq-import-all.sh ci-author || exit

# End script execution


# Go back to the original directory
cd $CURRENT_DIR
