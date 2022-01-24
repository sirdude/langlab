#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_bracket;

my ($testast, $output);

sub test_empty_bracket {
	$testast->add_base_node('op', '(', 0, 18);
	$testast->add_base_node('op', ')', 0, 19);
	$testast->add_base_node('op', ';', 0, 20);

	is(struct_bracket::start($testast), 1, 'Testing start of bracketed expression.');
	is(struct_bracket::get($testast, $output), 1, 'Testing get empty bracketed expression.');

	$testast->clear();
	return 1;
}

sub test_bracket {
	$testast->add_base_node('op', '(', 0, 30);
	$testast->add_base_node('ident', 'x', 0, 31);
	$testast->add_base_node('op', '+', 0, 32);
	$testast->add_base_node('int', '5', 0, 33);
	$testast->add_base_node('op', ')', 0, 34);
	$testast->add_base_node('op', ';', 0, 35);

	is(struct_bracket::get($testast, $output), 1, 'Testing get bracketed expression.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_empty_bracket();
	test_bracket();
	return test_summary();
}

main();
