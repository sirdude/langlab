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

my ($testast, @output);

sub test_no_param {
	$testast->add_base_node('op', '(', 0, 18);
	$testast->add_base_node('op', ')', 0, 19);
	$testast->add_base_node('op', ';', 0, 20);

	is(struct_params::start($testast), 1, 'Testing start of params no params.');
	is(struct_params::get($testast, @output), 1, 'Testing get with no params.');
	is(struct_params::start($testast), 0, 'Testing start of params with ;.');

	$testast->clear(); # Get rid of the ;
	return 1;
}

sub test_one_param {
	$testast->add_base_node('op', '(', 0, 29);
	$testast->add_base_node('type', 'int', 0, 30);
	$testast->add_base_node('ident', 'x', 0, 31);
	$testast->add_base_node('op', ')', 0, 32);
	$testast->add_base_node('ident', ';', 0, 33);

	is(struct_params::get($testast, @output), 1, 'Testing params int x.');

	$testast->clear(); # Get rid of the ;
	return 1;
}

sub test_two_params {
	$testast->add_base_node('op', '(', 0, 41);
	$testast->add_base_node('type', 'string', 0, 42);
	$testast->add_base_node('ident', 'x', 0, 43);
	$testast->add_base_node('op', ',', 0, 44);
	$testast->add_base_node('type', 'int', 0, 45);
	$testast->add_base_node('ident', 'y', 0, 46);
	$testast->add_base_node('op', ')', 0, 47);
	$testast->add_base_node('ident', ';', 0, 48);

	is(struct_params::start($testast), 1, 'Testing start of params string.');
	is(struct_params::get($testast, @output), 1, 'Testing params (string x, int y).');

	$testast->clear(); # Get rid of the ;
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_no_param();
	test_one_param();
	test_two_params();
	return test_summary();
}

main();
