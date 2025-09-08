Feature: Determine whether the value of a constant or variable defined in fp-config.php is true.
  Background:
    Given an empty directory
    And a fp-includes/version.php file:
      """
      <?php
      $fp_version = '6.3';
      """
    And a fp-config.php file:
      """
      <?php
      /* Truth tests. */
      define( 'FP_TRUTH', true );
      define( 'FP_STR_TRUTH', 'true' );
      define( 'FP_STR_MISC', 'foobar' );
      define( 'FP_STR_FALSE', 'false' );
      $fp_str_var_truth = 'true';
      $fp_str_var_false = 'false';
      $fp_str_var_misc = 'foobar';

      /* False tests. */
      define( 'FP_FALSE', false );
      define( 'FP_STR_ZERO', '0' );
      define( 'FP_NUM_ZERO', 0 );
      $fp_variable_bool_false = false;

      require_once ABSPATH . 'fp-settings.php';
      require_once ABSPATH . 'includes-file.php';
      """
    And a includes-file.php file:
      """
      <?php
      define( 'FP_INC_TRUTH', true );
      define( 'FP_INC_FALSE', false );
      """

  Scenario Outline: Get the value of a variable whose value is true
    When I try `fp config is-true <variable>`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 0

    Examples:
      | variable          |
      | FP_TRUTH          |
      | FP_STR_TRUTH      |
      | FP_STR_MISC       |
      | FP_STR_FALSE      |
      | fp_str_var_truth  |
      | fp_str_var_false  |
      | fp_str_var_misc   |

  Scenario Outline: Get the value of a variable whose value is not true
    When I try `fp config is-true <variable>`
    Then STDOUT should be empty
    And the return code should be 1

    Examples:
      | variable               |
      | FP_FALSE               |
      | FP_STRZERO             |
      | FP_NUMZERO             |
      | fp_variable_bool_false |

  Scenario Outline: Test for values which do not exist
    When I try `fp config is-true <variable> --type=<type>`
    Then STDOUT should be empty
    And the return code should be 1

    Examples:
      | variable             | type     |
      | FP_TEST_CONSTANT_DNE | all      |
      | fp_test_variable_dne | variable |

  Scenario: Test for correct functionality with included PHP files.
    When I try `fp config is-true FP_INC_TRUTH`
    Then STDOUT should be empty
    And STDERR should be empty
    And the return code should be 0

    When I try `fp config is-true FP_INC_FALSE`
    Then STDOUT should be empty
    And the return code should be 1
