Feature: Backwards compatibility

  Scenario: fin config get --constant=<constant> --> fin config get <name> --type=constant
    Given a FIN install

    When I run `fin config get --constant=DB_NAME`
    Then STDOUT should be:
      """
      fin_cli_test
      """

  Scenario: fin config get --global=<global> --> fin config get <name> --type=variable
    Given a FIN install

    When I run `fin config get --global=table_prefix`
    Then STDOUT should be:
      """
      fin_
      """

  Scenario: fin config get --> fin config list
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check`
    Then STDOUT should contain:
      """
      Generated 'fin-config.php' file.
      """

    When I run `fin config get --fields=name,type`
    Then STDOUT should be a table containing rows:
      | name               | type     |
      | DB_NAME            | constant |
      | DB_USER            | constant |
      | DB_PASSWORD        | constant |
      | DB_HOST            | constant |

    When I try `fin config get`
    Then STDOUT should be a table containing rows:
      | name | value | type |
