<?php

if ( ! class_exists( 'FP_CLI' ) ) {
	return;
}

$fpcli_config_autoloader = __DIR__ . '/vendor/autoload.php';
if ( file_exists( $fpcli_config_autoloader ) ) {
	require_once $fpcli_config_autoloader;
}

FP_CLI::add_command( 'config', 'Config_Command' );
