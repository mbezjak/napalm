#!/bin/sh
#

version=1.5
tar=/tmp/napalm.tar.gz
extract=/tmp/napalm

bootstrap='[[ -f ~/.napalm/profile ]] && source ~/.napalm/profile'
pre15=$(grep --count 'source "$bash_script"' ~/.bashrc)
post15=$(grep --count "$bootstrap" ~/.bashrc)

set -o errexit # not for grep


# Warn about pre 1.5 installations
if [ $pre15 -ne 0 ]; then
  echo WARNING: napalm 1.5 and above requires different bootstrap in '~/.bashrc'
  echo Please remove old boostrap code before continuing. Old boostrap code has
  echo the following form:
  echo '    [[ -d ~/.napalm ]] && {'
  echo '      ...'
  echo '    }'
  echo Depending on if you have modified above bootstrap code, it might look
  echo different. In any case, the end result should be not to import (source)
  echo '~/.napalm/*.sh' files anymore.
  echo It is also advisable to remove any pre 1.5 version of napalm.
  echo Press any key to continue
  read any
  echo
fi


# download and install
rm -rf $tar $extract
mkdir $extract
wget https://github.com/mbezjak/napalm/tarball/$version -O $tar
tar --extract --file $tar --directory $extract

echo '------------------------------------------------'
echo Installing napalm $version
echo
make --directory=$extract/$(ls $extract) install
echo
echo


# Setup bootstrap in ~/.bashrc
if [ $post15 -eq 0 ]; then
  echo napalm 1.5 and above requires one line boostrap in '~/.bashrc':
  echo "    $bootstrap"
  echo Should that line be automatically added to the end of '~/.bashrc (y/n)'?
  read answere
  if [ "$answere" == y ]; then
    echo $bootstrap >> ~/.bashrc
    echo "Added '$bootstrap' to ~/.bashrc"
  else
    echo You should manually add napalm bootstrap to '~/.bashrc':
    echo "    $bootstrap"
  fi
  echo
fi


echo Restart terminal to complete napalm $version installation

exit 0
