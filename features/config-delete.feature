Feature: Delete a constant or variable from the fp-config.php file

  Scenario: Delete an existing fp-config.php constant
    Given a FP install

    When I run `fp config delete DB_PASSWORD`
    Then STDOUT should be:
      """
      Success: Deleted the constant 'DB_PASSWORD' from the 'fp-config.php' file.
      """

    When I try `fp config get DB_PASSWORD`
    Then STDERR should be:
      """
      Error: The constant or variable 'DB_PASSWORD' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

    When I run `fp config delete DB_HOST --type=constant`
    Then STDOUT should be:
      """
      Success: Deleted the constant 'DB_HOST' from the 'fp-config.php' file.
      """

    When I try `fp config get DB_HOST --type=constant`
    Then STDERR should be:
      """
      Error: The constant 'DB_HOST' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

    When I run `fp config delete table_prefix --type=variable`
    Then STDOUT should be:
      """
      Success: Deleted the variable 'table_prefix' from the 'fp-config.php' file.
      """

    When I try `fp config get table_prefix --type=variable`
    Then STDERR should be:
      """
      Error: The variable 'table_prefix' is not defined in the 'fp-config.php' file.
      """
    And STDOUT should be empty

  @custom-config-file
  Scenario: Delete an existing fp-custom-config.php constant
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """

    When I run `fp config delete DB_PASSWORD --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Deleted the constant 'DB_PASSWORD' from the 'fp-custom-config.php' file.
      """

    When I try `fp config get DB_PASSWORD --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant or variable 'DB_PASSWORD' is not defined in the 'fp-custom-config.php' file.
      """
    And STDOUT should be empty

    When I run `fp config delete DB_HOST --type=constant --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Deleted the constant 'DB_HOST' from the 'fp-custom-config.php' file.
      """

    When I try `fp config get DB_HOST --type=constant --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant 'DB_HOST' is not defined in the 'fp-custom-config.php' file.
      """
    And STDOUT should be empty

    When I run `fp config delete table_prefix --type=variable --config-file='fp-custom-config.php'`
    Then STDOUT should be:
      """
      Success: Deleted the variable 'table_prefix' from the 'fp-custom-config.php' file.
      """

    When I try `fp config get table_prefix --type=variable --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: The variable 'table_prefix' is not defined in the 'fp-custom-config.php' file.
      """
    And STDOUT should be empty

  Scenario: Delete a non-existent fp-config.php constant or variable
    Given a FP install
    When I try `fp config delete NEW_CONSTANT`
    Then STDERR should be:
      """
      Error: The constant or variable 'NEW_CONSTANT' is not defined in the 'fp-config.php' file.
      """

    When I try `fp config delete NEW_CONSTANT --type=constant`
    Then STDERR should be:
      """
      Error: The constant 'NEW_CONSTANT' is not defined in the 'fp-config.php' file.
      """

    When I try `fp config delete NEW_CONSTANT --type=variable`
    Then STDERR should be:
      """
      Error: The variable 'NEW_CONSTANT' is not defined in the 'fp-config.php' file.
      """

  @custom-config-file
  Scenario: Delete a non-existent fp-custom-config.php constant or variable
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """

    When I try `fp config delete NEW_CONSTANT --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant or variable 'NEW_CONSTANT' is not defined in the 'fp-custom-config.php' file.
      """

    When I try `fp config delete NEW_CONSTANT --type=constant --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: The constant 'NEW_CONSTANT' is not defined in the 'fp-custom-config.php' file.
      """

    When I try `fp config delete NEW_CONSTANT --type=variable --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: The variable 'NEW_CONSTANT' is not defined in the 'fp-custom-config.php' file.
      """

  Scenario: Ambiguous delete requests for fp-config.php throw errors
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

    When I try `fp config delete SOME_NAME`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fp-config.php' file. Use --type=<type> to disambiguate.
      """

  @custom-config-file
  Scenario: Ambiguous delete requests for fp-custom-config.php throw errors
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

    When I try `fp config delete SOME_NAME --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fp-custom-config.php' file. Use --type=<type> to disambiguate.
      """
