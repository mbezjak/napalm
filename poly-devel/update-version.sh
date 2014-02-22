#!/bin/bash
#

declare -r new="$1"
declare -r old=$(version)
declare -r rev=$(regex-version)

sed -i "s|^NAPALM_VERSION=$rev|NAPALM_VERSION=$new|" bin/napalm
sed -i "s|^version=$rev|version=$new|" install/web-based-install.sh
sed -i "s|\$ napalm replace napalm $old$|\$ napalm replace napalm $new|" README.md
