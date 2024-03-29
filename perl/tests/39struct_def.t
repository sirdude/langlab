#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_def;

my ($testast, $output);

sub test_var_def {
	$testast->add_base_node('type', 'int', 0, 18);
	$testast->add_base_node('ident', 'x', 0, 19);
	$testast->add_base_node('op', ';', 0, 20);

	is(struct_def::start($testast), 1, 'Testing start of definition type int.');
	is(struct_def::get($testast, \%{$output}), 1, 'Testing int x;');
	is(struct_def::start($testast), 0, 'Testing invalid start of definition ;.');
	is(struct_def::get($testast, \%{$output}), 0, 'Testing get with invalid start of definition ;');

	$testast->clear();
	return 1;
}

sub test_function_def {
	$testast->add_base_node('keyword', 'void', 0, 32);
	$testast->add_base_node('ident', 'main', 0, 33);
	$testast->add_base_node('op', '(', 0, 34);
	$testast->add_base_node('op', ')', 0, 35);
	$testast->add_base_node('op', '{', 0, 36);
	$testast->add_base_node('op', '}', 0, 37);

	is(struct_def::start($testast), 1, 'Testing if we have the start of a function def.');
	is(struct_def::get($testast, \%{$output}), 1, 'Testing void main() {}.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_var_def();
	test_function_def();
	return test_summary();
}

main();
