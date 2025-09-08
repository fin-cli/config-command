Feature: Edit a fp-config file

  Scenario: Edit a fp-config.php file
    Given a FP install

    When I try `EDITOR='ex -i NONE -c q!' fp config edit;`
    Then STDERR should contain:
      """
      Warning: No changes made to fp-config.php, aborted.
      """
    And the return code should be 0

  @custom-config-file
  Scenario: Edit a fp-custom-config.php file
    Given an empty directory
    And FP files

    When I run `fp config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fp-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fp-custom-config.php' file.
      """

    When I try `EDITOR='ex -i NONE -c q!' fp config edit --config-file=fp-custom-config.php`
    Then STDERR should contain:
      """
      No changes made to fp-custom-config.php, aborted.
      """
    And the return code should be 0
