Feature: Set the value of a constant or variable defined in fin-config.php file and fin-custom-config.php files

  Scenario: Update the value of an existing fin-config.php constant
    Given a FIN install

    When I run `fin config set DB_HOST db.example.com`
    Then STDOUT should be:
      """
      Success: Updated the constant 'DB_HOST' in the 'fin-config.php' file with the value 'db.example.com'.
      """

    When I run `fin config get DB_HOST`
    Then STDOUT should be:
      """
      db.example.com
      """

  @custom-config-file
  Scenario: Update the value of an existing fin-custom-config.php constant
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """

    When I run `fin config set DB_HOST db.example.com --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Updated the constant 'DB_HOST' in the 'fin-custom-config.php' file with the value 'db.example.com'.
      """

    When I run `fin config get DB_HOST --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      db.example.com
      """

  Scenario: Add a new value to fin-config.php
    Given a FIN install
    When I run `fin config set NEW_CONSTANT constant_value --type=constant`
    Then STDOUT should be:
      """
      Success: Added the constant 'NEW_CONSTANT' to the 'fin-config.php' file with the value 'constant_value'.
      """

    When I run `fin config get NEW_CONSTANT`
    Then STDOUT should be:
      """
      constant_value
      """

    When I run `fin config set new_variable variable_value --type=variable`
    Then STDOUT should be:
      """
      Success: Added the variable 'new_variable' to the 'fin-config.php' file with the value 'variable_value'.
      """

    When I run `fin config get new_variable`
    Then STDOUT should be:
      """
      variable_value
      """

    When I run `fin config set DEFAULT_TO_CONSTANT some_value`
    Then STDOUT should be:
      """
      Success: Added the constant 'DEFAULT_TO_CONSTANT' to the 'fin-config.php' file with the value 'some_value'.
      """

    When I run `fin config get DEFAULT_TO_CONSTANT`
    Then STDOUT should be:
      """
      some_value
      """

  Scenario: Add a new value to fin-custom-config.php
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """

    When I run `fin config set NEW_CONSTANT constant_value --type=constant --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the constant 'NEW_CONSTANT' to the 'fin-custom-config.php' file with the value 'constant_value'.
      """

    When I run `fin config get NEW_CONSTANT --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      constant_value
      """

    When I run `fin config set new_variable variable_value --type=variable --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the variable 'new_variable' to the 'fin-custom-config.php' file with the value 'variable_value'.
      """

    When I run `fin config get new_variable --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      variable_value
      """

    When I run `fin config set DEFAULT_TO_CONSTANT some_value --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the constant 'DEFAULT_TO_CONSTANT' to the 'fin-custom-config.php' file with the value 'some_value'.
      """

    When I run `fin config get DEFAULT_TO_CONSTANT --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      some_value
      """

  Scenario: Updating a non-existent value  in fin-config.php without --add
    Given a FIN install

    When I try `fin config set NEW_CONSTANT constant_value --no-add`
    Then STDERR should be:
      """
      Error: The constant or variable 'NEW_CONSTANT' is not defined in the 'fin-config.php' file.
      """

    When I try `fin config set NEW_CONSTANT constant_value --type=constant --no-add`
    Then STDERR should be:
      """
      Error: The constant 'NEW_CONSTANT' is not defined in the 'fin-config.php' file.
      """

    When I try `fin config set NEW_CONSTANT constant_value --type=variable --no-add`
    Then STDERR should be:
      """
      Error: The variable 'NEW_CONSTANT' is not defined in the 'fin-config.php' file.
      """

    When I try `fin config set table_prefix new_prefix --type=constant --no-add`
    Then STDERR should be:
      """
      Error: The constant 'table_prefix' is not defined in the 'fin-config.php' file.
      """

    When I run `fin config set table_prefix new_prefix --type=variable --no-add`
    Then STDOUT should be:
      """
      Success: Updated the variable 'table_prefix' in the 'fin-config.php' file with the value 'new_prefix'.
      """

    When I try `fin config set DB_HOST db.example.com --type=variable --no-add`
    Then STDERR should be:
      """
      Error: The variable 'DB_HOST' is not defined in the 'fin-config.php' file.
      """

    When I run `fin config set DB_HOST db.example.com --type=constant --no-add`
    Then STDOUT should be:
      """
      Success: Updated the constant 'DB_HOST' in the 'fin-config.php' file with the value 'db.example.com'.
      """

  @custom-config-file
  Scenario: Updating a non-existent value in fin-custom-config.php without --add
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """

    When I try `fin config set NEW_CONSTANT constant_value --no-add --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant or variable 'NEW_CONSTANT' is not defined in the 'fin-custom-config.php' file.
      """

    When I try `fin config set NEW_CONSTANT constant_value --type=constant --no-add --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant 'NEW_CONSTANT' is not defined in the 'fin-custom-config.php' file.
      """

    When I try `fin config set NEW_CONSTANT constant_value --type=variable --no-add --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: The variable 'NEW_CONSTANT' is not defined in the 'fin-custom-config.php' file.
      """

    When I try `fin config set table_prefix new_prefix --type=constant --no-add --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant 'table_prefix' is not defined in the 'fin-custom-config.php' file.
      """

    When I run `fin config set table_prefix new_prefix --type=variable --no-add --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Updated the variable 'table_prefix' in the 'fin-custom-config.php' file with the value 'new_prefix'.
      """

    When I try `fin config set DB_HOST db.example.com --type=variable --no-add --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: The variable 'DB_HOST' is not defined in the 'fin-custom-config.php' file.
      """

    When I run `fin config set DB_HOST db.example.com --type=constant --no-add --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Updated the constant 'DB_HOST' in the 'fin-custom-config.php' file with the value 'db.example.com'.
      """

  Scenario: Update raw values in fin-config.php
    Given a FIN install

    When I run `fin config set FIN_TEST true --type=constant`
    Then STDOUT should be:
      """
      Success: Added the constant 'FIN_TEST' to the 'fin-config.php' file with the value 'true'.
      """

    When I run `fin config list FIN_TEST --strict --format=json`
    Then STDOUT should contain:
      """
      {"name":"FIN_TEST","value":"true","type":"constant"}
      """

    When I run `fin config set FIN_TEST true --raw`
    Then STDOUT should be:
      """
      Success: Updated the constant 'FIN_TEST' in the 'fin-config.php' file with the raw value 'true'.
      """

    When I run `fin config list FIN_TEST --strict --format=json`
    Then STDOUT should contain:
      """
      {"name":"FIN_TEST","value":true,"type":"constant"}
      """

  @custom-config-file
  Scenario: Update raw values in fin-config.php
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """

    When I run `fin config set FIN_TEST true --type=constant --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the constant 'FIN_TEST' to the 'fin-custom-config.php' file with the value 'true'.
      """

    When I run `fin config list FIN_TEST --strict --format=json --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      {"name":"FIN_TEST","value":"true","type":"constant"}
      """

    When I run `fin config set FIN_TEST true --raw --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Updated the constant 'FIN_TEST' in the 'fin-custom-config.php' file with the raw value 'true'.
      """

    When I run `fin config list FIN_TEST --strict --format=json --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      {"name":"FIN_TEST","value":true,"type":"constant"}
      """

  Scenario: Ambiguous change requests for fin-config.php throw errors
    Given a FIN install

    When I run `fin config set SOME_NAME some_value --type=constant`
    Then STDOUT should be:
      """
      Success: Added the constant 'SOME_NAME' to the 'fin-config.php' file with the value 'some_value'.
      """

    When I run `fin config set SOME_NAME some_value --type=variable`
    Then STDOUT should be:
      """
      Success: Added the variable 'SOME_NAME' to the 'fin-config.php' file with the value 'some_value'.
      """

    When I run `fin config list --fields=name,type SOME_NAME --strict`
    Then STDOUT should be a table containing rows:
      | name      | type     |
      | SOME_NAME | constant |
      | SOME_NAME | variable |

    When I try `fin config set SOME_NAME some_value`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fin-config.php' file. Use --type=<type> to disambiguate.
      """

  @custom-config-file
  Scenario: Ambiguous change requests for fin-custom-config.php throw errors
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """

    When I run `fin config set SOME_NAME some_value --type=constant --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the constant 'SOME_NAME' to the 'fin-custom-config.php' file with the value 'some_value'.
      """

    When I run `fin config set SOME_NAME some_value --type=variable --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the variable 'SOME_NAME' to the 'fin-custom-config.php' file with the value 'some_value'.
      """

    When I run `fin config list --fields=name,type SOME_NAME --strict --config-file='fin-custom-config.php'`
    Then STDOUT should be a table containing rows:
      | name      | type     |
      | SOME_NAME | constant |
      | SOME_NAME | variable |

    When I try `fin config set SOME_NAME some_value --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fin-custom-config.php' file. Use --type=<type> to disambiguate.
      """

  Scenario: Additions can be properly placed in fin-config.php
    Given a FIN install
    And a fin-config.php file:
      """
      define( 'CONST_A', 'val-a' );
      /** ANCHOR */
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fin-settings.php' );
      """

    When I run `fin config set SOME_NAME some_value --type=constant --anchor="/** ANCHOR */" --placement=before --separator="\n"`
    Then STDOUT should be:
      """
      Success: Added the constant 'SOME_NAME' to the 'fin-config.php' file with the value 'some_value'.
      """
    And the fin-config.php file should be:
      """
      define( 'CONST_A', 'val-a' );
      define( 'SOME_NAME', 'some_value' );
      /** ANCHOR */
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fin-settings.php' );
      """

    When I run `fin config set ANOTHER_NAME another_value --type=constant --anchor="/** ANCHOR */" --placement=after --separator="\n"`
    Then STDOUT should be:
      """
      Success: Added the constant 'ANOTHER_NAME' to the 'fin-config.php' file with the value 'another_value'.
      """
    And the fin-config.php file should be:
      """
      define( 'CONST_A', 'val-a' );
      define( 'SOME_NAME', 'some_value' );
      /** ANCHOR */
      define( 'ANOTHER_NAME', 'another_value' );
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fin-settings.php' );
      """

  Scenario: Additions can be properly placed in fin-custom-config.php
    Given a FIN install
    And a fin-custom-config.php file:
      """
      define( 'CONST_A', 'val-a' );
      /** ANCHOR */
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fin-settings.php' );
      """

    When I run `fin config set SOME_NAME some_value --type=constant --anchor="/** ANCHOR */" --placement=before --separator="\n" --config-file="fin-custom-config.php"`
    Then STDOUT should be:
      """
      Success: Added the constant 'SOME_NAME' to the 'fin-custom-config.php' file with the value 'some_value'.
      """
    And the fin-custom-config.php file should be:
      """
      define( 'CONST_A', 'val-a' );
      define( 'SOME_NAME', 'some_value' );
      /** ANCHOR */
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fin-settings.php' );
      """

    When I run `fin config set ANOTHER_NAME another_value --type=constant --anchor="/** ANCHOR */" --placement=after --separator="\n" --config-file="fin-custom-config.php"`
    Then STDOUT should be:
      """
      Success: Added the constant 'ANOTHER_NAME' to the 'fin-custom-config.php' file with the value 'another_value'.
      """
    And the fin-custom-config.php file should be:
      """
      define( 'CONST_A', 'val-a' );
      define( 'SOME_NAME', 'some_value' );
      /** ANCHOR */
      define( 'ANOTHER_NAME', 'another_value' );
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fin-settings.php' );
      """
