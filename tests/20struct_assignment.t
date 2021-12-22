#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_assignment;

my ($testast, $output);

sub test_simple_assignment {
	$testast->add_base_node('ident', 'x', 1, 0);
	$testast->add_base_node('op', "=", 1, 3);
	$testast->add_base_node('int', "5", 1, 3);
	$testast->add_base_node('op', ";", 1, 3);
	is(struct_assignment::start($testast), 1, 'Testing start of assignment statement.');
	is(struct_assignment::get($testast, $output), 1, 'Testing x=5;');
	is(struct_assignment::start($testast), 0, 'Testing start of assignment with ;');

	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_simple_assignment();
	return test_summary();
}

main();
