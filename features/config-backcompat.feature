Feature: Backwards compatibility

  Scenario: fp config get --constant=<constant> --> fp config get <name> --type=constant
    Given a FP install

    When I run `fp config get --constant=DB_NAME`
    Then STDOUT should be:
      """
      fp_cli_test
      """

  Scenario: fp config get --global=<global> --> fp config get <name> --type=variable
    Given a FP install

    When I run `fp config get --global=table_prefix`
    Then STDOUT should be:
      """
      fp_
      """

  Scenario: fp config get --> fp config list
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check`
    Then STDOUT should contain:
      """
      Generated 'fp-config.php' file.
      """

    When I run `fp config get --fields=name,type`
    Then STDOUT should be a table containing rows:
      | name               | type     |
      | DB_NAME            | constant |
      | DB_USER            | constant |
      | DB_PASSWORD        | constant |
      | DB_HOST            | constant |

    When I try `fp config get`
    Then STDOUT should be a table containing rows:
      | name | value | type |
