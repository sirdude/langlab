#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_if;

my ($testast, $output);

sub test_simple_if {
	$testast->add_base_node('keyword', 'if', 0, 18);
	$testast->add_base_node('op', '(', 0, 19);
	$testast->add_base_node('int', '1', 0, 20);
	$testast->add_base_node('op', ')', 0, 21);
	$testast->add_base_node('op', '{', 0, 22);
	$testast->add_base_node('op', '}', 0, 23);
	$testast->add_base_node('op', ';', 0, 23);

	is(struct_if::start($testast), 1, 'Testing start of if statement.');
	is(struct_if::get($testast, $output), 1, 'Testing if (1) {};');
	is(struct_if::start($testast), 0, 'Testing start of if statement with ;.');
	is(struct_if::get($testast, $output), 0, 'Testing get on invalid if');

	$testast->clear();
	return 1;
}

sub test_var_equals_if() {
	$testast->add_base_node('keyword', 'if', 0, 18);
	$testast->add_base_node('op', '(', 0, 19);
	$testast->add_base_node('ident', 'x', 0, 20);
	$testast->add_base_node('op', '==', 0, 20);
	$testast->add_base_node('int', '5', 0, 20);
	$testast->add_base_node('op', ')', 0, 21);
	$testast->add_base_node('op', '{', 0, 22);
	$testast->add_base_node('op', '}', 0, 23);
	$testast->add_base_node('op', ';', 0, 23);

	is(struct_if::get($testast, $output), 1, 'Testing if (x==5) {};');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_simple_if();
	test_var_equals_if();
	return test_summary();
}

main();
