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
use struct_case;

my ($testast, $output);

sub test_case {
	my %teststr = {
		'value' => {
			'type' => 'var',
			'data' => 'x' },
		'type' => 'case',
		'size' => 0,
		'data' => {
			'columnnum' => 0,
			'linenum' => 20,
			'data' => undef,
			'type' => 'block'
		},
		'scope' => 0,
		'current' => 0
	};

	$testast->add_base_node('keyword', 'case', 0, 18);
	$testast->add_base_node('ident', 'x', 0, 19);
	$testast->add_base_node('op', '{', 0, 20);
	$testast->add_base_node('op', '}', 0, 22);
	$testast->add_base_node('op', ';', 0, 22);

	is(struct_case::start($testast), 1, 'Testing start of case statement.');
	is(struct_case::get($testast, \%{$output}), 1, 'Testing case x {};');

	# print Dumper(\%{$output});
	is(%teststr, \%{$output}, 1, 'Testing output of get case x {};');

	is(struct_case::start($testast), 0, 'Testing start of case with ;.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_case();
	return test_summary();
}

main();
