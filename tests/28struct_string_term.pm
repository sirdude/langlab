#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_string_term;

my ($testast, $output);

sub test_string {
	$testast->add_base_node('string', 'hi', 0, 19);
	$testast->add_base_node('op', ';', 0, 20);

	is(struct_string_term::start($testast), 1, 'Testing start of simple string "hi".');
	is(struct_string_term::get($testast, $output), 1, 'Testing get simple string "hi";');

	$testast->clear();
	return 1;
}

sub test_function_call {
	$testast->add_base_node('keyword', 'doit', 0, 28);
	$testast->add_base_node('op', '(', 0, 31);
	$testast->add_base_node('op', ')', 0, 31);
	$testast->add_base_node('op', ';', 0, 31);

	is(struct_string_term::get($testast, $output), 1, 'Testing get a function call.');

	$testast->clear();
	return 1;
}

sub test_variable {
	$testast->add_base_node('keyword', 'doit', 0, 28);
	$testast->add_base_node('op', ';', 0, 31);

	is(struct_string_term::get($testast, $output), 1, 'Testing get a simple variable.');

	$testast->clear();
	return 1;
}

sub test_variable_inarray {
	$testast->add_base_node('keyword', 'x', 0, 28);
	$testast->add_base_node('op', '[', 0, 31);
	$testast->add_base_node('int', '5', 0, 31);
	$testast->add_base_node('op', ']', 0, 31);
	$testast->add_base_node('op', ';', 0, 31);

	is(struct_string_term::get($testast, $output), 1, 'Testing getting an array.');

	$testast->clear();
	return 1;
}

sub test_hash {
	$testast->add_base_node('keyword', 'x', 0, 28);
	$testast->add_base_node('op', '{', 0, 31);
	$testast->add_base_node('string', 'fun', 0, 31);
	$testast->add_base_node('op', '}', 0, 31);
	$testast->add_base_node('op', ';', 0, 31);

	is(struct_string_term::get($testast, $output), 1, 'Testing getting a hash value.');

	$testast->clear();
	return 1;
}

sub test_num {
	$testast->add_base_node('int', '5', 0, 31);
	$testast->add_base_node('op', ';', 0, 31);

	is(struct_string_term::get($testast, $output), 1, 'Testing a simple number.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_string();
	test_function_call();
	test_variable();
	test_variable_inarray();
	test_hash();
	test_num();
	return test_summary();
}

main();
