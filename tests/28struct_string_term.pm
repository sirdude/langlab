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
	$testast->add_base_node('string', 'hi', 0, 18);
	$testast->add_base_node('op', ';', 0, 19);

	is(struct_string_term::start($testast), 1, 'Testing start of simple string "hi".');
	is(struct_string_term::get($testast, $output), 1, 'Testing get simple string "hi";');

	$testast->clear();
	return 1;
}

sub test_function_call {
	$testast->add_base_node('keyword', 'doit', 0, 29);
	$testast->add_base_node('op', '(', 0, 30);
	$testast->add_base_node('op', ')', 0, 31);
	$testast->add_base_node('op', ';', 0, 32);

	is(struct_string_term::get($testast, $output), 1, 'Testing get a function call.');

	$testast->clear();
	return 1;
}

sub test_variable {
	$testast->add_base_node('keyword', 'doit', 0, 41);
	$testast->add_base_node('op', ';', 0, 42);

	is(struct_string_term::get($testast, $output), 1, 'Testing get a simple variable.');

	$testast->clear();
	return 1;
}

sub test_variable_inarray {
	$testast->add_base_node('keyword', 'x', 0, 51);
	$testast->add_base_node('op', '[', 0, 52);
	$testast->add_base_node('int', '5', 0, 53);
	$testast->add_base_node('op', ']', 0, 54);
	$testast->add_base_node('op', ';', 0, 55);

	is(struct_string_term::get($testast, $output), 1, 'Testing getting an array.');

	$testast->clear();
	return 1;
}

sub test_hash {
	$testast->add_base_node('keyword', 'x', 0, 64);
	$testast->add_base_node('op', '{', 0, 65);
	$testast->add_base_node('string', 'fun', 0, 66);
	$testast->add_base_node('op', '}', 0, 67);
	$testast->add_base_node('op', ';', 0, 68);

	is(struct_string_term::get($testast, $output), 1, 'Testing getting a hash value.');

	$testast->clear();
	return 1;
}

sub test_num {
	$testast->add_base_node('int', '5', 0, 77);
	$testast->add_base_node('op', ';', 0, 78);

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
