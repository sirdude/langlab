#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_program;

my ($testast, $output);

sub test_var_def {
	$testast->add_base_node('type', "int", 1, 0);
	$testast->add_base_node('ident', "x", 1, 2);
	$testast->add_base_node('op', ";", 1, 3);
	is(struct_program::start($testast), 1, 'Testing start of definintion type int.');
	is(struct_program::get($testast, $output), 1, 'Testing int x;');

	return 1;
}

sub test_function_def {
	$testast->add_base_node('keyword', "void", 2, 0);
	$testast->add_base_node('ident', "main", 2, 0);
	$testast->add_base_node('op', "(", 2, 0);
	$testast->add_base_node('op', ")", 2, 0);
	$testast->add_base_node('op', "{", 2, 0);
	$testast->add_base_node('op', "}", 2, 0);

	is(struct_program::start($testast), 1, 'Testing if we have the start of a function def.');
	is(struct_program::get($testast, $output), 1, 'Testing void main() {}.');
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_var_def();
	test_function_def();
	return test_summary();
}

main();
