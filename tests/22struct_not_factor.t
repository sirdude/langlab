#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_not_factor;

my ($testast, $output);

sub test_not_factor {
	$testast->add_base_node('op', '!', 0, 18);
	$testast->add_base_node('int', '5', 0, 18);
	$testast->add_base_node('op', ';', 0, 18);

	is(struct_not_factor::start($testast), 1, 'Testing start of not_factor.');
	is(struct_not_factor::get($testast, $output), 1, 'Testing expression: 1;');
	is(struct_not_factor::start($testast), 0, 'Testing start of not_factor invalid.');

	$testast->clear();
	return 1;
}

sub test_factor {
	$testast->add_base_node('int', '5', 0, 28);
	$testast->add_base_node('op', ';', 0, 29);

	is(struct_not_factor::start($testast), 1, 'Testing start of not_factor with 5;.');
	is(struct_not_factor::get($testast, $output), 1, 'Testing get not_factor with 5;.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_not_factor();
	test_factor();
	return test_summary();
}

main();
