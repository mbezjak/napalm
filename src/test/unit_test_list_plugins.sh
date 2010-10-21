#!/bin/sh

setUp() {
  . '../dist/bin/libnapalm'
}

testListPlugins() {
  local tmp=`mktemp -d`
  mkdir -p $tmp/global/plugins
  mkdir -p $tmp/local/plugins
  touch $tmp/global/plugins/a;
  touch $tmp/global/plugins/b;
  touch $tmp/local/plugins/c;
  touch $tmp/local/plugins/d;

  (NAPALM_HOME=$tmp/global;
   NAPALM_USER_HOME=$tmp/local;
   assertEquals 'Plugins[4]: a b c d' "`list_plugins`")

  rm -rf $tmp
}


. ./shunit2
