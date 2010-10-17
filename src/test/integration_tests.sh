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


. ./shunit2
