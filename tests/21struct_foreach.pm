#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_foreach;

my ($testast, $output);

sub test_simple_foreach {
	$testast->add_base_node('keyword', 'foreach', 1, 0);
	$testast->add_base_node('ident', "x", 1, 3);

	$testast->add_base_node('op', "(", 1, 3);
	$testast->add_base_node('int', "1", 1, 3);
	$testast->add_base_node('op', ")", 1, 3);
	$testast->add_base_node('op', "{", 1, 3);
	$testast->add_base_node('op', "}", 1, 3);
	$testast->add_base_node('op', ";", 1, 3);
	is(struct_foreach::start($testast), 1, 'Testing start of foreach statement.');
	is(struct_foreach::get($testast, $output), 1, 'Testing foreach x (1) {};');
	is(struct_foreach::start($testast), 0, 'Testing start of foreach with ;.');

	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_simple_foreach();
	return test_summary();
}

main();
