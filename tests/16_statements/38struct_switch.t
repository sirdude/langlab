#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_switch;

my ($testast, $output);

sub test_simple_switch {
	$testast->add_base_node('keyword', 'switch', 0, 18);
	$testast->add_base_node('ident', 'x', 0, 19);
	$testast->add_base_node('op', '{', 0, 20);
	$testast->add_base_node('keyword', 'case', 0, 21);
	$testast->add_base_node('int', '1', 0, 22);
	$testast->add_base_node('op', '{', 0, 23);
	$testast->add_base_node('op', '}', 0, 24);
	$testast->add_base_node('op', '}', 0, 25);
	$testast->add_base_node('op', ';', 0, 26);

	is(struct_switch::start($testast), 1, 'Testing start of switch statement.');
	is(struct_switch::get($testast, $output), 1, 'Testing simple switch;');
	is(struct_switch::start($testast), 0, 'Testing start of switch with ;.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_simple_switch();
	return test_summary();
}

main();
