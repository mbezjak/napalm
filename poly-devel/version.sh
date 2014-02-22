#!/bin/bash
#

awk -F= '/^NAPALM_VERSION=/{print $2}' bin/napalm
