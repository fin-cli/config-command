Feature: Determine whether the value of a constant or variable defined in fin-config.php is true.
  Background:
    Given an empty directory
    And a fin-includes/version.php file:
      """
      <?php
      $fin_version = '6.3';
      """
    And a fin-config.php file:
      """
      <?php
      /* Truth tests. */
      define( 'FIN_TRUTH', true );
      define( 'FIN_STR_TRUTH', 'true' );
      define( 'FIN_STR_MISC', 'foobar' );
      define( 'FIN_STR_FALSE', 'false' );
      $fin_str_var_truth = 'true';
      $fin_str_var_false = 'false';
      $fin_str_var_misc = 'foobar';

      /* False tests. */
      define( 'FIN_FALSE', false );
      define( 'FIN_STR_ZERO', '0' );
      define( 'FIN_NUM_ZERO', 0 );
      $fin_variable_bool_false = false;

      require_once ABSPATH . 'fin-settings.php';
      require_once ABSPATH . 'includes-file.php';
      """
    And a includes-file.php file:
      """
      <?php
      define( 'FIN_INC_TRUTH', true );
      define( 'FIN_INC_FALSE', false );
      """

  Scenario Outline: Get the value of a variable whose value is true
    When I try `fin config is-true <variable>`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 0

    Examples:
      | variable          |
      | FIN_TRUTH          |
      | FIN_STR_TRUTH      |
      | FIN_STR_MISC       |
      | FIN_STR_FALSE      |
      | fin_str_var_truth  |
      | fin_str_var_false  |
      | fin_str_var_misc   |

  Scenario Outline: Get the value of a variable whose value is not true
    When I try `fin config is-true <variable>`
    Then STDOUT should be empty
    And the return code should be 1

    Examples:
      | variable               |
      | FIN_FALSE               |
      | FIN_STRZERO             |
      | FIN_NUMZERO             |
      | fin_variable_bool_false |

  Scenario Outline: Test for values which do not exist
    When I try `fin config is-true <variable> --type=<type>`
    Then STDOUT should be empty
    And the return code should be 1

    Examples:
      | variable             | type     |
      | FIN_TEST_CONSTANT_DNE | all      |
      | fin_test_variable_dne | variable |

  Scenario: Test for correct functionality with included PHP files.
    When I try `fin config is-true FIN_INC_TRUTH`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 0

    When I try `fin config is-true FIN_INC_FALSE`
    Then STDOUT should be empty
    And the return code should be 1
