#!/bin/sh

setUp() {
  . '../dist/bin/libnapalm'
}

testShowProgramAllNotInstalled() {
  local tmp=`mktemp -d`

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo 1.3`
   assertEquals 'Not installed: foo 1.3' "$msg")

  rm -rf $tmp
}

testShowProgramAllInstalledNotActive() {
  local tmp=`mktemp -d`
  local prog=${tmp}/foo-1.3
  mkdir -p $prog

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo 1.3`
   assertEquals "   $prog" "$msg")

  rm -rf $tmp
}

testShowProgramAllInstalledNotActive2() {
  local tmp=`mktemp -d`
  local prog=${tmp}/foo-1.3
  mkdir -p $prog
  ln -s /tmp foo

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo 1.3`
   assertEquals "   $prog" "$msg")

  rm -rf $tmp
}

testShowProgramAllInstalledActive() {
  local tmp=`mktemp -d`
  local prog=${tmp}/foo-1.3
  mkdir -p $prog
  ln -s ${prog} ${tmp}/foo

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo 1.3`
   assertEquals " * $prog" "$msg")

  rm -rf $tmp
}

testShowProgramNameNone() {
  local tmp=`mktemp -d`

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo`
   assertEquals "Not installed: foo" "$msg")

  rm -rf $tmp
}

testShowProgramNameNoLink() {
  local tmp=`mktemp -d`
  mkdir -p ${tmp}/foo-1.3
  mkdir -p ${tmp}/foo-1.5

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo`
   local expected=`echo -e "   ${tmp}/foo-1.3\n   ${tmp}/foo-1.5"`
   assertEquals "$expected" "$msg")

  rm -rf $tmp
}

testShowProgramNameLink() {
  local tmp=`mktemp -d`
  mkdir -p ${tmp}/foo-1.3
  mkdir -p ${tmp}/foo-1.5
  ln -s ${tmp}/foo-1.5 ${tmp}/foo

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo`
   local expected=`echo -e "   ${tmp}/foo-1.3\n * ${tmp}/foo-1.5"`
   assertEquals "$expected" "$msg")

  rm -rf $tmp
}

testShowProgramNone() {
  local tmp=`mktemp -d`

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program`
   assertEquals "Nothing installed" "$msg")

  rm -rf $tmp
}

testShowProgramNone() {
  local tmp=`mktemp -d`

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program`
   assertEquals "Nothing installed" "$msg")

  rm -rf $tmp
}

testShowProgramMixed() {
  local tmp=`mktemp -d`
  mkdir -p ${tmp}/foo-1.3
  mkdir -p ${tmp}/foo-1.5
  ln -s ${tmp}/foo-1.5 ${tmp}/foo
  mkdir -p ${tmp}/bar-2.0.1
  ln -s ${tmp}/bar-2.0.1 ${tmp}/bar
  mkdir -p ${tmp}/baz-0.5-rc1

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program`
   local expected=`cat << EOF
 * ${tmp}/bar-2.0.1
   ${tmp}/foo-1.3
 * ${tmp}/foo-1.5
   ${tmp}/baz-0.5-rc1
EOF`
   assertEquals "$expected" "$msg")

  rm -rf $tmp
}


. ./shunit2
