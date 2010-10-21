#!/bin/sh

setUp() {
  . '../dist/bin/libnapalm'

  NAPALM_PROGRAMS_DIR=`mktemp -d`
  pd=$NAPALM_PROGRAMS_DIR # alias to reduce character count
}

tearDown() {
  rm -rf $pd
}

testShowProgramAllNotInstalled() {
   local msg=`show_program foo 1.3`
   assertEquals 'Not installed: foo 1.3' "$msg"
}

testShowProgramAllInstalledNotActive() {
  local prog=$pd/foo-1.3
  mkdir -p $prog

  local msg=`show_program foo 1.3`
  assertEquals "   $prog" "$msg"
}

testShowProgramAllInstalledNotActive2() {
  local prog=$pd/foo-1.3
  mkdir -p $prog
  ln -s /tmp foo

  local msg=`show_program foo 1.3`
  assertEquals "   $prog" "$msg"
}

testShowProgramAllInstalledActive() {
  local prog=$pd/foo-1.3
  mkdir -p $prog
  ln -s ${prog} $pd/foo

  local msg=`show_program foo 1.3`
  assertEquals " * $prog" "$msg"
}

testShowProgramNameNone() {
  local msg=`show_program foo`
  assertEquals "Not installed: foo" "$msg"
}

testShowProgramNameNoLink() {
  mkdir -p $pd/foo-1.3
  mkdir -p $pd/foo-1.5

  local msg=`show_program foo`
  local expected=`echo -e "   $pd/foo-1.3\n   $pd/foo-1.5"`
  assertEquals "$expected" "$msg"
}

testShowProgramNameLink() {
  mkdir -p $pd/foo-1.3
  mkdir -p $pd/foo-1.5
  ln -s $pd/foo-1.5 $pd/foo

  local msg=`show_program foo`
  local expected=`echo -e "   $pd/foo-1.3\n * $pd/foo-1.5"`
  assertEquals "$expected" "$msg"
}

testShowProgramNone() {
  local msg=`show_program`
  assertEquals "Nothing installed" "$msg"
}

testShowProgramNone() {
  local msg=`show_program`
  assertEquals "Nothing installed" "$msg"
}

testShowProgramMixed() {
  mkdir -p $pd/foo-1.3
  mkdir -p $pd/foo-1.5
  ln -s $pd/foo-1.5 $pd/foo
  mkdir -p $pd/bar-2.0.1
  ln -s $pd/bar-2.0.1 $pd/bar
  mkdir -p $pd/baz-0.5-rc1

  local msg=`show_program`
  local expected=`cat << EOF
 * $pd/bar-2.0.1
   $pd/foo-1.3
 * $pd/foo-1.5
   $pd/baz-0.5-rc1
EOF`
  assertEquals "$expected" "$msg"
}


. ./shunit2
