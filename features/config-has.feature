Feature: Check whether the fin-config.php file or the fin-custom-config.php file has a certain constant or variable

  Scenario: Check the existence of an existing fin-config.php constant or variable
    Given a FIN install

    When I run `fin config has DB_NAME`
    Then STDOUT should be empty
    And the return code should be 0

    When I run `fin config has DB_USER --type=constant`
    Then STDOUT should be empty
    And the return code should be 0

    When I run `fin config has table_prefix --type=variable`
    Then STDOUT should be empty
    And the return code should be 0

  Scenario: Check for the existance of an existing fin-config.php constant in a read-only file system
    Given a FIN install

    When I run `chmod -w fin-config.php`
    And I try `fin config has DB_NAME`
    Then STDOUT should be empty
    And the return code should be 0

  @custom-config-file
  Scenario: Check the existence of an existing fin-custom-config.php constant or variable
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """
    When I run `fin config has DB_NAME --config-file='fin-custom-config.php'`
    Then STDOUT should be empty
    And the return code should be 0

    When I run `fin config has DB_USER --type=constant --config-file='fin-custom-config.php'`
    Then STDOUT should be empty
    And the return code should be 0

    When I run `fin config has table_prefix --type=variable --config-file='fin-custom-config.php'`
    Then STDOUT should be empty
    And the return code should be 0

  Scenario: Check the existence of a non-existing fin-config.php constant or variable
    Given a FIN install

    When I try `fin config has FOO`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fin config has FOO --type=constant`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fin config has FOO --type=variable`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fin config has DB_HOST --type=variable`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fin config has table_prefix --type=constant`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

  @custom-config-file
  Scenario: Check the existence of a non-existing fin-custom-config.php constant or variable
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """

    When I try `fin config has FOO --config-file='fin-custom-config.php'`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fin config has FOO --type=constant --config-file='fin-custom-config.php'`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fin config has FOO --type=variable --config-file='fin-custom-config.php'`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fin config has DB_HOST --type=variable --config-file='fin-custom-config.php'`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fin config has table_prefix --type=constant --config-file='fin-custom-config.php'`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

  Scenario: Ambiguous check for fin-config.php throw errors
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

    When I try `fin config has SOME_NAME`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fin-config.php' file. Use --type=<type> to disambiguate.
      """

  @custom-config-file
  Scenario: Ambiguous check for fin-custom-config.php throw errors
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

    When I try `fin config has SOME_NAME --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fin-custom-config.php' file. Use --type=<type> to disambiguate.
      """
