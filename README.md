napalm
======
Not a real package manager

## NOTICE
napalm is still being developed. I'm writing documentation first. Source code
should follow soon after. Stay tuned.

Summary
=======
Automate installation of archived (zip, gz, bz2) programs that are unsuited or
unavailable from a package repository.

Rationale
=========
Linux package management is great! However, sometimes you need a program that is
really simple to install but

 * it's not available in any repository
 * an older version is in a repository
 * repository policy restricts updating to newer version therefor you need to
   wait for new distribution release (Ubuntu has such policy)
 * you need both older and newer versions of a program
 * depends upon a program/library that you don't want (e.g. *java-1.5.0-gcj*;
   I'm looking at you Fedora!)

In any case you will need to install those programs manually. Manual
installation is always boring and includes numerous steps. For example,
installing/updating groovy includes

 1. opening web browser
 2. navigating to http://groovy.codehaus.org/
 3. finding a download link
 4. downloading latest binary release
 5. extracting zip
 6. opening $HOME/.bashrc
 7. setting GROOVY_HOME variable
 8. updating PATH variable

It's not a problem if you need to install one program this way. It, however,
becomes tiresome if you need to repeat the same process for two or more
programs. Not to mention that you will need to write separate scripts to setup
*_HOME variables if you need two different version of the same program.

napalm is designed as an automation tool to help you download, extract archive
and setup environment variables quicker.

Example
=======

    # install grails
    $ napalm install grails 1.2.5

    # install another version
    $ napalm install grails 1.3.5

    # switch between two versions
    $ napalm use grails

Install
=======
First download latest napalm release and extract contents.

    $ make
    $ sudo make install

Required dependencies
=====================
napalm is written as a bash script therefor executing in in any linux
distribution shouldn't be a problem. However, make sure that `wget` and `unzip`
are installed. Some distributions don't install them by default.

Development documentation
=========================
napalm supports installing projects via plugins. A plugin is written as a very
simple bash script. Plugin's job is to describe how to download a project. Take
a look at plugins directory for examples how to write napalm plugin.

License
=======
Project uses MIT license. Check LICENSE file for more info.
