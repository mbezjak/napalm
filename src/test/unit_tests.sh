#!/bin/sh

setUp() {
  . '../dist/bin/libnapalm'
}

testConfigureEnvironmentNUHisAlreadySet() {
  local nuh='/tmp/already/set'

  (export NAPALM_USER_HOME=$nuh;
   configure_environment;
   assertEquals $nuh $NAPALM_USER_HOME;
   assertEquals $nuh/programs $PROGRAMS_DIR)
}

testConfigureEnvironment() {
  local nuh=$HOME/.napalm

  (configure_environment;
   assertEquals $nuh $NAPALM_USER_HOME;
   assertEquals $nuh/programs $PROGRAMS_DIR)
}

testListPlugins() {
  local tmp=`mktemp -d`
  mkdir -p $tmp/global/plugins
  mkdir -p $tmp/local/plugins

  (NAPALM_HOME=$tmp/global;
   NAPALM_USER_HOME=$tmp/local;
   touch ${NAPALM_HOME}/plugins/a;
   touch ${NAPALM_HOME}/plugins/b;
   touch ${NAPALM_USER_HOME}/plugins/c;
   touch ${NAPALM_USER_HOME}/plugins/d;
   assertEquals 'Plugins[4]: a b c d' "`list_plugins`")

  rm -rf $tmp
}

testListPluginsAllNotInstalled() {
  local tmp=`mktemp -d`

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo 1.3`
   assertEquals 'Not installed: foo 1.3' "$msg")

  rm -rf $tmp
}

testListPluginsAllInstalledNotActive() {
  local tmp=`mktemp -d`
  local prog=${tmp}/foo-1.3
  mkdir -p $prog

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo 1.3`
   assertEquals "   $prog" "$msg")

  rm -rf $tmp
}

testListPluginsAllInstalledNotActive2() {
  local tmp=`mktemp -d`
  local prog=${tmp}/foo-1.3
  mkdir -p $prog
  ln -s /tmp foo

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo 1.3`
   assertEquals "   $prog" "$msg")

  rm -rf $tmp
}

testListPluginsAllInstalledActive() {
  local tmp=`mktemp -d`
  local prog=${tmp}/foo-1.3
  mkdir -p $prog
  ln -s ${prog} ${tmp}/foo

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo 1.3`
   assertEquals " * $prog" "$msg")

  rm -rf $tmp
}

testListPluginsNameNone() {
  local tmp=`mktemp -d`

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo`
   assertEquals "Not installed: foo" "$msg")

  rm -rf $tmp
}

testListPluginsNameNoLink() {
  local tmp=`mktemp -d`
  mkdir -p ${tmp}/foo-1.3
  mkdir -p ${tmp}/foo-1.5

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program foo`
   local expected=`echo -e "   ${tmp}/foo-1.3\n   ${tmp}/foo-1.5"`
   assertEquals "$expected" "$msg")

  rm -rf $tmp
}

testListPluginsNameLink() {
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

testListPluginsNone() {
  local tmp=`mktemp -d`

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program`
   assertEquals "Nothing installed" "$msg")

  rm -rf $tmp
}

testListPluginsNone() {
  local tmp=`mktemp -d`

  (PROGRAMS_DIR=$tmp;
   local msg=`show_program`
   assertEquals "Nothing installed" "$msg")

  rm -rf $tmp
}

testListPluginsMixed() {
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
