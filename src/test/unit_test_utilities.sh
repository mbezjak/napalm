#!/bin/bash

setUp() {
  . '../dist/bin/libnapalm'
}

testResolveVersionFromPathOnlyBasenameIsConsidered() {
  local path="/an/absolute/path/but/only/basename/is/considered/foo-1.3"
  assertEquals "1.3" `resolve_version_from_path $path`
}

testResolveVersionFromPathComplexVersion() {
  local path="foo-2.1-b1"
  assertEquals "2.1-b1" `resolve_version_from_path $path`
}

testResolveVersionFromPathComplexVersion2() {
  local path="foo-2.1.5_b23-rc1"
  assertEquals "2.1.5_b23-rc1" `resolve_version_from_path $path`
}

testResolveVersionFromPathEverythingAfterFirstDashIsAVersion() {
  local path="foo-bar-3.1"
  assertEquals "bar-3.1" `resolve_version_from_path $path`
}


testResolveProgramNameFromPathOnlyBasenameIsConsidered() {
  local path="/an/absolute/path/but/only/basename/is/considered/foo-1.3"
  assertEquals "foo" `resolve_program_name_from_path $path`
}

testResolveProgramNameFromPathComplexName() {
  local path="foo_bar-2.1-b1"
  assertEquals "foo_bar" `resolve_program_name_from_path $path`
}


testConstructPathNoVersion() {
  (NAPALM_PROGRAMS_DIR="/tmp";
   assertEquals "/tmp/foo" `construct_path foo`)
}

testConstructPathWithVersion() {
  (NAPALM_PROGRAMS_DIR="/tmp";
   assertEquals "/tmp/foo-1.3" `construct_path foo 1.3`)
}


testHandleNotInstalledNoVersion() {
  assertEquals "Not installed: foo" "`handle_not_installed foo 2>&1`"
}

testHandleNotInstalledWithVersion() {
  assertEquals "Not installed: foo 1.3" "`handle_not_installed foo 1.3 2>&1`"
}


. ./shunit2
