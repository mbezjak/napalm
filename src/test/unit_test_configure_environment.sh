#!/bin/sh

setUp() {
  . '../dist/bin/libnapalm'
}

testConfigureEnvironmentNUHisAlreadySet() {
  local nuh='/already/set'

  (export NAPALM_USER_HOME=$nuh;
   configure_environment;
   assertEquals $nuh $NAPALM_USER_HOME)
}

testConfigureEnvironmentProgramDirIsAlreadySet() {
  local pd='/already/set'

  (export NAPALM_PROGRAMS_DIR=$pd;
   configure_environment;
   assertEquals $pd $NAPALM_PROGRAMS_DIR)
}

testConfigureEnvironment() {
  local nuh=$HOME/.napalm

  (configure_environment;
   assertEquals $nuh $NAPALM_USER_HOME;
   assertEquals $nuh/programs $NAPALM_PROGRAMS_DIR)
}


. ./shunit2
