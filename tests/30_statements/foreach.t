#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "./lib/sweet";
use lib "../lib";
use lib "../lib/sweet";
use lib "../../lib";
use lib "../../lib/sweet";

use ast;
use tests;
use struct_foreach;

my ($testast, $output);

sub test_simple_foreach {
	$testast->add_base_node('keyword', 'foreach', 0, 18);
	$testast->add_base_node('ident', 'x', 0, 19);
	$testast->add_base_node('op', '(', 0, 20);
	$testast->add_base_node('int', '1', 0, 21);
	$testast->add_base_node('op', ')', 0, 22);
	$testast->add_base_node('op', '{', 0, 23);
	$testast->add_base_node('op', '}', 0, 24);
	$testast->add_base_node('op', ';', 0, 25);

	is(struct_foreach::start($testast), 1, 'Testing start of foreach statement.');
	is(struct_foreach::get($testast, $output), 1, 'Testing foreach x (1) {};');
	is(struct_foreach::start($testast), 0, 'Testing start of foreach with ;.');

	$testast->clear();
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
