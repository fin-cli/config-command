Feature: Create a fin-config file

  # Skipped for SQLite because `fin db create` does not yet support SQLite.
  # See https://github.com/fin-cli/db-command/issues/234
  # and https://github.com/fin-cli/config-command/issues/167
  @require-mysql
  Scenario: No fin-config.php
    Given an empty directory
    And FIN files

    When I try `fin core is-installed`
    Then the return code should be 1
    And STDERR should not be empty

    When I run `fin core version`
    Then STDOUT should not be empty

    When I try `fin core install`
    Then the return code should be 1
    And STDERR should be:
      """
      Error: 'fin-config.php' not found.
      Either create one manually or use `fin config create`.
      """

    Given a fin-config-extra.php file:
      """
      define( 'FIN_DEBUG_LOG', true );
      """

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --extra-php < fin-config-extra.php`
    Then the fin-config.php file should contain:
      """
      'AUTH_SALT',
      """
    And the fin-config.php file should contain:
      """
      define( 'FIN_DEBUG_LOG', true );
      """

    When I try the previous command again
    Then the return code should be 1
    And STDERR should not be empty

    Given a fin-config-extra.php file:
      """
      define( 'FIN_DEBUG_LOG', true );
      """

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --config-file='fin-custom-config.php' --extra-php < fin-config-extra.php`
    Then the fin-custom-config.php file should contain:
      """
      'AUTH_SALT',
      """
    And the fin-custom-config.php file should contain:
      """
      define( 'FIN_DEBUG_LOG', true );
      """

    When I try the previous command again
    Then the return code should be 1
    And STDERR should not be empty

    When I run `fin db create`
    Then STDOUT should not be empty

    When I try `fin option get option home`
    Then STDERR should contain:
      """
      Error: The site you have requested is not installed
      """

    When I run `rm fin-custom-config.php`
    Then the fin-custom-config.php file should not exist

    Given a fin-config-extra.php file:
      """
      define( 'FIN_DEBUG', true );
      """

    When I run `fin config create {CORE_CONFIG_SETTINGS} --config-file='fin-custom-config.php' --extra-php < fin-config-extra.php`
    Then the fin-custom-config.php file should contain:
      """
      define( 'FIN_DEBUG', true );
      """
    And the fin-custom-config.php file should contain:
      """
      define( 'FIN_DEBUG', false );
      """

    When I try `fin version`
    Then STDERR should not contain:
      """
      Constant FIN_DEBUG already defined
      """

  @require-fin-4.0
  Scenario: No fin-config.php and FINLANG
    Given an empty directory
    And FIN files
    And a fin-config-extra.php file:
      """
      define( 'FIN_DEBUG_LOG', true );
      """

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --extra-php < fin-config-extra.php`
    Then the fin-config.php file should not contain:
      """
      define( 'FINLANG', '' );
      """

  Scenario: Configure with existing salts
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check --skip-salts --extra-php < /dev/null`
    Then the fin-config.php file should not contain:
      """
      define('AUTH_SALT',
      """
    And the fin-config.php file should not contain:
      """
      define( 'AUTH_SALT',
      """

  Scenario: Configure with invalid table prefix
    Given an empty directory
    And FIN files

    When I try `fin config create --skip-check --dbname=somedb --dbuser=someuser --dbpass=somepassword --dbprefix=""`
    Then the return code should be 1
    And STDERR should contain:
      """
      Error: --dbprefix cannot be empty
      """

    When I try `fin config create --skip-check --dbname=somedb --dbuser=someuser --dbpass=somepassword --dbprefix=" "`
    Then the return code should be 1
    And STDERR should contain:
      """
      Error: --dbprefix can only contain numbers, letters, and underscores.
      """

    When I try `fin config create --skip-check --dbname=somedb --dbuser=someuser --dbpass=somepassword --dbprefix="fin-"`
    Then the return code should be 1
    And STDERR should contain:
      """
      Error: --dbprefix can only contain numbers, letters, and underscores.
      """

  @require-mysql
  Scenario: Configure with invalid database credentials
    Given an empty directory
    And FIN files

    When I try `fin config create --dbname=somedb --dbuser=someuser --dbpass=somepassword`
    Then the return code should be 1
    And STDERR should contain:
      """
      Error: Database connection error
      """

  @require-mysql
  Scenario: Configure with database credentials using socket path
    Given an empty directory
    And FIN files
    And a find-socket.php file:
      """
      <?php
      // The FIN_CLI_TEST_DBSOCKET variable can be set in the environment to
      // override the default locations and will take precedence.
      if ( ! empty( getenv( 'FIN_CLI_TEST_DBSOCKET' ) ) ) {
        echo getenv( 'FIN_CLI_TEST_DBSOCKET' );
        exit(0);
      }
      // From within Behat, the FIN_CLI_TEST_DBSOCKET will be mapped to the internal
      // DB_SOCKET variable, as Behat pushes a new environment context.
      $locations = [
        '{DB_SOCKET}',
        '/var/run/mysqld/mysqld.sock',
        '/tmp/mysql.sock',
      ];
      foreach ( $locations as $location ) {
        if ( ! empty( $location ) && file_exists( $location ) ) {
          echo $location;
          exit(0);
        }
      }
      echo 'No socket found';
      exit(1);
      """

    When I run `php find-socket.php`
    Then save STDOUT as {SOCKET}
    And STDOUT should not be empty

    When I try `wget -O {RUN_DIR}/install-package-tests https://raw.githubusercontent.com/fin-cli/fin-cli-tests/main/bin/install-package-tests`
    Then STDERR should contain:
      """
      install-package-tests' saved
      """

    When I run `chmod +x {RUN_DIR}/install-package-tests`
    Then STDERR should be empty

    # We try to account for the warnings we get for passing the password on the command line.
    When I try `MYSQL_HOST=localhost FIN_CLI_TEST_DBHOST='localhost:{SOCKET}' FIN_CLI_TEST_DBROOTPASS='root' {RUN_DIR}/install-package-tests`
    Then STDOUT should contain:
      """
      Detected MySQL
      """

    When I run `fin config create --dbname='{DB_NAME}' --dbuser='{DB_USER}' --dbpass='{DB_PASSWORD}' --dbhost='localhost:{SOCKET}'`
    Then the fin-config.php file should contain:
      """
      define( 'DB_HOST', 'localhost:{SOCKET}' );
      """

  @require-php-7.0
  Scenario: Configure with salts generated
    Given an empty directory
    And FIN files

    When I run `fin config create {CORE_CONFIG_SETTINGS} --skip-check`
    Then the fin-config.php file should contain:
      """
      define( 'AUTH_SALT',
      """

  Scenario: Values are properly escaped to avoid creating invalid config files
    Given an empty directory
    And FIN files

    When I run `fin config create --skip-check --dbname=somedb --dbuser=someuser --dbpass="PasswordWith'SingleQuotes'"`
    Then the fin-config.php file should contain:
      """
      define( 'DB_PASSWORD', 'PasswordWith\'SingleQuotes\'' )
      """

    When I run `fin config get DB_PASSWORD`
    Then STDOUT should be:
      """
      PasswordWith'SingleQuotes'
      """

  @require-mysql @require-mysql-5.7
  Scenario: Configure with required SSL connection
    Given an empty directory
    And FIN files
    And I run `MYSQL_PWD='{DB_ROOT_PASSWORD}' MYSQL_HOST='{MYSQL_HOST}' MYSQL_TCP_PORT='{MYSQL_PORT}' mysql -u root -e "CREATE USER IF NOT EXISTS 'fin_cli_test_ssl'@'%' IDENTIFIED BY 'password2' REQUIRE SSL;"`

    When I try `fin config create --dbhost=127.0.0.1 --dbname=fin_cli_test --dbuser=fin_cli_test_ssl --dbpass=password2 --ssl`
    Then the return code should be 0
    And the fin-config.php file should contain:
      """
      define( 'DB_USER', 'fin_cli_test_ssl' )
      """
