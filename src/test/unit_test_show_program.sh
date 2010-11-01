#!/bin/sh

setUp() {
  . '../dist/bin/libnapalm'

  NAPALM_PROGRAMS_DIR=`mktemp -d`
  pd=$NAPALM_PROGRAMS_DIR # alias to reduce character count
}

tearDown() {
  rm -rf $pd
}

testShowProgramWithNameAndVersionNotInstalled() {
  local msg=`show_program_with_name_and_version foo 1.3`
  assertEquals 'Not installed: foo 1.3' "$msg"
}

testShowProgramWithNameAndVersionInstalledButNotActive() {
  local prog=$pd/foo-1.3
  mkdir -p $prog

  local msg=`show_program_with_name_and_version foo 1.3`
  assertEquals "   $prog" "$msg"
}

testShowProgramWithNameAndVersionInstalledButNotActive2() {
  local prog=$pd/foo-1.3
  mkdir -p $prog
  ln -s /tmp $pd/foo

  local msg=`show_program_with_name_and_version foo 1.3`
  assertEquals "   $prog" "$msg"
}

testShowProgramWithNameAndVersionInstalledAndActive() {
  local prog=$pd/foo-1.3
  mkdir -p $prog
  ln -s ${prog} $pd/foo

  local msg=`show_program_with_name_and_version foo 1.3`
  assertEquals " * $prog" "$msg"
}


testShowProgramWithNameNone() {
  local msg=`show_program_with_name foo`
  assertEquals "Not installed: foo" "$msg"
}

testShowProgramWithNameNonExistentDirectory() {
  NAPALM_PROGRAMS_DIR='/non/existent'
  local msg=`show_program_with_name foo`
  assertEquals "Not installed: foo" "$msg"
}

testShowProgramWithNameNoLink() {
  mkdir -p $pd/foo-1.3
  mkdir -p $pd/foo-1.5

  local msg=`show_program_with_name foo`
  local expected=`echo -e "   $pd/foo-1.3\n   $pd/foo-1.5"`
  assertEquals "$expected" "$msg"
}

testShowProgramWithNameLink() {
  mkdir -p $pd/foo-1.3
  mkdir -p $pd/foo-1.5
  ln -s $pd/foo-1.5 $pd/foo

  local msg=`show_program_with_name foo`
  local expected=`echo -e "   $pd/foo-1.3\n * $pd/foo-1.5"`
  assertEquals "$expected" "$msg"
}

testShowProgramWithNameMorePrograms() {
  mkdir -p $pd/foo-1.3
  mkdir -p $pd/bar-2.1
  mkdir -p $pd/bar-2.2-b5

  local msg=`show_program_with_name foo`
  assertEquals "   $pd/foo-1.3" "$msg"
}


testShowProgramAll() {
  local msg=`show_program_all`
  assertEquals "Nothing installed" "$msg"
}

testShowProgramAllNonExistentDirectory() {
  NAPALM_PROGRAMS_DIR='/non/existent'
  local msg=`show_program_all`
  assertEquals "Nothing installed" "$msg"
}

testShowProgramAllMixed() {
  mkdir -p $pd/foo-1.3
  mkdir -p $pd/foo-1.5
  ln -s $pd/foo-1.5 $pd/foo
  mkdir -p $pd/bar-2.0.1
  ln -s $pd/bar-2.0.1 $pd/bar
  mkdir -p $pd/baz-0.5-rc1

  local msg=`show_program_all`
  local expected=`cat << EOF
 * $pd/bar-2.0.1
   $pd/foo-1.3
 * $pd/foo-1.5
   $pd/baz-0.5-rc1
EOF`
  assertEquals "$expected" "$msg"
}


testShowProgramArgumentsNameAndVersion() {
  local msg=`show_program foo 1.3`
  assertEquals "Not installed: foo 1.3" "$msg"
}

testShowProgramArgumentName() {
  local msg=`show_program foo`
  assertEquals "Not installed: foo" "$msg"
}

testShowProgramNoArguments() {
  local msg=`show_program`
  assertEquals "Nothing installed" "$msg"
}


. ./shunit2
