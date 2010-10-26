#!/bin/sh

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


. ./shunit2
