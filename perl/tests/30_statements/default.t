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
use struct_default;

my ($testast, $output);

sub test_default {
	my %teststr = (
		'data' => {
			'data' => undef,
			'columnnum' => 0,
			'type' => 'block',
			'linenum' => 21
		},
		'case' => 'default',
		'type' => 'case'
	);

	$testast->add_base_node('keyword', 'default', 0, 20);
	$testast->add_base_node('op', '{', 0, 21);
	$testast->add_base_node('op', '}', 0, 22);
	$testast->add_base_node('op', ';', 0, 23);

	is(struct_default::start($testast), 1, 'Testing start of default statement.');
	is(struct_default::get($testast, \%{$output}), 1, 'Testing default {};');

	# print Dumper(\%{$output});
	is(compare_hash(\%teststr, \%{$output}), 1, 'Test output of get default {};'); 

	is(struct_default::start($testast), 0, 'Testing start of default with ;.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_default();
	return test_summary();
}

main();
