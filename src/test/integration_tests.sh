#!/bin/sh

NAPALM='../dist/bin/napalm'

mkdir user_home
export NAPALM_USER_HOME='user_home'

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
  local tmp=`mktemp -d`
  cp -pR ../dist/* $tmp

  local home=`export NAPALM_HOME=$tmp && $NAPALM -v 2>&1 | awk '/^NAPALM_HOME/{print $3}'`
  rm -rf $tmp

  assertEquals $tmp $home
}


. ./shunit2
