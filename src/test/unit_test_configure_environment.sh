#!/bin/sh

setUp() {
  . '../dist/bin/libnapalm'
}

testConfigureEnvironmentNUHisAlreadySet() {
  local nuh='/tmp/already/set'

  (export NAPALM_USER_HOME=$nuh;
   configure_environment;
   assertEquals $nuh $NAPALM_USER_HOME;
   assertEquals $nuh/programs $PROGRAMS_DIR)
}

testConfigureEnvironment() {
  local nuh=$HOME/.napalm

  (configure_environment;
   assertEquals $nuh $NAPALM_USER_HOME;
   assertEquals $nuh/programs $PROGRAMS_DIR)
}


. ./shunit2
