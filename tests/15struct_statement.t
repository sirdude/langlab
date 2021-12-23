#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_statement;

my ($testast, $output);

sub test_assignment {
	$testast->add_base_node('ident', 'x', 0, 18);
	$testast->add_base_node('op', '=', 0, 19);
	$testast->add_base_node('int', '5', 0, 20);
	$testast->add_base_node('op', ';', 0, 21);
	is(struct_statement::start($testast), 1, 'Testing start of assignment.');
	is(struct_statement::get($testast, $output), 1, 'Testing x=5;');

	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_assignment();
	return test_summary();
}

main();
