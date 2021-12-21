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
	is(struct_params::start($testast), 1, 'Testing start of params.');
	is(struct_params::get($testast, $output), 1, 'Testing no params');

	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_no_param();
	return test_summary();
}

main();
