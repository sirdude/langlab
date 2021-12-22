#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_params;

my ($testast, $output);

sub test_no_param {
	$testast->add_base_node('op', "(", 1, 3);
	$testast->add_base_node('op', ")", 1, 3);
	$testast->add_base_node('op', ";", 1, 3);
	is(struct_params::start($testast), 1, 'Testing start of params no params.');
	is(struct_params::get($testast, $output), 1, 'Testing no params ().');
	is(struct_params::start($testast), 0, 'Testing start of params with ;.');

	return 1;
}

sub test_one_param {
	$testast->add_base_node('op', "(", 1, 3);
	$testast->add_base_node('type', "int", 1, 3);
	$testast->add_base_node('ident', "x", 1, 3);
	$testast->add_base_node('op', ")", 1, 3);
	$testast->add_base_node('ident', ";", 1, 3);
	is(struct_params::get($testast, $output), 1, 'Testing params int x.');
	$testast->consume(); # Get rid of the ;

	return 1;
}

sub test_two_params {
	$testast->add_base_node('op', "(", 1, 3);
	$testast->add_base_node('type', "string", 1, 3);
	$testast->add_base_node('ident', "x", 1, 3);
	$testast->add_base_node('op', ",", 1, 3);
	$testast->add_base_node('type', "int", 1, 3);
	$testast->add_base_node('ident', "y", 1, 3);
	$testast->add_base_node('op', ")", 1, 3);
	$testast->add_base_node('ident', ";", 1, 3);
	is(struct_params::start($testast), 1, 'Testing start of params string.');
	is(struct_params::get($testast, $output), 1, 'Testing params (string x, int y).');
	$testast->consume(); # Get rid of the ;

	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_no_param();
	test_one_param();
	test_two_params();
	return test_summary();
}

main();
