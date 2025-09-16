Feature: Manage fin-config.php file

  Scenario: Getting config should produce error when no config is found
    Given an empty directory

    When I try `fin config list`
    Then STDERR should be:
      """
      Error: 'fin-config.php' not found.
      Either create one manually or use `fin config create`.
      """

    When I try `fin config list --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: 'fin-custom-config.php' not found.
      Either create one manually or use `fin config create`.
      """

    When I try `fin config get SOME_NAME`
    Then STDERR should be:
      """
      Error: 'fin-config.php' not found.
      Either create one manually or use `fin config create`.
      """

    When I try `fin config get SOME_NAME --config-file='fin-custom-config.php'`
    Then STDERR should be:
      """
      Error: 'fin-custom-config.php' not found.
      Either create one manually or use `fin config create`.
      """

    When I try `fin config path`
    Then STDERR should be:
      """
      Error: 'fin-config.php' not found.
      Either create one manually or use `fin config create`.
      """

  Scenario: Get a fin-config.php file path
    Given a FIN install

    When I run `fin config path`
    Then STDOUT should contain:
      """
      fin-config.php
      """
