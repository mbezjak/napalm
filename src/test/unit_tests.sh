#!/bin/sh

setUp() {
  . '../dist/lib/libnapalm'
}

testConfigureEnvironmentNUHisAlreadySet() {
  local _nuh='/tmp/already/set'

  (export NAPALM_USER_HOME=$_nuh;
   configure_environment;
   assertEquals $_nuh $NAPALM_USER_HOME)
}

testConfigureEnvironment() {
  (configure_environment;
   assertEquals $HOME/.napalm $NAPALM_USER_HOME)
}

testListPlugins() {
  local _tmp=`mktemp -d`
  mkdir -p $_tmp/global/plugins
  mkdir -p $_tmp/local/plugins

  (NAPALM_HOME=$_tmp/global;
   NAPALM_USER_HOME=$_tmp/local;
   touch ${NAPALM_HOME}/plugins/a;
   touch ${NAPALM_HOME}/plugins/b;
   touch ${NAPALM_USER_HOME}/plugins/c;
   touch ${NAPALM_USER_HOME}/plugins/d;
   local _list=`list_plugins`
   assertEquals 'Plugins[4]: a b c d' "$_list")

  rm -rf $_tmp
}

. ./shunit2
