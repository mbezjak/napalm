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
  local another_home=`mktemp -d`
  cp -pR ../dist/* "$another_home"

  local detected_home=`export NAPALM_HOME="$another_home" && $NAPALM -v 2>&1 | awk '/^NAPALM_HOME/{print $3}'`
  assertEquals "$another_home" "$detected_home"

  rm -rf "$another_home"
}


. ./shunit2
