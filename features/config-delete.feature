Feature: Delete a constant or variable from the fin-config.php file

  Scenario: Delete an existing fin-config.php constant
    Given a FIN install

    When I run `fin config delete DB_PASSWORD`
    Then STDOUT should be:
      """
      Success: Deleted the constant 'DB_PASSWORD' from the 'fin-config.php' file.
      """

    When I try `fin config get DB_PASSWORD`
    Then STDERR should be:
      """
      Error: The constant or variable 'DB_PASSWORD' is not defined in the 'fin-config.php' file.
      """
    And STDOUT should be empty

    When I run `fin config delete DB_HOST --type=constant`
    Then STDOUT should be:
      """
      Success: Deleted the constant 'DB_HOST' from the 'fin-config.php' file.
      """

    When I try `fin config get DB_HOST --type=constant`
    Then STDERR should be:
      """
      Error: The constant 'DB_HOST' is not defined in the 'fin-config.php' file.
      """
    And STDOUT should be empty

    When I run `fin config delete table_prefix --type=variable`
    Then STDOUT should be:
      """
      Success: Deleted the variable 'table_prefix' from the 'fin-config.php' file.
      """

    When I try `fin config get table_prefix --type=variable`
    Then STDERR should be:
      """
      Error: The variable 'table_prefix' is not defined in the 'fin-config.php' file.
      """
    And STDOUT should be empty

  @custom-config-file
  Scenario: Delete an existing fin-custom-config.php constant
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """

    When I run `fin config delete DB_PASSWORD --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Deleted the constant 'DB_PASSWORD' from the 'fin-custom-config.php' file.
      """

    When I try `fin config get DB_PASSWORD --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant or variable 'DB_PASSWORD' is not defined in the 'fin-custom-config.php' file.
      """
    And STDOUT should be empty

    When I run `fin config delete DB_HOST --type=constant --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Deleted the constant 'DB_HOST' from the 'fin-custom-config.php' file.
      """

    When I try `fin config get DB_HOST --type=constant --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant 'DB_HOST' is not defined in the 'fin-custom-config.php' file.
      """
    And STDOUT should be empty

    When I run `fin config delete table_prefix --type=variable --config-file='fin-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Deleted the variable 'table_prefix' from the 'fin-custom-config.php' file.
      """

    When I try `fin config get table_prefix --type=variable --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: The variable 'table_prefix' is not defined in the 'fin-custom-config.php' file.
      """
    And STDOUT should be empty

  Scenario: Delete a non-existent fin-config.php constant or variable
    Given a FIN install
    When I try `fin config delete NEW_CONSTANT`
    Then STDERR should be:
      """
      Error: The constant or variable 'NEW_CONSTANT' is not defined in the 'fin-config.php' file.
      """

    When I try `fin config delete NEW_CONSTANT --type=constant`
    Then STDERR should be:
      """
      Error: The constant 'NEW_CONSTANT' is not defined in the 'fin-config.php' file.
      """

    When I try `fin config delete NEW_CONSTANT --type=variable`
    Then STDERR should be:
      """
      Error: The variable 'NEW_CONSTANT' is not defined in the 'fin-config.php' file.
      """

  @custom-config-file
  Scenario: Delete a non-existent fin-custom-config.php constant or variable
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """

    When I try `fin config delete NEW_CONSTANT --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant or variable 'NEW_CONSTANT' is not defined in the 'fin-custom-config.php' file.
      """

    When I try `fin config delete NEW_CONSTANT --type=constant --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant 'NEW_CONSTANT' is not defined in the 'fin-custom-config.php' file.
      """

    When I try `fin config delete NEW_CONSTANT --type=variable --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: The variable 'NEW_CONSTANT' is not defined in the 'fin-custom-config.php' file.
      """

  Scenario: Ambiguous delete requests for fin-config.php throw errors
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

    When I try `fin config delete SOME_NAME`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fin-config.php' file. Use --type=<type> to disambiguate.
      """

  @custom-config-file
  Scenario: Ambiguous delete requests for fin-custom-config.php throw errors
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

    When I try `fin config delete SOME_NAME --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fin-custom-config.php' file. Use --type=<type> to disambiguate.
      """
