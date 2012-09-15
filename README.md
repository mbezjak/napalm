# napalm
Not a real package manager

[![Build Status](https://secure.travis-ci.org/mbezjak/napalm.png?branch=master)](http://travis-ci.org/mbezjak/napalm)

## Summary
Automate installation of archived (zip, gz, bz2, jar) programs that are unsuited
or unavailable from a package repository.

## Screenshots
For the impatient: https://github.com/mbezjak/napalm/wiki/Screenshots

## Rationale
Linux package management is great! However, sometimes you need a program that is
really simple to install but

 * it's not available in any repository
 * an older version is in a repository
 * repository policy restricts updating to newer version therefore you need to
   wait for new distribution release (Ubuntu has such policy)
 * you need two or more versions of a program
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

It isn't a problem if you need to install one program this way. It, however,
becomes tiresome if the same process needs to be repeated for two or more
programs. Not to mention that you will need to write separate scripts to setup
*_HOME variables if you need two different version of the same program.

napalm is designed as an automation tool to help you download, extract archive
and setup environment variables quicker.

A word of caution. Do not abuse napalm! Use package management anywhere you
can. napalm isn't a replacement in any way.

## Why name napalm
**N**ot **a** rea**l** **p**ack**a**ge **m**anager &rarr; Nalpam &rarr; Napalm

Close enough.

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

    # uninstall grails
    $ napalm uninstall grails

## Install
First download latest napalm release by (1) downloading `tarball`
(https://github.com/mbezjak/napalm/archives/master) then extracting it
or by (2) doing `git clone`

    $ git clone https://github.com/mbezjak/napalm.git

Either way you end up with a directory containing napalm source
code. Open terminal and change current directory to it. You have two
choices now. (1) Create a link to napalm executable:

    # assuming napalm has been downloaded/cloned into ~/lib/napalm
    # also assumes that $HOME/bin directory exists
    $ ln -s "$HOME/lib/napalm/bin/napalm" "$HOME/bin/napalm"

This is way is more safe way and doesn't require sudo. But this way
other users won't be able to use napalm. (2) To install napalm
globally, issue:

    $ sudo make install

Consider adding following snippet to your `$HOME/.bashrc` file since
napalm generates scripts in order to help you with setting up *_HOME
variables and updating `PATH` variable.

    [[ -d ~/.napalm ]] && {
      for bash_script in $(find ~/.napalm -mindepth 1 -maxdepth 1 \
                                -type f -executable -name '*\.sh')
      do
        source "$bash_script"
      done
      unset bash_script
    }

## Upgrade
Download new `tarball` or issue `git pull`. If you've installed
globally then:

    $ sudo make install

## Uninstall

    $ sudo make uninstall

Optionally remove snippet described above from your `$HOME/.bashrc` file.
Another optional thing is to remove files/directories from NAPALM_USER_HOME and
NAPALM_PROGRAMS_DIR directories (see configuration section below).

## Required dependencies
napalm is written as a bash script therefore executing in any linux distribution
shouldn't be a problem. However, make sure that `wget` and `unzip` are
installed. Some distributions don't install them by default.

## Configuration
These environment variables can be set to alter behavior of napalm.

 * NAPALM_HOME - points to where napalm is installed (defaults to being
   automatically determined)
 * NAPALM_USER_HOME - points to a hidden directory in user's home directory
   (defaults to `$HOME/.napalm`)
 * NAPALM_PROGRAMS_DIR - points to a directory where programs will be installed
   (defaults to `$NAPALM_USER_HOME/programs`)

Here is an example of configuring napalm to use different programs directory.
Snippet from `$HOME/.bashrc`:

    export NAPALM_PROGRAMS_DIR="$HOME/lib/napalm"

## Development documentation
napalm supports installing projects via plugins. A plugin is written as a very
simple bash script. Plugin's job is to describe how to download a project. Take
a look at plugins directory for example of how to write one.

### Limitations

 * project name and plugin name must be one and the same

 * plugin name cannot contain a dash (`-`) character in it's name. For example,
   you cannot name a plugin `foo-bar`. Instead use `fooBar` or `foo_bar` or
   `foobar`...

### How to write napalm plugin
napalm exposes these functions to any napalm plugin:

 * `url` - used to define URL location(s) where a program can be downloaded
   from. _args_: (String...) one or more URLs. Use `VERSION` property when
    constructing URLs.
 * `set_env` - used when generating script file to set specified environmental
   property. _args_: (String) name of environmental property that should be set
   to a location of extracted program
 * `set_path` - used when generating script file in order to update `PATH`
   variable. _args_: (String) either `true` or `false` indicating if `PATH`
   should be updated to include `bin` directory from extracted program (defaults
   to `false`). Used only if `set_env` is set.

As of version `1.2` plugins can declare `build` function in order to perform
arbitrary work during installation. It gets called after program is extracted
and all links are setup but before `program.sh` script gets created. Current
working directory for `build` function is set to directory where program is
extracted. Take a look at source of `clojure` plugin for usefulness of `build`
function.

A plugin should contain a call to `url` function. Arguments should be one or
more urls where a program can be downloaded from. Plugin has access to `VERSION`
property in order to create an url. Here is an example of a simple plugin:

    $ url "http://www.example.com/download?name=foo&version=${VERSION}.tar.gz"

Some programs change download location in a way that one url location isn't good
enough. For those programs specify more url locations. Example:

    $ url "http://www.example.com/download?name=foo&version=${VERSION}.tar.gz"\
          "http://download.example.com/foo/${VERSION}.tar.gz"

napalm will try to download from first location and proceed to another defined
url only in case of failure.

`wget` is used to download a program. Therefor any url scheme that `wget` allows
is acceptable (i.e. HTTP, HTTPS and FTP).

### Program installation example
Consider that contents of plugin `foo` are:

    url "http://download.example.com/foo/${VERSION}.tar.gz"
    set_env 'FOO_HOME'
    set_path true

Also consider that NAPALM_USER_HOME points to `/home/john/.napalm/programs`
directory. Executing `napalm install foo 1.4` causes
`http://download.example.com/foo/1.4.tar.gz` to be downloaded and extracted to
`/home/john/.napalm/programs/foo-1.4`. Symbolic link
`/home/john/.napalm/programs/foo` is setup and points to newly extracted
program. If `build` function is declared then it is invoked with current working
directory set to `/home/john/.napalm/programs/foo-1.4`. Because `set_env` and
`set_path` are used script `/home/john/.napalm/foo.sh` is created with these
contents:

    FOO_HOME="/home/john/.napalm/programs/foo"
    PATH="$PATH:$FOO_HOME/bin"

### How to install napalm plugin
Put it in either of these directories

  * NAPALM_USER_HOME/plugins
  * NAPALM_HOME/plugins

## Security
Napalm evaluates any plugin as a bash script using `source` builtin command.
Combine that with the ability to add your own plugins and you have a receipe for
disaster.

Since you can add your own plugins it's expected that many more plugins will be
installed. Probably download from someplace. If you do, treat it like any other
bash script - potential source of malicious hazard. Examine it beforehand.
napalm plugins should generally be extremely small. Just a couple of lines
specifying from where to download a program and what do with it afterwards. If
you see something longer or out of the ordinary be _extra_ suspicious.

For reason described above it's **never** recommended executing `napalm install`
as root. Example:

     # using sudo and unknown plugin isn't recommended
     $ sudo napalm install potential_rootkit 1.0

## How to use napalm
Programs marked with * are the one being used.

    # show synopsis
    $ napalm -h

    # show napalm version
    $ napalm -v

    # list all available plugins
    $ napalm list-plugins

    # list all installed programs
    $ napalm show

    # list all versions installed for program foo
    $ napalm show foo

    # show 1.0 version of program foo
    $ napalm show foo 1.0

    # switch to version 1.0 of program foo
    $ napalm use foo 1.0

    # install version 1.0 of program foo
    $ napalm install foo 1.0

    # uninstall all versions of program foo
    $ napalm uninstall foo

## How to delete a particular version
napalm currently has no option to uninstall just one version of a program. You
will have to do it manually. All programs are installed in NAPALM_PROGRAMS_DIR
directory. Removing desired directory will ensure it is no longer installed.

## Further Resources

 * Homepage:       https://github.com/mbezjak/napalm
 * Issue tracker:  https://github.com/mbezjak/napalm/issues
 * Roadmap:        https://github.com/mbezjak/napalm/issues
 * Wiki:           https://github.com/mbezjak/napalm/wiki
 * CI server:      http://travis-ci.org/mbezjak/napalm
 * License:        MIT (see LICENSE file)
