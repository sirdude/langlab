#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_ident;

my ($testast, $output);

sub test_var {
	$testast->add_base_node('ident', 'x', 0, 18);
	$testast->add_base_node('op', ';', 0, 19);
	$testast->add_base_node('op', '+', 0, 20);

	is(struct_ident::start($testast), 1, 'Testing start of varable reference');
	is(struct_ident::get($testast, $output), 1, 'Testing get simple var');
	is(struct_ident::start($testast), 0, 'Testing invalid start of varable reference');
	is(struct_ident::get($testast, $output), 0, 'Testing get simple var on invalid input');

	$testast->clear();
	return 1;
}

sub test_array {
	$testast->add_base_node('ident', 'x', 0, 32);
	$testast->add_base_node('op', '[', 0, 33);
	$testast->add_base_node('int', '5', 0, 34);
	$testast->add_base_node('op', ']', 0, 35);
	$testast->add_base_node('op', ';', 0, 36);

	is(struct_ident::get($testast, $output), 1, 'Testing get an reference to an array');

	$testast->clear();
	return 1;
}

sub test_hash {
	$testast->add_base_node('ident', 'x', 0, 45);
	$testast->add_base_node('op', '[', 0, 46);
	$testast->add_base_node('string', 'a', 0, 47);
	$testast->add_base_node('op', ']', 0, 48);
	$testast->add_base_node('op', ';', 0, 49);

	is(struct_ident::get($testast, $output), 1, 'Testing get a reference to a hash');

	$testast->clear();
	return 1;
}

sub test_function_no_args {
	$testast->add_base_node('ident', 'x', 0, 58);
	$testast->add_base_node('op', '(', 0, 59);
	$testast->add_base_node('op', ')', 0, 60);
	$testast->add_base_node('op', ';', 0, 61);

	is(struct_ident::get($testast, $output), 1, 'Testing functioncall with no args;');

	$testast->clear();
	return 1;
}

sub test_function_multi_args {
	$testast->add_base_node('ident', 'x', 0, 70);
	$testast->add_base_node('op', '(', 0, 71);
	$testast->add_base_node('ident', 'y', 0, 72);
	$testast->add_base_node('op', ',', 0, 73);
	$testast->add_base_node('ident', 'z', 0, 74);
	$testast->add_base_node('op', ')', 0, 75);
	$testast->add_base_node('op', ';', 0, 76);

	is(struct_ident::get($testast, $output), 1, 'Testing function call with multiple args;');

	$testast->clear();
	return 1;
}


sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_var();
	test_array();
	test_hash();
	test_function_no_args();
	test_function_multi_args();
	return test_summary();
}

main();
