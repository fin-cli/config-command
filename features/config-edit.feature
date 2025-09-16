Feature: Edit a fin-config file

  Scenario: Edit a fin-config.php file
    Given a FIN install

    When I try `EDITOR='ex -i NONE -c q!' fin config edit;`
    Then STDERR should contain:
      """
      Warning: No changes made to fin-config.php, aborted.
      """
    And the return code should be 0

  @custom-config-file
  Scenario: Edit a fin-custom-config.php file
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """

    When I try `EDITOR='ex -i NONE -c q!' fin config edit --config-file=fin-custom-config.php`
    Then STDERR should contain:
      """
      No changes made to fin-custom-config.php, aborted.
      """
    And the return code should be 0
