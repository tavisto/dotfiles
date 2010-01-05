#!/usr/bin/php
<?php

	$urls = file_get_contents( $argv[1] );
	$aUrls = explode( PHP_EOL , $urls );
	array_pop( $aUrls ); // Remove the last blank line
	foreach( $aUrls as $sUrl )
	{
		$sFilename = md5( strtolower( $sUrl ) );
		$sDir = substr( $sFilename , 0, 2 );
		echo $sUrl . '	' . $sDir . '/'. $sFilename . '.cache.gz' . PHP_EOL ;
	}
?>
