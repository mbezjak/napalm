#!/bin/bash

setUp() {
  . '../dist/bin/libnapalm'

  tmp=`mktemp -d`
}

tearDown() {
  rm -rf $tmp
}

testListPlugins() {
  mkdir -p $tmp/{global,local}/plugins
  touch $tmp/global/plugins/{a,b}
  touch $tmp/local/plugins/{c,d}

  (NAPALM_HOME=$tmp/global;
   NAPALM_USER_HOME=$tmp/local;
   assertEquals 'Plugins [4]: a b c d' "`list_plugins`")
}

testListPluginsNUHdoesntExist() {
  mkdir -p $tmp/plugins
  touch $tmp/plugins/{a,b}

  (NAPALM_HOME=$tmp;
   NAPALM_USER_HOME=/not/exists;
   assertEquals 'Plugins [2]: a b' "`list_plugins`")
}


. ./shunit2
