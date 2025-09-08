fp-cli/config-command
=====================

Generates and reads the fp-config.php file.

[![Testing](https://github.com/fp-cli/config-command/actions/workflows/testing.yml/badge.svg)](https://github.com/fp-cli/config-command/actions/workflows/testing.yml)

Quick links: [Using](#using) | [Installing](#installing) | [Contributing](#contributing) | [Support](#support)

## Using

This package implements the following commands:

### fp config

Generates and reads the fp-config.php file.

~~~
fp config
~~~

**EXAMPLES**

    # Create standard fp-config.php file.
    $ fp config create --dbname=testing --dbuser=fp --dbpass=securepswd --locale=ro_RO
    Success: Generated 'fp-config.php' file.

    # List constants and variables defined in fp-config.php file.
    $ fp config list
    +------------------+------------------------------------------------------------------+----------+
    | key              | value                                                            | type     |
    +------------------+------------------------------------------------------------------+----------+
    | table_prefix     | fp_                                                              | variable |
    | DB_NAME          | fp_cli_test                                                      | constant |
    | DB_USER          | root                                                             | constant |
    | DB_PASSWORD      | root                                                             | constant |
    | AUTH_KEY         | r6+@shP1yO&$)1gdu.hl[/j;7Zrvmt~o;#WxSsa0mlQOi24j2cR,7i+QM/#7S:o^ | constant |
    | SECURE_AUTH_KEY  | iO-z!_m--YH$Tx2tf/&V,YW*13Z_HiRLqi)d?$o-tMdY+82pK$`T.NYW~iTLW;xp | constant |
    +------------------+------------------------------------------------------------------+----------+

    # Get fp-config.php file path.
    $ fp config path
    /home/person/htdocs/project/fp-config.php

    # Get the table_prefix as defined in fp-config.php file.
    $ fp config get table_prefix
    fp_

    # Set the FP_DEBUG constant to true.
    $ fp config set FP_DEBUG true --raw
    Success: Updated the constant 'FP_DEBUG' in the 'fp-config.php' file with the raw value 'true'.

    # Delete the COOKIE_DOMAIN constant from the fp-config.php file.
    $ fp config delete COOKIE_DOMAIN
    Success: Deleted the constant 'COOKIE_DOMAIN' from the 'fp-config.php' file.

    # Launch system editor to edit fp-config.php file.
    $ fp config edit

    # Check whether the DB_PASSWORD constant exists in the fp-config.php file.
    $ fp config has DB_PASSWORD
    $ echo $?
    0

    # Assert if MULTISITE is true.
    $ fp config is-true MULTISITE
    $ echo $?
    0

    # Get new salts for your fp-config.php file.
    $ fp config shuffle-salts
    Success: Shuffled the salt keys.



### fp config edit

Launches system editor to edit the fp-config.php file.

~~~
fp config edit [--config-file=<path>]
~~~

**OPTIONS**

	[--config-file=<path>]
		Specify the file path to the config file to be edited. Defaults to the root of the
		FinPress installation and the filename "fp-config.php".

**EXAMPLES**

    # Launch system editor to edit fp-config.php file
    $ fp config edit

    # Edit fp-config.php file in a specific editor
    $ EDITOR=vim fp config edit



### fp config delete

Deletes a specific constant or variable from the fp-config.php file.

~~~
fp config delete <name> [--type=<type>] [--config-file=<path>]
~~~

**OPTIONS**

	<name>
		Name of the fp-config.php constant or variable.

	[--type=<type>]
		Type of the config value to delete. Defaults to 'all'.
		---
		default: all
		options:
		  - constant
		  - variable
		  - all
		---

	[--config-file=<path>]
		Specify the file path to the config file to be modified. Defaults to the root of the
		FinPress installation and the filename "fp-config.php".

**EXAMPLES**

    # Delete the COOKIE_DOMAIN constant from the fp-config.php file.
    $ fp config delete COOKIE_DOMAIN
    Success: Deleted the constant 'COOKIE_DOMAIN' from the 'fp-config.php' file.



### fp config create

Generates a fp-config.php file.

~~~
fp config create --dbname=<dbname> --dbuser=<dbuser> [--dbpass=<dbpass>] [--dbhost=<dbhost>] [--dbprefix=<dbprefix>] [--dbcharset=<dbcharset>] [--dbcollate=<dbcollate>] [--locale=<locale>] [--extra-php] [--skip-salts] [--skip-check] [--force] [--config-file=<path>] [--insecure] [--ssl]
~~~

Creates a new fp-config.php with database constants, and verifies that
the database constants are correct.

**OPTIONS**

	--dbname=<dbname>
		Set the database name.

	--dbuser=<dbuser>
		Set the database user.

	[--dbpass=<dbpass>]
		Set the database user password.

	[--dbhost=<dbhost>]
		Set the database host.
		---
		default: localhost
		---

	[--dbprefix=<dbprefix>]
		Set the database table prefix.
		---
		default: fp_
		---

	[--dbcharset=<dbcharset>]
		Set the database charset.
		---
		default: utf8
		---

	[--dbcollate=<dbcollate>]
		Set the database collation.
		---
		default:
		---

	[--locale=<locale>]
		Set the FPLANG constant. Defaults to $fp_local_package variable.

	[--extra-php]
		If set, the command copies additional PHP code into fp-config.php from STDIN.

	[--skip-salts]
		If set, keys and salts won't be generated, but should instead be passed via `--extra-php`.

	[--skip-check]
		If set, the database connection is not checked.

	[--force]
		Overwrites existing files, if present.

	[--config-file=<path>]
		Specify the file path to the config file to be created. Defaults to the root of the
		FinPress installation and the filename "fp-config.php".

	[--insecure]
		Retry API download without certificate validation if TLS handshake fails. Note: This makes the request vulnerable to a MITM attack.

	[--ssl]
		Use SSL when checking the database connection.

**EXAMPLES**

    # Standard fp-config.php file
    $ fp config create --dbname=testing --dbuser=fp --dbpass=securepswd --locale=ro_RO
    Success: Generated 'fp-config.php' file.

    # Enable FP_DEBUG and FP_DEBUG_LOG
    $ fp config create --dbname=testing --dbuser=fp --dbpass=securepswd --extra-php <<PHP
    define( 'FP_DEBUG', true );
    define( 'FP_DEBUG_LOG', true );
    PHP
    Success: Generated 'fp-config.php' file.

    # Avoid disclosing password to bash history by reading from password.txt
    # Using --prompt=dbpass will prompt for the 'dbpass' argument
    $ fp config create --dbname=testing --dbuser=fp --prompt=dbpass < password.txt
    Success: Generated 'fp-config.php' file.



### fp config get

Gets the value of a specific constant or variable defined in fp-config.php file.

~~~
fp config get <name> [--type=<type>] [--format=<format>] [--config-file=<path>]
~~~

**OPTIONS**

	<name>
		Name of the fp-config.php constant or variable.

	[--type=<type>]
		Type of config value to retrieve. Defaults to 'all'.
		---
		default: all
		options:
		  - constant
		  - variable
		  - all
		---

	[--format=<format>]
		Get value in a particular format.
		Dotenv is limited to non-object values.
		---
		default: var_export
		options:
		  - var_export
		  - json
		  - yaml
		  - dotenv
		---

	[--config-file=<path>]
		Specify the file path to the config file to be read. Defaults to the root of the
		FinPress installation and the filename "fp-config.php".

**EXAMPLES**

    # Get the table_prefix as defined in fp-config.php file.
    $ fp config get table_prefix
    fp_



### fp config has

Checks whether a specific constant or variable exists in the fp-config.php file.

~~~
fp config has <name> [--type=<type>] [--config-file=<path>]
~~~

**OPTIONS**

	<name>
		Name of the fp-config.php constant or variable.

	[--type=<type>]
		Type of the config value to set. Defaults to 'all'.
		---
		default: all
		options:
		  - constant
		  - variable
		  - all
		---

	[--config-file=<path>]
		Specify the file path to the config file to be checked. Defaults to the root of the
		FinPress installation and the filename "fp-config.php".

**EXAMPLES**

    # Check whether the DB_PASSWORD constant exists in the fp-config.php file.
    $ fp config has DB_PASSWORD



### fp config is-true

Determines whether value of a specific defined constant or variable is truthy.

~~~
fp config is-true <name> [--type=<type>] [--config-file=<path>]
~~~

This determination is made by evaluating the retrieved value via boolval().

**OPTIONS**

	<name>
		Name of the fp-config.php constant or variable.

	[--type=<type>]
		Type of config value to retrieve. Defaults to 'all'.
		---
		default: all
		options:
		  - constant
		  - variable
		  - all
		---

	[--config-file=<path>]
		Specify the file path to the config file to be read. Defaults to the root of the
		FinPress installation and the filename "fp-config.php".

**EXAMPLES**

    # Assert if MULTISITE is true
    $ fp config is-true MULTISITE
    $ echo $?
    0



### fp config list

Lists variables, constants, and file includes defined in fp-config.php file.

~~~
fp config list [<filter>...] [--fields=<fields>] [--format=<format>] [--strict] [--config-file=<path>]
~~~

**OPTIONS**

	[<filter>...]
		Name or partial name to filter the list by.

	[--fields=<fields>]
		Limit the output to specific fields. Defaults to all fields.

	[--format=<format>]
		Render output in a particular format.
		Dotenv is limited to non-object values.
		---
		default: table
		options:
		  - table
		  - csv
		  - json
		  - yaml
		  - dotenv
		---

	[--strict]
		Enforce strict matching when a filter is provided.

	[--config-file=<path>]
		Specify the file path to the config file to be read. Defaults to the root of the
		FinPress installation and the filename "fp-config.php".

**EXAMPLES**

    # List constants and variables defined in fp-config.php file.
    $ fp config list
    +------------------+------------------------------------------------------------------+----------+
    | key              | value                                                            | type     |
    +------------------+------------------------------------------------------------------+----------+
    | table_prefix     | fp_                                                              | variable |
    | DB_NAME          | fp_cli_test                                                      | constant |
    | DB_USER          | root                                                             | constant |
    | DB_PASSWORD      | root                                                             | constant |
    | AUTH_KEY         | r6+@shP1yO&$)1gdu.hl[/j;7Zrvmt~o;#WxSsa0mlQOi24j2cR,7i+QM/#7S:o^ | constant |
    | SECURE_AUTH_KEY  | iO-z!_m--YH$Tx2tf/&V,YW*13Z_HiRLqi)d?$o-tMdY+82pK$`T.NYW~iTLW;xp | constant |
    +------------------+------------------------------------------------------------------+----------+

    # List only database user and password from fp-config.php file.
    $ fp config list DB_USER DB_PASSWORD --strict
    +------------------+-------+----------+
    | key              | value | type     |
    +------------------+-------+----------+
    | DB_USER          | root  | constant |
    | DB_PASSWORD      | root  | constant |
    +------------------+-------+----------+

    # List all salts from fp-config.php file.
    $ fp config list _SALT
    +------------------+------------------------------------------------------------------+----------+
    | key              | value                                                            | type     |
    +------------------+------------------------------------------------------------------+----------+
    | AUTH_SALT        | n:]Xditk+_7>Qi=>BmtZHiH-6/Ecrvl(V5ceeGP:{>?;BT^=[B3-0>,~F5z$(+Q$ | constant |
    | SECURE_AUTH_SALT | ?Z/p|XhDw3w}?c.z%|+BAr|(Iv*H%%U+Du&kKR y?cJOYyRVRBeB[2zF-`(>+LCC | constant |
    | LOGGED_IN_SALT   | +$@(1{b~Z~s}Cs>8Y]6[m6~TnoCDpE>O%e75u}&6kUH!>q:7uM4lxbB6[1pa_X,q | constant |
    | NONCE_SALT       | _x+F li|QL?0OSQns1_JZ{|Ix3Jleox-71km/gifnyz8kmo=w-;@AE8W,(fP<N}2 | constant |
    +------------------+------------------------------------------------------------------+----------+



### fp config path

Gets the path to fp-config.php file.

~~~
fp config path 
~~~

**EXAMPLES**

    # Get fp-config.php file path
    $ fp config path
    /home/person/htdocs/project/fp-config.php



### fp config set

Sets the value of a specific constant or variable defined in fp-config.php file.

~~~
fp config set <name> <value> [--add] [--raw] [--anchor=<anchor>] [--placement=<placement>] [--separator=<separator>] [--type=<type>] [--config-file=<path>]
~~~

**OPTIONS**

	<name>
		Name of the fp-config.php constant or variable.

	<value>
		Value to set the fp-config.php constant or variable to.

	[--add]
		Add the value if it doesn't exist yet.
		This is the default behavior, override with --no-add.

	[--raw]
		Place the value into the fp-config.php file as is, instead of as a quoted string.

	[--anchor=<anchor>]
		Anchor string where additions of new values are anchored around.
		Defaults to "/* That's all, stop editing!".
		The special case "EOF" string uses the end of the file as the anchor.

	[--placement=<placement>]
		Where to place the new values in relation to the anchor string.
		---
		default: 'before'
		options:
		  - before
		  - after
		---

	[--separator=<separator>]
		Separator string to put between an added value and its anchor string.
		The following escape sequences will be recognized and properly interpreted: '\n' => newline, '\r' => carriage return, '\t' => tab.
		Defaults to a single EOL ("\n" on *nix and "\r\n" on Windows).

	[--type=<type>]
		Type of the config value to set. Defaults to 'all'.
		---
		default: all
		options:
		  - constant
		  - variable
		  - all
		---

	[--config-file=<path>]
		Specify the file path to the config file to be modified. Defaults to the root of the
		FinPress installation and the filename "fp-config.php".

**EXAMPLES**

    # Set the FP_DEBUG constant to true.
    $ fp config set FP_DEBUG true --raw
    Success: Updated the constant 'FP_DEBUG' in the 'fp-config.php' file with the raw value 'true'.



### fp config shuffle-salts

Refreshes the salts defined in the fp-config.php file.

~~~
fp config shuffle-salts [<keys>...] [--force] [--config-file=<path>] [--insecure]
~~~

**OPTIONS**

	[<keys>...]
		One ore more keys to shuffle. If none are provided, this falls back to the default FinPress Core salt keys.

	[--force]
		If an unknown key is requested to be shuffled, add it instead of throwing a warning.

	[--config-file=<path>]
		Specify the file path to the config file to be modified. Defaults to the root of the
		FinPress installation and the filename "fp-config.php".

	[--insecure]
		Retry API download without certificate validation if TLS handshake fails. Note: This makes the request vulnerable to a MITM attack.

**EXAMPLES**

    # Get new salts for your fp-config.php file
    $ fp config shuffle-salts
    Success: Shuffled the salt keys.

    # Add a cache key salt to the fp-config.php file
    $ fp config shuffle-salts FP_CACHE_KEY_SALT --force
    Success: Shuffled the salt keys.

## Installing

This package is included with FP-CLI itself, no additional installation necessary.

To install the latest version of this package over what's included in FP-CLI, run:

    fp package install git@github.com:fp-cli/config-command.git

## Contributing

We appreciate you taking the initiative to contribute to this project.

Contributing isn’t limited to just code. We encourage you to contribute in the way that best fits your abilities, by writing tutorials, giving a demo at your local meetup, helping other users with their support questions, or revising our documentation.

For a more thorough introduction, [check out FP-CLI's guide to contributing](https://make.finpress.org/cli/handbook/contributing/). This package follows those policy and guidelines.

### Reporting a bug

Think you’ve found a bug? We’d love for you to help us get it fixed.

Before you create a new issue, you should [search existing issues](https://github.com/fp-cli/config-command/issues?q=label%3Abug%20) to see if there’s an existing resolution to it, or if it’s already been fixed in a newer version.

Once you’ve done a bit of searching and discovered there isn’t an open or fixed issue for your bug, please [create a new issue](https://github.com/fp-cli/config-command/issues/new). Include as much detail as you can, and clear steps to reproduce if possible. For more guidance, [review our bug report documentation](https://make.finpress.org/cli/handbook/bug-reports/).

### Creating a pull request

Want to contribute a new feature? Please first [open a new issue](https://github.com/fp-cli/config-command/issues/new) to discuss whether the feature is a good fit for the project.

Once you've decided to commit the time to seeing your pull request through, [please follow our guidelines for creating a pull request](https://make.finpress.org/cli/handbook/pull-requests/) to make sure it's a pleasant experience. See "[Setting up](https://make.finpress.org/cli/handbook/pull-requests/#setting-up)" for details specific to working on this package locally.

## Support

GitHub issues aren't for general support questions, but there are other venues you can try: https://fp-cli.org/#support


*This README.md is generated dynamically from the project's codebase using `fp scaffold package-readme` ([doc](https://github.com/fp-cli/scaffold-package-command#fp-scaffold-package-readme)). To suggest changes, please submit a pull request against the corresponding part of the codebase.*
