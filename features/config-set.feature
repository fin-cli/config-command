Feature: Set the value of a constant or variable defined in fp-config.php file and fp-custom-config.php files

  Scenario: Update the value of an existing fp-config.php constant
    Given a FP install

    When I run `fp config set DB_HOST db.example.com`
    Then STDOUT should be:
      """
      Success: Updated the constant 'DB_HOST' in the 'fp-config.php' file with the value 'db.example.com'.
      """

    When I run `fp config get DB_HOST`
    Then STDOUT should be:
      """
      db.example.com
      """

  @custom-config-file
  Scenario: Update the value of an existing fp-custom-config.php constant
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """

    When I run `fp config set DB_HOST db.example.com --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Updated the constant 'DB_HOST' in the 'fp-custom-config.php' file with the value 'db.example.com'.
      """

    When I run `fp config get DB_HOST --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      db.example.com
      """

  Scenario: Add a new value to fp-config.php
    Given a FP install
    When I run `fp config set NEW_CONSTANT constant_value --type=constant`
    Then STDOUT should be:
      """
      Success: Added the constant 'NEW_CONSTANT' to the 'fp-config.php' file with the value 'constant_value'.
      """

    When I run `fp config get NEW_CONSTANT`
    Then STDOUT should be:
      """
      constant_value
      """

    When I run `fp config set new_variable variable_value --type=variable`
    Then STDOUT should be:
      """
      Success: Added the variable 'new_variable' to the 'fp-config.php' file with the value 'variable_value'.
      """

    When I run `fp config get new_variable`
    Then STDOUT should be:
      """
      variable_value
      """

    When I run `fp config set DEFAULT_TO_CONSTANT some_value`
    Then STDOUT should be:
      """
      Success: Added the constant 'DEFAULT_TO_CONSTANT' to the 'fp-config.php' file with the value 'some_value'.
      """

    When I run `fp config get DEFAULT_TO_CONSTANT`
    Then STDOUT should be:
      """
      some_value
      """

  Scenario: Add a new value to fp-custom-config.php
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """

    When I run `fp config set NEW_CONSTANT constant_value --type=constant --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the constant 'NEW_CONSTANT' to the 'fp-custom-config.php' file with the value 'constant_value'.
      """

    When I run `fp config get NEW_CONSTANT --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      constant_value
      """

    When I run `fp config set new_variable variable_value --type=variable --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the variable 'new_variable' to the 'fp-custom-config.php' file with the value 'variable_value'.
      """

    When I run `fp config get new_variable --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      variable_value
      """

    When I run `fp config set DEFAULT_TO_CONSTANT some_value --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the constant 'DEFAULT_TO_CONSTANT' to the 'fp-custom-config.php' file with the value 'some_value'.
      """

    When I run `fp config get DEFAULT_TO_CONSTANT --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      some_value
      """

  Scenario: Updating a non-existent value  in fp-config.php without --add
    Given a FP install

    When I try `fp config set NEW_CONSTANT constant_value --no-add`
    Then STDERR should be:
      """
      Error: The constant or variable 'NEW_CONSTANT' is not defined in the 'fp-config.php' file.
      """

    When I try `fp config set NEW_CONSTANT constant_value --type=constant --no-add`
    Then STDERR should be:
      """
      Error: The constant 'NEW_CONSTANT' is not defined in the 'fp-config.php' file.
      """

    When I try `fp config set NEW_CONSTANT constant_value --type=variable --no-add`
    Then STDERR should be:
      """
      Error: The variable 'NEW_CONSTANT' is not defined in the 'fp-config.php' file.
      """

    When I try `fp config set table_prefix new_prefix --type=constant --no-add`
    Then STDERR should be:
      """
      Error: The constant 'table_prefix' is not defined in the 'fp-config.php' file.
      """

    When I run `fp config set table_prefix new_prefix --type=variable --no-add`
    Then STDOUT should be:
      """
      Success: Updated the variable 'table_prefix' in the 'fp-config.php' file with the value 'new_prefix'.
      """

    When I try `fp config set DB_HOST db.example.com --type=variable --no-add`
    Then STDERR should be:
      """
      Error: The variable 'DB_HOST' is not defined in the 'fp-config.php' file.
      """

    When I run `fp config set DB_HOST db.example.com --type=constant --no-add`
    Then STDOUT should be:
      """
      Success: Updated the constant 'DB_HOST' in the 'fp-config.php' file with the value 'db.example.com'.
      """

  @custom-config-file
  Scenario: Updating a non-existent value in fp-custom-config.php without --add
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """

    When I try `fp config set NEW_CONSTANT constant_value --no-add --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant or variable 'NEW_CONSTANT' is not defined in the 'fp-custom-config.php' file.
      """

    When I try `fp config set NEW_CONSTANT constant_value --type=constant --no-add --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant 'NEW_CONSTANT' is not defined in the 'fp-custom-config.php' file.
      """

    When I try `fp config set NEW_CONSTANT constant_value --type=variable --no-add --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: The variable 'NEW_CONSTANT' is not defined in the 'fp-custom-config.php' file.
      """

    When I try `fp config set table_prefix new_prefix --type=constant --no-add --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant 'table_prefix' is not defined in the 'fp-custom-config.php' file.
      """

    When I run `fp config set table_prefix new_prefix --type=variable --no-add --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Updated the variable 'table_prefix' in the 'fp-custom-config.php' file with the value 'new_prefix'.
      """

    When I try `fp config set DB_HOST db.example.com --type=variable --no-add --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: The variable 'DB_HOST' is not defined in the 'fp-custom-config.php' file.
      """

    When I run `fp config set DB_HOST db.example.com --type=constant --no-add --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Updated the constant 'DB_HOST' in the 'fp-custom-config.php' file with the value 'db.example.com'.
      """

  Scenario: Update raw values in fp-config.php
    Given a FP install

    When I run `fp config set FP_TEST true --type=constant`
    Then STDOUT should be:
      """
      Success: Added the constant 'FP_TEST' to the 'fp-config.php' file with the value 'true'.
      """

    When I run `fp config list FP_TEST --strict --format=json`
    Then STDOUT should contain:
      """
      {"name":"FP_TEST","value":"true","type":"constant"}
      """

    When I run `fp config set FP_TEST true --raw`
    Then STDOUT should be:
      """
      Success: Updated the constant 'FP_TEST' in the 'fp-config.php' file with the raw value 'true'.
      """

    When I run `fp config list FP_TEST --strict --format=json`
    Then STDOUT should contain:
      """
      {"name":"FP_TEST","value":true,"type":"constant"}
      """

  @custom-config-file
  Scenario: Update raw values in fp-config.php
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """

    When I run `fp config set FP_TEST true --type=constant --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the constant 'FP_TEST' to the 'fp-custom-config.php' file with the value 'true'.
      """

    When I run `fp config list FP_TEST --strict --format=json --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      {"name":"FP_TEST","value":"true","type":"constant"}
      """

    When I run `fp config set FP_TEST true --raw --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Updated the constant 'FP_TEST' in the 'fp-custom-config.php' file with the raw value 'true'.
      """

    When I run `fp config list FP_TEST --strict --format=json --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      {"name":"FP_TEST","value":true,"type":"constant"}
      """

  Scenario: Ambiguous change requests for fp-config.php throw errors
    Given a FP install

    When I run `fp config set SOME_NAME some_value --type=constant`
    Then STDOUT should be:
      """
      Success: Added the constant 'SOME_NAME' to the 'fp-config.php' file with the value 'some_value'.
      """

    When I run `fp config set SOME_NAME some_value --type=variable`
    Then STDOUT should be:
      """
      Success: Added the variable 'SOME_NAME' to the 'fp-config.php' file with the value 'some_value'.
      """

    When I run `fp config list --fields=name,type SOME_NAME --strict`
    Then STDOUT should be a table containing rows:
      | name      | type     |
      | SOME_NAME | constant |
      | SOME_NAME | variable |

    When I try `fp config set SOME_NAME some_value`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fp-config.php' file. Use --type=<type> to disambiguate.
      """

  @custom-config-file
  Scenario: Ambiguous change requests for fp-custom-config.php throw errors
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """

    When I run `fp config set SOME_NAME some_value --type=constant --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the constant 'SOME_NAME' to the 'fp-custom-config.php' file with the value 'some_value'.
      """

    When I run `fp config set SOME_NAME some_value --type=variable --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Added the variable 'SOME_NAME' to the 'fp-custom-config.php' file with the value 'some_value'.
      """

    When I run `fp config list --fields=name,type SOME_NAME --strict --config-file='fp-custom-config.php'`
    Then STDOUT should be a table containing rows:
      | name      | type     |
      | SOME_NAME | constant |
      | SOME_NAME | variable |

    When I try `fp config set SOME_NAME some_value --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fp-custom-config.php' file. Use --type=<type> to disambiguate.
      """

  Scenario: Additions can be properly placed in fp-config.php
    Given a FP install
    And a fp-config.php file:
      """
      define( 'CONST_A', 'val-a' );
      /** ANCHOR */
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fp-settings.php' );
      """

    When I run `fp config set SOME_NAME some_value --type=constant --anchor="/** ANCHOR */" --placement=before --separator="\n"`
    Then STDOUT should be:
      """
      Success: Added the constant 'SOME_NAME' to the 'fp-config.php' file with the value 'some_value'.
      """
    And the fp-config.php file should be:
      """
      define( 'CONST_A', 'val-a' );
      define( 'SOME_NAME', 'some_value' );
      /** ANCHOR */
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fp-settings.php' );
      """

    When I run `fp config set ANOTHER_NAME another_value --type=constant --anchor="/** ANCHOR */" --placement=after --separator="\n"`
    Then STDOUT should be:
      """
      Success: Added the constant 'ANOTHER_NAME' to the 'fp-config.php' file with the value 'another_value'.
      """
    And the fp-config.php file should be:
      """
      define( 'CONST_A', 'val-a' );
      define( 'SOME_NAME', 'some_value' );
      /** ANCHOR */
      define( 'ANOTHER_NAME', 'another_value' );
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fp-settings.php' );
      """

  Scenario: Additions can be properly placed in fp-custom-config.php
    Given a FP install
    And a fp-custom-config.php file:
      """
      define( 'CONST_A', 'val-a' );
      /** ANCHOR */
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fp-settings.php' );
      """

    When I run `fp config set SOME_NAME some_value --type=constant --anchor="/** ANCHOR */" --placement=before --separator="\n" --config-file="fp-custom-config.php"`
    Then STDOUT should be:
      """
      Success: Added the constant 'SOME_NAME' to the 'fp-custom-config.php' file with the value 'some_value'.
      """
    And the fp-custom-config.php file should be:
      """
      define( 'CONST_A', 'val-a' );
      define( 'SOME_NAME', 'some_value' );
      /** ANCHOR */
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fp-settings.php' );
      """

    When I run `fp config set ANOTHER_NAME another_value --type=constant --anchor="/** ANCHOR */" --placement=after --separator="\n" --config-file="fp-custom-config.php"`
    Then STDOUT should be:
      """
      Success: Added the constant 'ANOTHER_NAME' to the 'fp-custom-config.php' file with the value 'another_value'.
      """
    And the fp-custom-config.php file should be:
      """
      define( 'CONST_A', 'val-a' );
      define( 'SOME_NAME', 'some_value' );
      /** ANCHOR */
      define( 'ANOTHER_NAME', 'another_value' );
      define( 'CONST_B', 'val-b' );
      require_once( ABSPATH . 'fp-settings.php' );
      """
