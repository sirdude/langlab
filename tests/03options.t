#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 15;
use Test::Exception;

use lib "./lib";
use lib "../lib";
use options;

sub main {
	is(add_option('help', 'set a help message.', ''), 1,
		'Add a help option');
	is(add_option('debug', 'Enable debugging levels(1,2,3,4,5)', "VALUE"), 1,
		'Add option debugging levels(1,2,3,4,5)');
	is(add_option('filename', 'Set output filename to FILENAME',
		"FILENAME"), 1, 'Add option filename=FILENAME');

	is(set_option('debug', 5), 1, 'Set debug=5');
	is(query_option('debug'), 5, 'Query debug=5');

	my @ans = ("");
	is(parse_options(""), @ans, 'Try to call parse_options with empty str');
	@ans = ("wah");
	is(parse_options("wah"), @ans,
		'Try ot call parse_options with no options');
	is(parse_options('--test'), 0, 'try to add some non existant option.');
	@ans = ();
	is(parse_options('--help'), @ans, "try --help when it's defined.");
	@ans = ("wah");
	my @input = ('--help', '--debug=5', '--filename=fun', 'wah');
	is(parse_options(@input), @ans, 'Parse multiple options');
	@input = ('--help', '--filename="My Fun"', 'wah');
	is(parse_options(@input), @ans, 'Parse multiple options');

	is(query_option('helper'), 0, 'Check for non existant option: "helper"');
	is(query_option('help'), 1, 'Check for added help option.');
	is(query_option('debug'), "5", 'Check for debug=5 option.');
	is(query_option('filename'), 'My Fun',
		'Check for filename="My Fun" option.');
}

main();
