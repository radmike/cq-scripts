#!/bin/bash
#
# This script imports all pnc-foundation bundle projects into CQ
#


CURRENT_DIR="$( pwd )"
PRJ_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Project name
PROJECT=pnc-foundation

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

# import
function vlt-import {
  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== vlt-import for '$1
  echo '>>-----------------------------------------------------------------------------'
  echo

  cd $PRJ_HOME
  vlt --credentials $cquser:$cqpassword import -v http://$cqhost:$cqport/crx $1/src/main/content /

  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== vlt-import for '$1' complete'
  echo '>>-----------------------------------------------------------------------------'
  echo
}

# auto-deploy
function auto-deploy {
  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== auto-deploy for '$1
  echo '>>-----------------------------------------------------------------------------'
  echo

  cd $PRJ_HOME/$1

  mvn clean install -P cq -P cqblueprints -Pauto-deploy -Dcq.host=$cqhost -Dcq.port=$cqport -Dcq.user=$cquser -Dcq.password=$cqpassword || exit $ERROR_CODE

  echo
  echo '>>-----------------------------------------------------------------------------'
  echo '===== auto-deploy for '$1' complete'
  echo '>>-----------------------------------------------------------------------------'
  echo
}

echo
echo '>>-----------------------------------------------------------------------------'
echo '===== DEPLOYING FOR PROJECT: ' $PROJECT
echo '>>-----------------------------------------------------------------------------'
echo

for subprj in $*; do

# check for optional env param
# curl --user admin:admin -F":operation=delete" http://localhost:4502/var/clientlibs/etc/designs/$PROJECT/clientlibs

  if [ $subprj = 'config' ]; then
    echo '>>----------------------- cleaning install directory ---------------------'
    curl --user $cquser:$cqpassword -F":operation=delete" http://$cqhost:$cqport/apps/$PROJECT/install > delete.log
  fi
  if [ $subprj = 'view' ]; then
    echo '>>----------------------- clearing clientlibs cache ---------------------'
    curl --user $cquser:$cqpassword -F":operation=delete" http://$cqhost:$cqport/var/clientlibs/etc/designs/$PROJECT/clientlibs > delete.log
  fi
  if [ -e $PRJ_HOME/scripts/$subprj.properties ]; then
    echo
    echo '>>-----------------------------------------------------------------------------'
    echo '===== reading props: ' $subprj.properties
    echo '>>-----------------------------------------------------------------------------'
    echo

    read_props $subprj
  elif [ -d $PRJ_HOME/$PROJECT-$subprj ]; then
    # either nodes or bundle
    # TODO Trap error conditions from vlt
    if [ -d $PRJ_HOME/$PROJECT-$subprj/src/main/content ]; then
      vlt-import $PROJECT-$subprj
    else
      auto-deploy $PROJECT-$subprj
    fi
  else
    echo
    echo '>>-----------------------------------------------------------------------------'
    echo '===== project not found: ' $subprj
    echo '>>-----------------------------------------------------------------------------'
    echo
  fi

done

# back to original directory
cd $CURRENT_DIR
