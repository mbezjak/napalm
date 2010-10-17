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


. ./shunit2
