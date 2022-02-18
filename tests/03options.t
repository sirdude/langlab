#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";

use options;
use tests;

sub test_options {
	is(add_option('help', 'set a help message.', ''), 1,
		'Add a help option.');
	is(add_option('debug', 'Enable debugging levels(1,2,3,4,5).', 'VALUE'), 1,
		'Add option debugging levels(1,2,3,4,5).');
	is(add_option('filename', 'Set output filename to FILENAME.', 'FILENAME'), 1,
		'Add option filename=FILENAME');

	is(add_option('debug', 5), 1, 'Set debug=5');
	is(query_option('debug'), 5, 'Query debug=5');

	my @ans = ('');
	is(compare_array(parse_options(""), @ans), 1, 'Try to call parse_options with empty str');
	@ans = ("wah");
	is(compare_array(parse_options("wah"), @ans), 1,
		'Try to call parse_options with no options');
	is(parse_options('--test'), 0, 'try to add some non existent option.');
	@ans = ();
	is(compare_array(parse_options('--help'), @ans), 1, "try --help when it's defined.");
	@ans = ("wah");
	my @input = ('--help', '--debug=5', '--filename=fun', 'wah');
	is(compare_array(parse_options(@input), @ans), 1, 'Parse multiple options');
	@input = ('--help', '--filename="My Fun"', 'wah');
	is(compare_array(parse_options(@input), @ans), 1, 'Parse multiple options');

	is(query_option('helper'), 0, 'Check for non existent option: "helper"');
	is(query_option('help'), 1, 'Check for added help option.');
	is(query_option('debug'), "5", 'Check for debug=5 option.');
	is(query_option('filename'), 'My Fun', 'Check for filename="My Fun" option.');

	return 1;
}

sub main {
	init_tests();
	test_options();
	return test_summary();
}

main();
