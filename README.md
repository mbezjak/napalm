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
First download latest napalm release by downloading `tarball`
(https://github.com/mbezjak/napalm/archives/master) then extracting it or by
doing `git clone`

    $ git clone https://github.com/mbezjak/napalm.git

Either way you end up with a directory containing napalm source code. Open
terminal and change current directory to it. Now issue these two commands:

    $ make
    $ sudo make install

Consider adding following snippet to your `$HOME/.bashrc` file since napalm can
generate scripts in order to help you with setting up *_HOME variables and
updating `PATH` variable.

    if [[ -d ~/.napalm ]]; then
      for bash_script in ~/.napalm/*.sh
      do
        [[ -x $bash_script ]] && . $bash_script
      done
      unset bash_script
    fi

## Upgrade
Download new `tarball` or issue `git pull`. Then:

    $ make
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
   variable. _args_: (String) flat (`true` or `false`) indicating if `PATH`
   should be updated to include `bin` directory from extracted program (defaults
   to `false`)

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
program. Because `set_env` and `set_path` are used script
`/home/john/.napalm/foo.sh` is created with these contents:

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
Star (*) character in napalm output represents a version of a program being
used.

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

## How to delete a program
napalm curently has no option to delete installed program. You will have to do
it manually. All programs are installed in NAPALM_PROGRAMS_DIR directory.
Removing desired directory will ensure it is no longer installed.

## License
Project uses MIT license. Check LICENSE file for more info.
