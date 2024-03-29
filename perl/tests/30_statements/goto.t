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
use struct_goto;

my ($testast, $output);

sub test_goto {
	my %teststr = (
		'type' => 'goto',
		'data' => 'FUN'
	);
	$testast->add_base_node('keyword', 'goto', 0, 20);
	$testast->add_base_node('label', 'FUN', 0, 21);
	$testast->add_base_node('op', ';', 0, 22);

	is(struct_goto::start($testast), 1, 'Testing start goto');
	is(struct_goto::get($testast, \%{$output}), 1, 'Testing get goto');

	# print Dumper(\%{$output});
	is(compare_hash(\%{$output}, \%teststr), 1, 'Testing output of get goto');

	is(struct_goto::start($testast), 0, 'Testing invalid start of goto.');
	is(struct_goto::get($testast, \%{$output}), 0, 'Testing get goto invalid;');

	$testast->clear();
	return 1;
}

sub test_goto_no_label {
	$testast->add_base_node('keyword', 'goto', 0, 34);
	$testast->add_base_node('op', ';', 0, 35);

	is(struct_goto::get($testast, \%{$output}), 0, 'Testing get goto with no label');
	$testast->clear();
	return 1;
}

sub test_goto_int {
	$testast->add_base_node('keyword', 'goto', 0, 43);
	$testast->add_base_node('int', '5', 0, 44);
	$testast->add_base_node('op', ';', 0, 45);

	is(struct_goto::get($testast, \%{$output}), 0, 'Testing get goto with int instead of label');
	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_goto();
	test_goto_no_label();
	test_goto_int();
	return test_summary();
}

main();
