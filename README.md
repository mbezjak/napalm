# napalm
Not a real package manager

## Summary
Automate installation of archived (zip, gz, bz2) programs that are unsuited or
unavailable from a package repository.

## Rationale
Linux package management is great! However, sometimes you need a program that is
really simple to install but

 * it's not available in any repository
 * an older version is in a repository
 * repository policy restricts updating to newer version therefore you need to
   wait for new distribution release (Ubuntu has such policy)
 * you need both older and newer versions of a program
 * depends upon a program/library that you don't want (e.g. *java-1.5.0-gcj*;
   I'm looking at you Fedora!)

In any case you will need to install those programs manually. Manual
installation is always boring and includes numerous steps. For example,
installing groovy includes

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

A word of caution. Do not abuse napalm! Use package management anywhere you
can. napalm isn't a replacement in any way.

## Example

    # install grails
    $ napalm install grails 1.2.5

    # install another version
    $ napalm install grails 1.3.5

    # switch between two versions
    $ napalm use grails 1.2.5

    # list all installed programs
    $ napalm show

    # list all versions of grails
    $ napalm show grails

    # list all available plugins
    $ napalm list-plugins

## Install
First download latest napalm release and extract contents.

    $ make
    $ sudo make install

## Required dependencies
napalm is written as a bash script therefore executing in any linux distribution
shouldn't be a problem. However, make sure that `wget` and `unzip` are
installed. Some distributions don't install them by default.

## Configuration
These environment variables can be set to alter behavior of napalm.

 * NAPALM_HOME - points to where napalm is installed
 * NAPALM_USER_HOME - points to a hidden directory in user's home directory
   (defaults to $HOME/.napalm)
 * NAPALM_PROGRAMS_DIR - points to a directory where programs will be installed
   (defaults to $NAPALM_USER_HOME/programs)

Here is an example of configuring napalm to use different programs directory.
Snippet from $HOME/.bashrc:

    export NAPALM_PROGRAMS_DIR="$HOME/lib/napalm"

## Development documentation
napalm supports installing projects via plugins. A plugin is written as a very
simple bash script. Plugin's job is to describe how to download a project. Take
a look at plugins directory for examples how to write napalm plugin.

### Limitations

 * project and plugin name must be one and the same

 * plugin name cannot contain a dash (`-`) character in it's name. For example,
   you cannot name a plugin `foo-bar`. Instead use `fooBar` or `foo_bar` or
   `foobar`...

## Security
Napalm evaluates any plugin as a bash script using `source` builtin command.
Combine that with the ability to add your own plugins and you have a receipe for
disaster.

Since you can add your own plugins it's expected that you many more plugins will
be installed. Probably download from someplace. If you do, treat it like any
other bash script - potential source of malicious hazard. Examine it beforehand.
napalm plugins should generally be extremely small. Just a couple of lines
specifying from where to download a program and what do with it afterwards. If
you see something longer or out of the ordinary be extra suspicious.

For reason described above it's recommended never executing `napalm install` as
root. Example `sudo napalm install potential_rootkit 1.0`.

## License
Project uses MIT license. Check LICENSE file for more info.
