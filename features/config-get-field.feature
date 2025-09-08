Feature: Get the value of a constant or variable defined in fp-config.php and fp-custom-config.php files

  Scenario: Get the value of an existing fp-config.php constant
    Given a FP install

    When I run `fp config get DB_NAME --type=constant`
    Then STDOUT should be:
      """
      fp_cli_test
      """

  Scenario: Get the value of an existing fp-config.php constant without explicit type
    Given a FP install

    When I run `fp config get DB_NAME`
    Then STDOUT should be:
      """
      fp_cli_test
      """

  Scenario: Get the value of an existing fp-config.php variable
    Given a FP install

    When I run `fp config get table_prefix --type=variable`
    Then STDOUT should be:
      """
      fp_
      """

  Scenario: Get the value of an existing fp-config.php variable without explicit type
    Given a FP install

    When I run `fp config get table_prefix`
    Then STDOUT should be:
      """
      fp_
      """

  Scenario: Get the value of a non existing fp-config.php entry
    Given a FP install

    When I try `fp config get FOO`
    Then STDERR should be:
      """
      Error: The constant or variable 'FOO' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

  Scenario: Get the value of a non existing fp-config.php constant
    Given a FP install

    When I try `fp config get FOO --type=constant`
    Then STDERR should be:
      """
      Error: The constant 'FOO' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

  Scenario: Get the value of a non existing fp-config.php variable
    Given a FP install

    When I try `fp config get foo --type=variable`
    Then STDERR should be:
      """
      Error: The variable 'foo' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

  Scenario: Get the value of an existing fp-config.php constant with wrong case should yield an error
    Given a FP install

    When I try `fp config get db_name --type=constant`
    Then STDERR should be:
      """
      Error: The constant 'db_name' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

  Scenario: Get the value of an existing fp-config.php variable with wrong case should yield an error
    Given a FP install

    When I try `fp config get TABLE_PREFIX --type=variable`
    Then STDERR should be:
      """
      Error: The variable 'TABLE_PREFIX' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

  Scenario: Get the value of an existing fp-config.php entry with wrong case should yield an error
    Given a FP install

    When I try `fp config get TABLE_PREFIX`
    Then STDERR should be:
      """
      Error: The constant or variable 'TABLE_PREFIX' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

  Scenario: Get the value of an existing fp-config.php constant with some similarity should yield a helpful error
    Given a FP install

    When I try `fp config get DB_NOME --type=constant`
    Then STDERR should be:
      """
      Error: The constant 'DB_NOME' is not defined in the 'fp-config.php' file.
      Did you mean 'DB_NAME'?
      """
    And STDOUT should be empty

  Scenario: Get the value of an existing fp-config.php constant with some similarity should yield a helpful error
    Given a FP install

    When I try `fp config get table_perfix --type=variable`
    Then STDERR should be:
      """
      Error: The variable 'table_perfix' is not defined in the 'fp-config.php' file.
      Did you mean 'table_prefix'?
      """
    And STDOUT should be empty

  Scenario: Get the value of an existing fp-config.php entry with some similarity should yield a helpful error
    Given a FP install

    When I try `fp config get DB_NOME`
    Then STDERR should be:
      """
      Error: The constant or variable 'DB_NOME' is not defined in the 'fp-config.php' file.
      Did you mean 'DB_NAME'?
      """
    And STDOUT should be empty

  Scenario: Get the value of an existing fp-config.php constant with remote similarity should yield just an error
    Given a FP install

    When I try `fp config get DB_NOOOOZLE --type=constant`
    Then STDERR should be:
      """
      Error: The constant 'DB_NOOOOZLE' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

  Scenario: Get the value of an existing fp-config.php variable with remote similarity should yield just an error
    Given a FP install

    When I try `fp config get tabre_peffix --type=variable`
    Then STDERR should be:
      """
      Error: The variable 'tabre_peffix' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

  Scenario: Get the value of an existing fp-config.php entry with remote similarity should yield just an error
    Given a FP install

    When I try `fp config get DB_NOOOOZLE`
    Then STDERR should be:
      """
      Error: The constant or variable 'DB_NOOOOZLE' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

  @custom-config-file
  Scenario: Get the value of an existing fp-custom-config.php constant
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """
    When I run `fp config get DB_NAME --type=constant --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      fp_cli_test
      """

  Scenario: Get the value of an entry that exists as both a variable and a constant should yield a helpful error
    Given a FP install
    And a fp-config.php file:
      """
      $SOMENAME = 'value-a';
      define( 'SOMENAME', 'value-b' );
      require_once( ABSPATH . 'fp-settings.php' );
      """

    When I run `fp config list --format=table`
    Then STDOUT should be a table containing rows:
      | name     | value   | type     |
      | SOMENAME | value-a | variable |
      | SOMENAME | value-b | constant |

    When I try `fp config get SOMENAME`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOMENAME' in the 'fp-config.php' file. Use --type=<type> to disambiguate.
      """

    When I run `fp config get SOMENAME --type=variable`
    Then STDOUT should be:
      """
      value-a
      """

    When I run `fp config get SOMENAME --type=constant`
    Then STDOUT should be:
      """
      value-b
      """

  @custom-config-file
  Scenario: Get the value of an existing fp-custom-config.php constant
    Given a FP install
    And a fp-custom-config.php file:
      """
      $SOMENAME = 'value-a';
      define( 'SOMENAME', 'value-b' );
      require_once( ABSPATH . 'fp-settings.php' );
      """

    When I run `fp config list --format=table --config-file='fp-custom-config.php'`
    Then STDOUT should be a table containing rows:
      | name     | value   | type     |
      | SOMENAME | value-a | variable |
      | SOMENAME | value-b | constant |

    When I try `fp config get SOMENAME --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOMENAME' in the 'fp-custom-config.php' file. Use --type=<type> to disambiguate.
      """

    When I run `fp config get SOMENAME --type=variable --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      value-a
      """

    When I run `fp config get SOMENAME --type=constant --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      value-b
      """

  Scenario: Format returned values of the fp-config.php
    Given a FP install

    When I run `fp config get DB_NAME`
    Then STDOUT should be:
      """
      fp_cli_test
      """

    When I run `fp config get DB_NAME --format=json`
    Then STDOUT should be:
      """
      "fp_cli_test"
      """

    When I run `fp config get DB_NAME --format=yaml`
    Then STDOUT should be:
      """
      ---
      - fp_cli_test
      """

  @custom-config-file
  Scenario: Format returned values of the fp-custom-config.php
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """

    When I run `fp config get DB_NAME --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      fp_cli_test
      """

    When I run `fp config get DB_NAME --format=json --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      "fp_cli_test"
      """

    When I run `fp config get DB_NAME --format=yaml --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      ---
      - fp_cli_test
      """
