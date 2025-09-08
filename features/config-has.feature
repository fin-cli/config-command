Feature: Check whether the fp-config.php file or the fp-custom-config.php file has a certain constant or variable

  Scenario: Check the existence of an existing fp-config.php constant or variable
    Given a FP install

    When I run `fp config has DB_NAME`
    Then STDOUT should be empty
    And the return code should be 0

    When I run `fp config has DB_USER --type=constant`
    Then STDOUT should be empty
    And the return code should be 0

    When I run `fp config has table_prefix --type=variable`
    Then STDOUT should be empty
    And the return code should be 0

  Scenario: Check for the existance of an existing fp-config.php constant in a read-only file system
    Given a FP install

    When I run `chmod -w fp-config.php`
    And I try `fp config has DB_NAME`
    Then STDOUT should be empty
    And the return code should be 0

  @custom-config-file
  Scenario: Check the existence of an existing fp-custom-config.php constant or variable
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """
    When I run `fp config has DB_NAME --config-file='fp-custom-config.php'`
    Then STDOUT should be empty
    And the return code should be 0

    When I run `fp config has DB_USER --type=constant --config-file='fp-custom-config.php'`
    Then STDOUT should be empty
    And the return code should be 0

    When I run `fp config has table_prefix --type=variable --config-file='fp-custom-config.php'`
    Then STDOUT should be empty
    And the return code should be 0

  Scenario: Check the existence of a non-existing fp-config.php constant or variable
    Given a FP install

    When I try `fp config has FOO`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fp config has FOO --type=constant`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fp config has FOO --type=variable`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fp config has DB_HOST --type=variable`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fp config has table_prefix --type=constant`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

  @custom-config-file
  Scenario: Check the existence of a non-existing fp-custom-config.php constant or variable
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """

    When I try `fp config has FOO --config-file='fp-custom-config.php'`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fp config has FOO --type=constant --config-file='fp-custom-config.php'`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fp config has FOO --type=variable --config-file='fp-custom-config.php'`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fp config has DB_HOST --type=variable --config-file='fp-custom-config.php'`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

    When I try `fp config has table_prefix --type=constant --config-file='fp-custom-config.php'`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 1

  Scenario: Ambiguous check for fp-config.php throw errors
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

    When I try `fp config has SOME_NAME`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fp-config.php' file. Use --type=<type> to disambiguate.
      """

  @custom-config-file
  Scenario: Ambiguous check for fp-custom-config.php throw errors
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

    When I try `fp config has SOME_NAME --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: Found both a constant and a variable 'SOME_NAME' in the 'fp-custom-config.php' file. Use --type=<type> to disambiguate.
      """
