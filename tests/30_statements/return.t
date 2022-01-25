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
use struct_return;

my ($testast, $output);

sub test_return {
	$testast->add_base_node('keyword', 'return', 0, 20);
	$testast->add_base_node('int', '1', 0, 21);
	$testast->add_base_node('op', ';', 0, 22);

	is(struct_return::start($testast), 1, 'Testing start exit');
	is(struct_return::get($testast, $output), 1, 'Testing get exit');
	is(struct_return::start($testast), 0, 'Testing invalid start of exit.');
	is(struct_return::get($testast, $output), 0, 'Testing get exit invalid;');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_return();
	return test_summary();
}

main();
