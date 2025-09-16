<?php

if ( ! class_exists( 'FIN_CLI' ) ) {
	return;
}

$fincli_config_autoloader = __DIR__ . '/vendor/autoload.php';
if ( file_exists( $fincli_config_autoloader ) ) {
	require_once $fincli_config_autoloader;
}

FIN_CLI::add_command( 'config', 'Config_Command' );
