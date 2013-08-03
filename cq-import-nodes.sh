#!/bin/bash
#
# This script imports all node projects into CQ
#


CURRENT_DIR="$( pwd )"
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"


echo '-------------------------------------------------------------------------------'
echo 'pnc-foundation import nodes into cq'
echo '-------------------------------------------------------------------------------'
echo ''
echo 'imports non-bundled directories via:'
echo '    vlt import -v http://localhost:4502/crx '
echo '        '$PRJ_HOME'/pnc-foundation-XXXX/src/main/content/jcr_root/YYYYY /'
echo ''
echo 'pnc-foundation home: '
echo '  ' $PRJ_HOME
echo '-------------------------------------------------------------------------------'
echo


echo '-------------------------------------------------------------------------------'
echo 'vault import starting...'
echo '-------------------------------------------------------------------------------'


$PRJ_HOME/scripts/pf-deploy.sh $1 config view || exit


# back to original directory
cd $CURRENT_DIR
