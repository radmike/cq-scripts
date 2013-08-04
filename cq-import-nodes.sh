#!/bin/bash
#
# This script imports all node projects into CQ
#


# Grab the current directory where the script was executed
CURRENT_DIR="$( pwd )"

# Figure out the actual project home
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"


# Start script execution

echo '-------------------------------------------------------------------------------'
echo 'import all node projects into cq'
echo '-------------------------------------------------------------------------------'
echo ''
echo 'imports non-bundled directories via:'
echo '    vlt import -v http://localhost:4502/crx '
echo '        '$PRJ_HOME'/{project-name}-{subproject-name}/src/main/content/jcr_root/YYYYY /'
echo ''
echo 'project home: '
echo '  ' $PRJ_HOME
echo '-------------------------------------------------------------------------------'
echo


echo '-------------------------------------------------------------------------------'
echo 'vault import starting...'
echo '-------------------------------------------------------------------------------'


$PRJ_HOME/scripts/cq-deploy.sh $1 clean-clientlibs config view || exit

# End script execution


# Go back to the original directory
cd $CURRENT_DIR
