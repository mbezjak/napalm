#!/bin/sh

testPrintVersion() {
  ./napalm -v 2> /dev/null
  assertEquals 0 $?
}

testPrintHelp() {
  ./napalm -h 2> /dev/null
  assertEquals 10 $?
}


. ./shunit2
