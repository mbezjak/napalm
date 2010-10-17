#!/bin/sh

testPrintVersion() {
  ../shell/napalm -v 2> /dev/null
  assertEquals 0 $?
}

testPrintHelp() {
  ../shell/napalm -h 2> /dev/null
  assertEquals 10 $?
}


. ../../lib/shunit2/shunit2
