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

testRemoveNotInstalled() {
  (uninstall_program foo;
   assertEquals 0 $?)
}

testRemoveInstalledOneNoScriptNoLink() {
  mkdir -p $pd/foo-1.2

  (uninstall_program foo;
   assertEquals 0 $?;
   assertFalse "[[ -d $pd/foo-1.2 ]]")
}

testRemoveInstalledOneNoScript() {
  mkdir -p $pd/foo-1.2
  ln -s $pd/foo-1.2 $pd/foo

  (uninstall_program foo;
   assertEquals 0 $?;
   assertFalse "[[ -d $pd/foo-1.2 ]]";
   assertFalse "[[ -f $pd/foo ]]")
}

testRemoveInstalledOne() {
  mkdir -p $pd/foo-1.2
  ln -s $pd/foo-1.2 $pd/foo
  touch $uh/foo.sh

  (uninstall_program foo;
   assertEquals 0 $?;
   assertFalse "[ -d $pd/foo-1.2 ]";
   assertFalse "[ -f $pd/foo ]";
   assertFalse "[ -f $uh/foo.sh ]")
}

testRemoveInstalledThree() {
  mkdir -p $pd/foo-1.{2,7}
  mkdir -p $pd/foo-2.0.1
  ln -s $pd/foo-1.2 $pd/foo
  touch $uh/foo.sh

  (uninstall_program foo;
   assertEquals 0 $?;
   assertFalse "[ -d $pd/foo-1.2 ]";
   assertFalse "[ -d $pd/foo-1.7 ]";
   assertFalse "[ -d $pd/foo-2.0.1 ]";
   assertFalse "[ -f $pd/foo ]";
   assertFalse "[ -f $uh/foo.sh ]")
}


. shunit2
