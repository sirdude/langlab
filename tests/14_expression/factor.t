#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_factor;

my ($testast, $output);

sub test_factor {
	$testast->add_base_node('int', '5', 0, 18);
	$testast->add_base_node('op', ';', 0, 19);

	is(struct_factor::start($testast), 1, 'Testing start of factor with 5;.');
	is(struct_factor::get($testast, $output), 1, 'Testing get factor with 5;.');
	is(struct_factor::start($testast), 0, 'Testing start of factor with ;.');
	is(struct_factor::get($testast, $output), 0, 'Testing get factor with ;.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_factor();
	return test_summary();
}

main();
