Feature: Refresh the salts in the fin-config.php file

  Scenario: Salts are created properly in fin-config.php when none initially exist
    Given a FIN install

    When I try `fin config get AUTH_KEY --type=constant`
    Then STDERR should contain:
      """
      The constant 'AUTH_KEY' is not defined in the 'fin-config.php' file.
      """

    When I run `fin config shuffle-salts`
    Then STDOUT should contain:
      """
      Shuffled the salt keys.
      """
    And the fin-config.php file should contain:
      """
      define( 'AUTH_KEY'
      """

  @custom-config-file
  Scenario: Salts are created properly in fin-custom-config.php when none initially exist
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --skip-salts=true --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """
    When I try `fin config get AUTH_KEY --type=constant --config-file='fin-custom-config.php'`
    Then STDERR should contain:
      """
      The constant 'AUTH_KEY' is not defined in the 'fin-custom-config.php' file.
      """

    When I run `fin config shuffle-salts --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Shuffled the salt keys.
      """
    And the fin-custom-config.php file should contain:
      """
      define( 'AUTH_KEY'
      """

  Scenario: Shuffle the salts
    Given a FIN install

    When I run `fin config shuffle-salts`
    Then STDOUT should contain:
      """
      Shuffled the salt keys.
      """
    And the fin-config.php file should contain:
      """
      define( 'AUTH_KEY'
      """
    And the fin-config.php file should contain:
      """
      define( 'LOGGED_IN_SALT'
      """

    When I run `fin config get AUTH_KEY --type=constant`
    Then save STDOUT as {AUTH_KEY_ORIG}
    When I run `fin config get LOGGED_IN_SALT --type=constant`
    Then save STDOUT as {LOGGED_IN_SALT_ORIG}

    When I run `fin config shuffle-salts`
    Then STDOUT should contain:
      """
      Shuffled the salt keys.
      """
    And the fin-config.php file should not contain:
      """
      {AUTH_KEY_ORIG}
      """
    And the fin-config.php file should not contain:
      """
      {LOGGED_IN_SALT_ORIG}
      """

  Scenario: Shuffle specific salts only
    Given a FIN install
    When I run `fin config shuffle-salts`
    Then STDOUT should contain:
      """
      Shuffled the salt keys.
      """
    And the fin-config.php file should contain:
      """
      define( 'AUTH_KEY'
      """
    And the fin-config.php file should contain:
      """
      define( 'LOGGED_IN_SALT'
      """
    And the fin-config.php file should contain:
      """
      define( 'NONCE_KEY'
      """

    When I run `fin config get AUTH_KEY --type=constant`
    Then save STDOUT as {AUTH_KEY_ORIG}
    When I run `fin config get LOGGED_IN_SALT --type=constant`
    Then save STDOUT as {LOGGED_IN_SALT_ORIG}
    When I run `fin config get NONCE_KEY --type=constant`
    Then save STDOUT as {NONCE_KEY_ORIG}

    When I run `fin config shuffle-salts AUTH_KEY NONCE_KEY`
    Then STDOUT should contain:
      """
      Shuffled 2 of 2 salts.
      """
    And the fin-config.php file should not contain:
      """
      {AUTH_KEY_ORIG}
      """
    And the fin-config.php file should contain:
      """
      {LOGGED_IN_SALT_ORIG}
      """
    And the fin-config.php file should not contain:
      """
      {NONCE_KEY_ORIG}
      """

  @custom-config-file
  Scenario: Shuffle the salts in custom config file
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Generated 'fin-custom-config.php' file.
      """

    When I run `fin config shuffle-salts --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Shuffled the salt keys.
      """
    And the fin-custom-config.php file should contain:
      """
      define( 'AUTH_KEY'
      """
    And the fin-custom-config.php file should contain:
      """
      define( 'LOGGED_IN_SALT'
      """

    When I run `fin config get AUTH_KEY --type=constant --config-file='fin-custom-config.php'`
    Then save STDOUT as {AUTH_KEY_ORIG}
    When I run `fin config get LOGGED_IN_SALT --type=constant --config-file='fin-custom-config.php'`
    Then save STDOUT as {LOGGED_IN_SALT_ORIG}

    When I run `fin config shuffle-salts --config-file='fin-custom-config.php'`
    Then STDOUT should contain:
      """
      Shuffled the salt keys.
      """
    And the fin-custom-config.php file should not contain:
      """
      {AUTH_KEY_ORIG}
      """
    And the fin-custom-config.php file should not contain:
      """
      {LOGGED_IN_SALT_ORIG}
      """

  @require-php-7.0
  Scenario: Force adding missing salts to shuffle
    Given a FIN install
    When I run `fin config shuffle-salts`
    Then STDOUT should contain:
      """
      Shuffled the salt keys.
      """
    And the fin-config.php file should contain:
      """
      define( 'AUTH_KEY'
      """
    And the fin-config.php file should contain:
      """
      define( 'LOGGED_IN_SALT'
      """
    And the fin-config.php file should not contain:
      """
      define( 'NEW_KEY'
      """

    When I run `fin config get AUTH_KEY --type=constant`
    Then save STDOUT as {AUTH_KEY_ORIG}
    When I run `fin config get LOGGED_IN_SALT --type=constant`
    Then save STDOUT as {LOGGED_IN_SALT_ORIG}

    When I try `fin config shuffle-salts AUTH_KEY NEW_KEY`
    Then STDOUT should contain:
      """
      Shuffled 1 of 2 salts (1 skipped).
      """
    And STDERR should contain:
      """
      Warning: Could not shuffle the unknown key 'NEW_KEY'.
      """
    And the fin-config.php file should not contain:
      """
      {AUTH_KEY_ORIG}
      """
    And the fin-config.php file should contain:
      """
      {LOGGED_IN_SALT_ORIG}
      """
    And the fin-config.php file should not contain:
      """
      define( 'NEW_KEY'
      """

    When I run `fin config get AUTH_KEY --type=constant`
    Then save STDOUT as {AUTH_KEY_ORIG}

    When I run `fin config shuffle-salts AUTH_KEY NEW_KEY --force`
    Then STDOUT should contain:
      """
      Shuffled 2 of 2 salts.
      """
    And the fin-config.php file should not contain:
      """
      {AUTH_KEY_ORIG}
      """
    And the fin-config.php file should contain:
      """
      {LOGGED_IN_SALT_ORIG}
      """
    And the fin-config.php file should contain:
      """
      define( 'NEW_KEY'
      """

    When I run `fin config get AUTH_KEY --type=constant`
    Then save STDOUT as {AUTH_KEY_ORIG}
    When I run `fin config get NEW_KEY --type=constant`
    Then save STDOUT as {NEW_KEY_ORIG}

    When I run `fin config shuffle-salts AUTH_KEY NEW_KEY --force`
    Then STDOUT should contain:
      """
      Shuffled 2 of 2 salts.
      """
    And the fin-config.php file should not contain:
      """
      {AUTH_KEY_ORIG}
      """
    And the fin-config.php file should contain:
      """
      {LOGGED_IN_SALT_ORIG}
      """
    And the fin-config.php file should contain:
      """
      define( 'NEW_KEY'
      """
    And the fin-config.php file should not contain:
      """
      {NEW_KEY_ORIG}
      """
