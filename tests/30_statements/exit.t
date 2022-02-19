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
use struct_exit;
use Data::Dumper;

my ($testast, $output);

sub test_exit_no_arg {
	my %teststr = {
		'data' => 'void',
		'type' => 'exit'
	};

	$testast->add_base_node('keyword', 'exit', 0, 20);
	$testast->add_base_node('op', ';', 0, 21);

	is(struct_exit::start($testast), 1, 'Testing start exit');
	is(struct_exit::get($testast, \%{$output}), 1, 'Testing get exit');

	# print Dumper(\%{$output});
	is(compare_hash(%teststr, \%{$output}), 1, 'Testing output of get exit.');

	is(struct_exit::start($testast), 0, 'Testing invalid start of exit.');
	is(struct_exit::get($testast, \%{$output}), 0, 'Testing get exit invalid;');

	$testast->clear();
	return 1;
}

sub test_exit_int {
	my %teststr = {
		'data' => {
			type => 'expression'
		},
		'type' => 'exit'
	};

	$testast->add_base_node('keyword', 'exit', 0, 33);
	$testast->add_base_node('int', '1', 0, 34);
	$testast->add_base_node('op', ';', 0, 35);

	is(struct_exit::get($testast, \%{$output}), 1, 'Testing get exit 5;');

	# print Dumper(\%{$output});
	is(compare_hash(%teststr, \%{$output}), 1, 'Testing output of get exit.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_exit_no_arg();
	test_exit_int();
	return test_summary();
}

main();
