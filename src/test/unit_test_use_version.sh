#!/bin/sh

setUp() {
  . '../dist/bin/libnapalm'

  NAPALM_PROGRAMS_DIR=`mktemp -d`
  pd=$NAPALM_PROGRAMS_DIR # alias to reduce character count
}

tearDown() {
  rm -rf $pd
}

testUseProgramNameEmpty() {
  use_program
  assertEquals 2 $?
}

testUseProgramVersionEmpty() {
  use_program foo
  assertEquals 3 $?
}

testUseProgramProgramsDirDoesntExist() {
  NAPALM_PROGRAMS_DIR='/non/existent'
  local msg=`use_program foo 1.3; assertEquals 1 $?`
  assertEquals "Not installed: foo 1.3" "$msg"
}

testUseProgramNotInstalled() {
  local msg=`use_program foo 1.3; assertEquals 1 $?`
  assertEquals "Not installed: foo 1.3" "$msg"
}

testUseProgramNotInstalledInstalledOne() {
  mkdir $pd/foo-1.3

  local msg=`use_program foo 1.5; assertEquals 1 $?`
  assertEquals "Not installed: foo 1.5" "$msg"
}

testUseProgramNoLink() {
  mkdir $pd/foo-1.3

  local expected=" * $pd/foo-1.3"
  local msg=`use_program foo 1.3; assertEquals 0 $?`
  assertEquals "$expected" "$msg"
  assertTrue "[ -L $pd/foo ]"
  assertEquals "$pd/foo-1.3" `readlink -f $pd/foo`
}

testUseProgramBrokenLink() {
  mkdir $pd/foo-1.3
  ln -s /non/existent $pd/foo

  local expected=" * $pd/foo-1.3"
  local msg=`use_program foo 1.3; assertEquals 0 $?`
  assertEquals "$expected" "$msg"
  assertTrue "[ -L $pd/foo ]"
  assertEquals "$pd/foo-1.3" `readlink -f $pd/foo`
}

testUseProgramLinkAlreadySet() {
  mkdir $pd/foo-1.3
  ln -s $pd/foo-1.3 $pd/foo

  local expected=" * $pd/foo-1.3"
  local msg=`use_program foo 1.3; assertEquals 0 $?`
  assertEquals "$expected" "$msg"
  assertTrue "[ -L $pd/foo ]"
  assertEquals "$pd/foo-1.3" `readlink -f $pd/foo`
}

testUseProgramLinkSetToOldVersion() {
  mkdir $pd/foo-1.{3,5}
  ln -s $pd/foo-1.3 $pd/foo

  local msg=`use_program foo 1.5; assertEquals 0 $?`
  local expected=`echo -e "   $pd/foo-1.3\n * $pd/foo-1.5"`
  assertEquals "$expected" "$msg"
  assertTrue "[ -L $pd/foo ]"
  assertEquals "$pd/foo-1.5" `readlink -f $pd/foo`
}


. ./shunit2
