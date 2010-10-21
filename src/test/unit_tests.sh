#!/bin/sh

setUp() {
  . '../dist/bin/libnapalm'
}

testConfigureEnvironmentNUHisAlreadySet() {
  local _nuh='/tmp/already/set'

  (export NAPALM_USER_HOME=$_nuh;
   configure_environment;
   assertEquals $_nuh $NAPALM_USER_HOME;
   assertEquals $_nuh/programs $PROGRAMS_DIR)
}

testConfigureEnvironment() {
  local _nuh=$HOME/.napalm

  (configure_environment;
   assertEquals $_nuh $NAPALM_USER_HOME;
   assertEquals $_nuh/programs $PROGRAMS_DIR)
}

testListPlugins() {
  local _tmp=`mktemp -d`
  mkdir -p $_tmp/global/plugins
  mkdir -p $_tmp/local/plugins

  (NAPALM_HOME=$_tmp/global;
   NAPALM_USER_HOME=$_tmp/local;
   touch ${NAPALM_HOME}/plugins/a;
   touch ${NAPALM_HOME}/plugins/b;
   touch ${NAPALM_USER_HOME}/plugins/c;
   touch ${NAPALM_USER_HOME}/plugins/d;
   assertEquals 'Plugins[4]: a b c d' "`list_plugins`")

  rm -rf $_tmp
}

testListPluginsAllNotInstalled() {
  local _tmp=`mktemp -d`

  (PROGRAMS_DIR=$_tmp;
   local _msg=`show_program foo 1.3`
   assertEquals 'Not installed: foo 1.3' "$_msg")

  rm -rf $_tmp
}

testListPluginsAllInstalledNotActive() {
  local _tmp=`mktemp -d`
  local _prog=${_tmp}/foo-1.3
  mkdir -p $_prog

  (PROGRAMS_DIR=$_tmp;
   local _msg=`show_program foo 1.3`
   assertEquals "   $_prog" "$_msg")

  rm -rf $_tmp
}

testListPluginsAllInstalledNotActive2() {
  local _tmp=`mktemp -d`
  local _prog=${_tmp}/foo-1.3
  mkdir -p $_prog
  ln -s /tmp foo

  (PROGRAMS_DIR=$_tmp;
   local _msg=`show_program foo 1.3`
   assertEquals "   $_prog" "$_msg")

  rm -rf $_tmp
}

testListPluginsAllInstalledActive() {
  local _tmp=`mktemp -d`
  local _prog=${_tmp}/foo-1.3
  mkdir -p $_prog
  ln -s ${_prog} ${_tmp}/foo

  (PROGRAMS_DIR=$_tmp;
   local _msg=`show_program foo 1.3`
   assertEquals " * $_prog" "$_msg")

  rm -rf $_tmp
}

testListPluginsNameNone() {
  local _tmp=`mktemp -d`

  (PROGRAMS_DIR=$_tmp;
   local _msg=`show_program foo`
   assertEquals "Not installed: foo" "$_msg")

  rm -rf $_tmp
}

testListPluginsNameNoLink() {
  local _tmp=`mktemp -d`
  mkdir -p ${_tmp}/foo-1.3
  mkdir -p ${_tmp}/foo-1.5

  (PROGRAMS_DIR=$_tmp;
   local _msg=`show_program foo`
   local _expected=`echo -e "   ${_tmp}/foo-1.3\n   ${_tmp}/foo-1.5"`
   assertEquals "$_expected" "$_msg")

  rm -rf $_tmp
}

testListPluginsNameLink() {
  local _tmp=`mktemp -d`
  mkdir -p ${_tmp}/foo-1.3
  mkdir -p ${_tmp}/foo-1.5
  ln -s ${_tmp}/foo-1.5 ${_tmp}/foo

  (PROGRAMS_DIR=$_tmp;
   local _msg=`show_program foo`
   local _expected=`echo -e "   ${_tmp}/foo-1.3\n * ${_tmp}/foo-1.5"`
   assertEquals "$_expected" "$_msg")

  rm -rf $_tmp
}

testListPluginsNone() {
  local _tmp=`mktemp -d`

  (PROGRAMS_DIR=$_tmp;
   local _msg=`show_program`
   assertEquals "Nothing installed" "$_msg")

  rm -rf $_tmp
}

testListPluginsNone() {
  local _tmp=`mktemp -d`

  (PROGRAMS_DIR=$_tmp;
   local _msg=`show_program`
   assertEquals "Nothing installed" "$_msg")

  rm -rf $_tmp
}

testListPluginsMixed() {
  local _tmp=`mktemp -d`
  mkdir -p ${_tmp}/foo-1.3
  mkdir -p ${_tmp}/foo-1.5
  ln -s ${_tmp}/foo-1.5 ${_tmp}/foo
  mkdir -p ${_tmp}/bar-2.0.1
  ln -s ${_tmp}/bar-2.0.1 ${_tmp}/bar
  mkdir -p ${_tmp}/baz-0.5-rc1

  (PROGRAMS_DIR=$_tmp;
   local _msg=`show_program`
   local _expected=`cat << EOF
 * ${_tmp}/bar-2.0.1
   ${_tmp}/foo-1.3
 * ${_tmp}/foo-1.5
   ${_tmp}/baz-0.5-rc1
EOF`
   assertEquals "$_expected" "$_msg")

  rm -rf $_tmp
}


. ./shunit2
