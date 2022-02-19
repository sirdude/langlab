#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib "./lib";
use lib "./lib/sweet";
use lib "../lib";
use lib "../lib/sweet";
use lib "../../lib";
use lib "../../lib/sweet";

use ast;
use tests;
use struct_while;

my ($testast, $output);

sub test_simple_while {
	my %teststr = {
		'test' => {
			'type' => 'expression'
		},
		'data' => {
			'type' => 'block',
			'columnnum' => 0,
			'data' => undef,
			'linenum' => 24
		},
		'type' => 'while'
	};

	$testast->add_base_node('keyword', 'while', 0, 20);
	$testast->add_base_node('op', '(', 0, 21);
	$testast->add_base_node('int', '1', 0, 22);
	$testast->add_base_node('op', ')', 0, 23);
	$testast->add_base_node('op', '{', 0, 24);
	$testast->add_base_node('op', '}', 0, 25);

	is(struct_while::start($testast), 1, 'Testing start of while statement.');
	is(struct_while::get($testast, \%{$output}), 1, 'Testing while (1) {};');

	# print Dumper(\%{$output});
	is(compare_hash(\%{$output}, \%teststr), 1, 'Test output of while (1) {}');

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
