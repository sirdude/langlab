#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_pkg;

my ($testast, $output);

sub test_string {
	$testast->add_base_node('string', 'use', 0, 18);
	$testast->add_base_node('op', ';', 0, 20);
	$testast->add_base_node('op', '+', 0, 20);

	is(struct_string_expression::start($testast), 1, 'Testing simple string.');
	is(struct_string_expression::get($testast, $output), 1, 'Testing use options;');
	is(struct_string_expression::start($testast), 0, 'Testing invalid.');
	is(struct_string_expression::get($testast, $output), 0, 'Testing use options;');
	$testast->consume(); # get rid of the ';'

	return 1;
}

sub test_concat {
	$testast->add_base_node('string', 'one', 0, 18);
	$testast->add_base_node('op', '+', 0, 20);
	$testast->add_base_node('string', 'two', 0, 18);
	$testast->add_base_node('op', ';', 0, 20);

	is(struct_string_expression::get($testast, $output), 1, 'Testing "one" + "two"');
	$testast->consume(); # get rid of the ';'
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_string();
	test_concat();
	return test_summary();
}

main();
