#!/bin/sh

setUp() {
  . '../dist/bin/libnapalm'

  NAPALM_PROGRAMS_DIR=`mktemp -d`
  pd=$NAPALM_PROGRAMS_DIR # alias to reduce character count
}

tearDown() {
  rm -rf $pd
}

testLoadPluginNotFound() {
  mkdir -p $pd/{home,user}/plugins

  (NAPALM_HOME=$pd/home;
   NAPALM_USER_HOME=$pd/user;
   load_plugin foo;
   assertEquals 1 $?)
}

testLoadPluginFoundInNUH() {
  mkdir -p $pd/{home,user}/plugins
  cat > $pd/user/plugins/foo << EOF
plugin_was_executed=true
EOF

  (NAPALM_HOME=$pd/home;
   NAPALM_USER_HOME=$pd/user;
   load_plugin foo;
   assertEquals 0 $?;
   assertEquals true $plugin_was_executed)
}

testLoadPluginFoundInNH() {
  mkdir $pd/plugins
  cat > $pd/plugins/foo << EOF
plugin_was_executed=true
EOF

  (NAPALM_HOME=$pd;
   load_plugin foo;
   assertEquals 0 $?;
   assertEquals true $plugin_was_executed)
}

testInstallProgramNameEmpty() {
  install_program
  assertEquals 2 $?
}

testInstallProgramVersionEmpty() {
  install_program foo
  assertEquals 3 $?
}

testInstallProgramPluginNotLoaded() {
  load_plugin() {
    assertEquals foo $1
    assertEquals 1.3 $VERSION
    return 1
  }

  local msg=`install_program foo 1.3; assertEquals 1 $?`
  assertEquals "No plugin: foo" "$msg"
}

testUrlNoArguments() {
  (url;
   assertTrue "[ -z $URL ]")
}

testUrlOneArgument() {
  (url 'http://acme.com';
   assertEquals 'http://acme.com' "$URL")
}

testUrlTwoArguments() {
  (url 'http://acme.com' 'http://example.com';
   assertEquals 'http://acme.com http://example.com' "$URL")
}


. ./shunit2
