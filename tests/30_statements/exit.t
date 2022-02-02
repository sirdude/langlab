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
use struct_exit;

my ($testast, $output);

sub test_exit_no_arg {
	$testast->add_base_node('keyword', 'exit', 0, 20);
	$testast->add_base_node('op', ';', 0, 21);

	is(struct_exit::start($testast), 1, 'Testing start exit');
	is(struct_exit::get($testast, \$output), 1, 'Testing get exit');
	is(struct_exit::start($testast), 0, 'Testing invalid start of exit.');
	is(struct_exit::get($testast, \$output), 0, 'Testing get exit invalid;');

	$testast->clear();
	return 1;
}

sub test_exit_int {
	$testast->add_base_node('keyword', 'exit', 0, 33);
	$testast->add_base_node('int', '1', 0, 34);
	$testast->add_base_node('op', ';', 0, 35);

	is(struct_exit::get($testast, \$output), 1, 'Testing get exit 5;');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_exit_no_arg();
	test_exit_int();
	return test_summary();
}

main();
