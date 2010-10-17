#!/bin/sh

NAPALM='../dist/bin/napalm'

testPrintVersion() {
  $NAPALM -v 2> /dev/null
  assertEquals 0 $?
}

testPrintHelp() {
  $NAPALM -h 2> /dev/null
  assertEquals 10 $?
}

testIllegalArgument() {
  # -i is not a recognized argument
  $NAPALM -i 2> /dev/null
  assertEquals 10 $?
}

testNapalmHomeCanBeAssigned() {
  local _tmp=`mktemp -d`
  cp -pR ../dist $_tmp

  local _home=`export NAPALM_HOME=$_tmp && $NAPALM -v 2>&1 | awk '/^NAPALM_HOME/{print $3}'`
  rm -rf $_tmp

  assertEquals $_tmp $_home
}


. ./shunit2
