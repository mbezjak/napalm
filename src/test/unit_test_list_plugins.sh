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
   assertEquals 'Plugins [4]: a b c d' "`list_plugins`")

  rm -rf $tmp
}

testListPluginsNUHdoesntExist() {
  local tmp=`mktemp -d`
  mkdir -p $tmp/plugins
  touch $tmp/plugins/a;
  touch $tmp/plugins/b;

  (NAPALM_HOME=$tmp;
   NAPALM_USER_HOME=/not/exists;
   assertEquals 'Plugins [2]: a b' "`list_plugins`")

  rm -rf $tmp
}


. ./shunit2
