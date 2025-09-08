Feature: Manage fp-config.php file

  Scenario: Getting config should produce error when no config is found
    Given an empty directory

    When I try `fp config list`
    Then STDERR should be:
      """
      Error: 'fp-config.php' not found.
      Either create one manually or use `fp config create`.
      """

    When I try `fp config list --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: 'fp-custom-config.php' not found.
      Either create one manually or use `fp config create`.
      """

    When I try `fp config get SOME_NAME`
    Then STDERR should be:
      """
      Error: 'fp-config.php' not found.
      Either create one manually or use `fp config create`.
      """

    When I try `fp config get SOME_NAME --config-file='fp-custom-config.php'`
    Then STDERR should be:
      """
      Error: 'fp-custom-config.php' not found.
      Either create one manually or use `fp config create`.
      """

    When I try `fp config path`
    Then STDERR should be:
      """
      Error: 'fp-config.php' not found.
      Either create one manually or use `fp config create`.
      """

  Scenario: Get a fp-config.php file path
    Given a FP install

    When I run `fp config path`
    Then STDOUT should contain:
      """
      fp-config.php
      """
