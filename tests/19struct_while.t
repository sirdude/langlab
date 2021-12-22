#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_while;

my ($testast, $output);

sub test_simple_while {
	$testast->add_base_node('keyword', 'while', 1, 0);
	$testast->add_base_node('op', "(", 1, 3);
	$testast->add_base_node('int', "1", 1, 3);
	$testast->add_base_node('op', ")", 1, 3);
	$testast->add_base_node('op', "{", 1, 3);
	$testast->add_base_node('op', "}", 1, 3);
	is(struct_while::start($testast), 1, 'Testing start of while statement.');
	is(struct_while::get($testast, $output), 1, 'Testing while (1) {};');

	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_simple_while();
	return test_summary();
}

main();
