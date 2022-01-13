#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_term;

my ($testast, $output);

sub test_term {
	$testast->add_base_node('int', '5', 0, 28);
	$testast->add_base_node('op', ';', 0, 29);

	is(struct_term::start($testast), 1, 'Testing start of term with 5;.');
	is(struct_term::get($testast, $output), 1, 'Testing get term with 5;.');
	is(struct_term::start($testast, $output), 0, 'Testing star term with ;.');
	is(struct_term::get($testast, $output), 0, 'Testing get term with ;.');
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_term();
	return test_summary();
}

main();
