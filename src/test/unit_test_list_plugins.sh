#!/bin/sh

setUp() {
  . '../dist/bin/libnapalm'
}

testListPlugins() {
  local tmp=`mktemp -d`
  mkdir -p $tmp/global/plugins
  mkdir -p $tmp/local/plugins

  (NAPALM_HOME=$tmp/global;
   NAPALM_USER_HOME=$tmp/local;
   touch ${NAPALM_HOME}/plugins/a;
   touch ${NAPALM_HOME}/plugins/b;
   touch ${NAPALM_USER_HOME}/plugins/c;
   touch ${NAPALM_USER_HOME}/plugins/d;
   assertEquals 'Plugins[4]: a b c d' "`list_plugins`")

  rm -rf $tmp
}


. ./shunit2
