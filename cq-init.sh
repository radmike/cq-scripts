#!/bin/bash
#
# This script initializes the pnc-foundation projects w/ CQ
#
# Sets vlt credentials, builds the entire parent project (and parent pom),
# and finally, load the foundation dependencies bundle into CQ, which is 
# needed to load a taglib project.
#


CURRENT_DIR="$( pwd )"
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

cqhost='localhost'
cqport=4502
cquser='admin'
cqpassword='admin'

function read_props {
  if [ -e $PRJ_HOME/scripts/$1.properties ]; then
    while read -r line; do eval $line; done <$PRJ_HOME/scripts/$1.properties
  else
    echo 'no environment specific configuration found'
  fi
}

echo 
echo '>>--------------------------------------------------------------------------------'
echo '===== initializing pnc-foundation - vlt credentials, parent project, dependencies'
echo '>>--------------------------------------------------------------------------------'
echo 

# import config to set admin credentials for vlt
$PRJ_HOME/scripts/pf-deploy.sh $1 config || exit


# build parent project - no autodeploy
cd $PRJ_HOME
mvn clean install -P cq -P cqblueprints || exit $ERROR_CODE


# deploy dependencies
$PRJ_HOME/scripts/pf-deploy.sh $1 dependencies || exit

# back to original directory
cd $CURRENT_DIR
