#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "./lib/sweet";
use lib "../lib";
use lib "../lib/sweet";
use lib "../../lib";
use lib "../../lib/sweet";

use ast;
use tests;
use struct_do_while;

my ($testast, $output);
my %teststr = {
	'data' => {
		'data' => undef,
		'type' => 'block',
		'linenum' => 21,
		'columnnum' => 0
	},
	'type' => 'do_while',
	'test' => {
		'type' => 'expression'
	}
};

sub test_simple_while {
	$testast->add_base_node('keyword', 'do', 0, 20);
	$testast->add_base_node('op', '{', 0, 21);
	$testast->add_base_node('op', '}', 0, 22);
	$testast->add_base_node('keyword', 'while', 0, 23);
	$testast->add_base_node('op', '(', 0, 24);
	$testast->add_base_node('int', '1', 0, 25);
	$testast->add_base_node('op', ')', 0, 26);

	is(struct_do_while::start($testast), 1, 'Testing start of do while statement.');
	is(struct_do_while::get($testast, \%{$output}), 1, 'Testing do {} while (1);');
	is(%teststr, \%{$output}, 'Testing output of do {} while (1);');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_simple_while();
	return test_summary();
}

main();
