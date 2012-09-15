#!/bin/bash

setUp() {
  . '../bin/libnapalm'

  NAPALM_USER_HOME=`mktemp -d`
  uh=$NAPALM_USER_HOME # alias to reduce character count
  NAPALM_PROGRAMS_DIR=`mktemp -d`
  pd=$NAPALM_PROGRAMS_DIR # alias to reduce character count
}

tearDown() {
  rm -rf $uh $pd
}

testUninstallProgramNameEmpty() {
  uninstall_program
  assertEquals 1 $?
}

testUninstallNotInstalled() {
  (uninstall_program foo;
   assertEquals 0 $?)
}

testUninstallWithVersionNotInstalled() {
  (uninstall_program foo 1.4;
   assertEquals 0 $?)
}

testUninstallInstalledOne() {
  mkdir -p $pd/foo-1.2
  ln -s $pd/foo-1.2 $pd/foo
  touch $uh/foo.sh

  (uninstall_program foo 1.2;
   assertEquals 0 $?;
   assertFalse "[ -d $pd/foo-1.2 ]";
   assertFalse "[ -f $pd/foo ]";
   assertFalse "[ -f $uh/foo.sh ]")
}


testUninstallAllInstalledOneNoScriptNoLink() {
  mkdir -p $pd/foo-1.2

  (uninstall_program_all foo;
   assertEquals 0 $?;
   assertFalse "[[ -d $pd/foo-1.2 ]]")
}

testUninstallAllInstalledOneNoScript() {
  mkdir -p $pd/foo-1.2
  ln -s $pd/foo-1.2 $pd/foo

  (uninstall_program_all foo;
   assertEquals 0 $?;
   assertFalse "[[ -d $pd/foo-1.2 ]]";
   assertFalse "[[ -f $pd/foo ]]")
}

testUninstallAllInstalledOne() {
  mkdir -p $pd/foo-1.2
  ln -s $pd/foo-1.2 $pd/foo
  touch $uh/foo.sh

  (uninstall_program_all foo;
   assertEquals 0 $?;
   assertFalse "[ -d $pd/foo-1.2 ]";
   assertFalse "[ -f $pd/foo ]";
   assertFalse "[ -f $uh/foo.sh ]")
}

testUninstallAllInstalledThree() {
  mkdir -p $pd/foo-1.{2,7}
  mkdir -p $pd/foo-2.0.1
  ln -s $pd/foo-1.2 $pd/foo
  touch $uh/foo.sh

  (uninstall_program_all foo;
   assertEquals 0 $?;
   assertFalse "[ -d $pd/foo-1.2 ]";
   assertFalse "[ -d $pd/foo-1.7 ]";
   assertFalse "[ -d $pd/foo-2.0.1 ]";
   assertFalse "[ -f $pd/foo ]";
   assertFalse "[ -f $uh/foo.sh ]")
}


testUninstallVersionNotActive() {
  mkdir -p $pd/foo-1.{2,7}
  ln -s $pd/foo-1.7 $pd/foo

  (uninstall_program_version foo 1.2;
   assertEquals 0 $?;
   assertFalse "[ -d $pd/foo-1.2 ]";
   assertTrue  "[ -d $pd/foo-1.7 ]")
}

testUninstallVersionActive() {
  mkdir -p $pd/foo-1.{2,7}
  ln -s $pd/foo-1.7 $pd/foo

  (uninstall_program_version foo 1.7;
   assertEquals 0 $?;
   assertTrue  "[ -d $pd/foo-1.2 ]";
   assertFalse "[ -d $pd/foo-1.7 ]")
}


. shunit2
