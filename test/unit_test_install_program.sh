#!/bin/bash

setUp() {
  . '../bin/libnapalm'

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

testCreateAndChangeToTempDirectory() {
  (mktemp() {
    assertEquals '-d' $1
    assertEquals '/tmp/napalm.XXXXXXXXX' $2
    echo $pd
   }; create_and_change_to_temp_directory;
   assertEquals $PWD $pd)
}

testDownloadProgramWgetFailsToDownloadAnything() {
  (wget() {
    return 1
   }; download_program 'http://foo.com http://bar.com';
   assertEquals 1 $?)
}

testDownloadProgramWgetSucceedsOnSecondTry() {
  (local try=0;
   wget() {
    let try="$try + 1"
    [[ $try -eq 1 ]] && return 1 || return 0
   }; download_program 'http://foo.com http://bar.com';
   assertEquals 2 $try
   assertEquals 0 $?)
}

testDownloadProgramWgetSucceedsOnFirstTry() {
  (wget() {
    return 0
   }; download_program 'http://foo.com http://bar.com';
   assertEquals 0 $?)
}

testExtractProgramUnknownExtension() {
  (cd $pd;
   extract_program 'example.7z' extracted;
   assertEquals 1 $?;
   assertTrue "[ -d extracted ]")
}

testExtractProgramExtensionTarGz() {
  (cd $pd;
   tar() {
    assertEquals "--gzip" $1
    assertEquals "--directory" $2
    assertEquals "extracted" $3
    assertEquals "-xf" $4
    assertEquals "example.tar.gz" $5
    return 0
   };
   extract_program 'example.tar.gz' extracted;
   assertEquals 0 $?;
   assertTrue "[ -d extracted ]")
}

testExtractProgramExtensionTgz() {
  (cd $pd;
   tar() {
    assertEquals "--gzip" $1
    assertEquals "--directory" $2
    assertEquals "extracted" $3
    assertEquals "-xf" $4
    assertEquals "example.tgz" $5
    return 0
   };
   extract_program 'example.tgz' extracted;
   assertEquals 0 $?;
   assertTrue "[ -d extracted ]")
}

testExtractProgramExtensionTarBz2() {
  (cd $pd;
   tar() {
    assertEquals "--bzip2" $1
    assertEquals "--directory" $2
    assertEquals "extracted" $3
    assertEquals "-xf" $4
    assertEquals "example.tar.bz2" $5
    return 0
   };
   extract_program 'example.tar.bz2' extracted;
   assertEquals 0 $?;
   assertTrue "[ -d extracted ]")
}

testExtractProgramExtensionZip() {
  (cd $pd;
   unzip() {
    assertEquals "-q" $1
    assertEquals "example.zip" $2
    assertEquals "-d" $3
    assertEquals "extracted" $4
    return 0
   };
   extract_program 'example.zip' extracted;
   assertEquals 0 $?;
   assertTrue "[ -d extracted ]")
}

testExtractProgramExtensionJar() {
  (cd $pd;
   cp() {
    assertEquals "example.jar" $1
    assertEquals "extracted/example.jar" $2
    return 0
   };
   extract_program 'example.jar' extracted;
   assertEquals 0 $?;
   assertTrue "[ -d extracted ]")
}

testInstallProgramNameEmpty() {
  install_program
  assertEquals 5 $?
}

testInstallProgramVersionEmpty() {
  install_program foo
  assertEquals 6 $?
}

testInstallProgramPluginNotLoaded() {
  load_plugin() {
    assertEquals foo $1
    assertEquals 1.3 $VERSION
    return 1
  }

  local msg=`install_program foo 1.3 2>&1; assertEquals 1 $?`
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


. shunit2
