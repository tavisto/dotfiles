#!/usr/bin/php
<?php

// logfix
// by Matthew Kesack <matt.kesack@beatport.com>

define('_WHITE', 29);
define('_GRAY', 30);
define('_RED', 31);
define('_GREEN', 32);
define('_YELLOW', 33);
define('_BLUE', 34);
define('_PURPLE', 35);
define('_CYAN', 36);

$priorities = array(
    0 => 'emerg',
    1 => 'alert',
    2 => 'crit',
    3 => 'error',
    4 => 'warn',
    5 => 'notice',
    6 => 'info',
    7 => 'debug',
);

$priorityColors = array(
    0 => _PURPLE,   // emerg
    1 => _PURPLE,   // alert
    2 => _RED,      // crit
    3 => _RED,      // err
    4 => _YELLOW,   // warn
    5 => _GREEN,    // notice
    6 => _CYAN,     // info
    7 => _BLUE,     // debug
);

$newline = array('\\\\r\\\\n', '\\\\n', '\\r\\n', '\\n', '\r\n', '\n');
$slash = array('\\\\/', '\\\/', '\\/', '\/');
$quote = array('\\"', '\"');

while($in = fgets(STDIN))
{
    // copy input to output to preserve input
    $out = $in;

    // default color
    $color = _WHITE;

    // select color based on Zend_Log priority
    if (preg_match('/^.*?\((\d+)\): /', $in, $match))
    {
        $color = $priorityColors[$match[1]];
    }
    // if PHP wrote the log rather than Zend_Log, select color based on type of log call
    elseif (strstr($in, 'PHP Warning'))
    {
        $color = $priorities[4];
    }
    elseif (preg_match('/^\[.*?\] \[(emerg|alert|crit|error|warn|notice|info|debug)\] /', $in, $match))
    {
        $index = array_search($match[1], $priorities);
        if ($index !== false)
            $color = $priorityColors[$index];
    }
    // handle indicator that file context has changed
    elseif (preg_match('/^==> (.*?) <==$/', $in, $match))
    {
        $color = _WHITE;
        $out = "\033[0m" . PHP_EOL . '    ' . $out . PHP_EOL;
    }

    // insert newlines where appropriate
    $out = str_replace($newline, PHP_EOL, $out);

    // remove slash escaping
    $out = str_replace($slash, '/', $out);

    // remove quote escaping
    $out = str_replace($quote, '"', $out);

    // remove referer
    $out = preg_replace('/, referer: .*?$/', '', $out);

    // strip leading datetimestamp info
    $out = preg_replace('/^(.*?)\(\d+\): /', '', $out);

    // color code by priority
    $out = "\033[$color" . "m$out";

    // fin
    fwrite(STDOUT, $out);
}