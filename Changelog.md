# 1.11.6 [2015-12-02]
 * Remove dead codehaus links

# 1.11.5 [2015-10-13]
 * $HOME/.napalm can be a symlink

# 1.11.4 [2015-10-06]
 * New URL and logic for sbt. Compatible with sbt 0.13.9.

# 1.11.3 [2015-07-28]
 * new URL for groovy 2.4.4

# 1.11.2 [2015-07-19]
 * plugin pride: alternative (tar.gz) URL

# 1.11.1 [2015-07-17]
 * plugin pride: alternative (zip) URL

# 1.11 [2015-07-16]
 * new plugin: pride (https://github.com/prezi/pride)

# 1.10.1 [2015-06-19]
 * Fix sbt plugin. Now works again for 0.13.8.

# 1.10 [2015-04-30]
 * New URL for maven. Compatible with maven 3.3.3.

# 1.9 [2015-01-30]
 * new plugin: activator (https://typesafe.com/get-started)

# 1.8.3 [2015-01-08]
 * New URL for grails. Compatible with old grails (version<=1.3.4).

# 1.8.2 [2014-03-15]
 * New URL for groovy. Compatible with groovy 2.2.2.

# 1.8.1.2 [2014-02-22]
 * no source changes
 * `web-based-install.sh`: add `-y` argument to install non-interactively

# 1.8.1.1 [2014-02-22]
 * no source changes
 * automate the release process via `release.sh`

# 1.8.1 [2014-02-09]
 * rename a plugin to `polydevel`
   by the documentation, it must not contain a dash character

# 1.8 [2014-02-08]
 * new plugin: poly-devel (https://github.com/mbezjak/poly-devel)

# 1.7.2 [2013-11-06]
 * New URL for scala. Compatible with scala 2.10.3.

# 1.7.1 [2013-11-06]
 * New URL for griffon. Compatible with griffon 1.4.0.

# 1.7 [2013-02-06]
 * New url for playframework. Compatible with playframework 2.1.0.

# 1.6.3 [2013-01-23]
 * `web-based-install.sh': POSIX compatibility (use `printf' instead of `echo -e')

# 1.6.2 [2012-12-19]
 * `web-based-install.sh`: /bin/sh compatibility

# 1.6.1 [2012-11-15]
 * fix: forward cmd args to play command

# 1.6 [2012-11-15]
 * add playframework plugin

# From version 1.6 `Changelog.md` is back
Turns out I don't like to sift through github issues to find out what's new.
This file communicates much better new features/fixes.

# From version 1.3 watch github issues for changelog
https://github.com/mbezjak/napalm/issues

# 2011-08-08, Version: 1.2
 * add plugins groovyserv, scala, clojure, gosu, dbvisualizer
 * plugins can declare `build` function in order to perform arbitrary work
 during installation (look into README.md for more documentation)
 * various documentation improvements

# 2011-07-19, Version: 1.1
 * document where screenshots are located
 * various documentation improvements
 * add support for tomcat7

# 2011-07-06, Version: 1.0
 * documentation improvements
 * add support to extract `tgz` files
 * update griffon url (use `tgz` instead of `tar.gz`)

# 2011-06-20, Version: 0.8
 * `sudo make install` also installs: README.md, Changelog.md and LICENSE

# 2011-06-19, Version: 0.7
 * napalm can now be used without installing via `sudo make install`
 * elaborated install guide regarding downloading napalm
 * added upgrade section in documentation
 * other minor documentation cleanups

# 2011-02-22, Version: 0.6
 * show command sorts output

# 2011-02-21, Version: 0.5
 * set M2_HOME instead of MAVEN_HOME
 * added .bashrc snippet that includes any *.sh files in NAPALM_USER_HOME
 * described exposed napalm functions that can be used by plugins
 * minor documentation cleanups

# 2011-02-20, Version: 0.4
 * minor documentation cleanups
 * allow plugins to generate program.sh files in NAPALM_USER_HOME.
   They define PROGRAM_HOME envoriment variable and alter PATH.

# 2011-02-20, Version: 0.3
 * fixed bug in download_program. Specifying multiple urls in plugins is now
   respected by napalm.
 * fixed problem when environment variables are already set
 * napalm -h now shows value of NAPALM_PROGRAMS_DIR variable
 * described security in documentation
 * enhanced development documentation
 * described uninstall in documentation
 * described how to use napalm in documentation
 * other minor documentation cleanups

# 2011-02-17, Version: 0.2
 * added griffon plugin
 * fixed setting of directory name in NAPALM_HOME/programs.
   plugin_name-version scheme is now used
 * fixed redirection bug. Errors should be redirected to stderr. Instead a file
   named '1' was created by mistake in current working directory.
 * fixed install target in Makefile. It no longer depends on dist.

# 2011-02-16, Version: 0.1
 * initial public release
