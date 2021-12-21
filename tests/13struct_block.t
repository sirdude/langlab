#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_block;

my ($testast, $output);

sub test_empty_block {
	$testast->add_base_node('op', "{", 1, 3);
	$testast->add_base_node('op', "}", 1, 3);
	is(struct_block::start($testast), 1, 'Testing start of block.');
	is(struct_block::get($testast, $output), 1, 'Testing get empty block;');

	return 1;
}

sub test_simple_block {
	$testast->add_base_node('op', "{", 1, 3);
	$testast->add_base_node('type', "int", 1, 3);
	$testast->add_base_node('ident', "x", 1, 3);
	$testast->add_base_node('op', ";", 1, 3);
	$testast->add_base_node('op', "}", 1, 3);

	is(struct_block::get($testast, $output), 1, 'Testing get simple block.');
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_empty_block();
	test_simple_block();
	return test_summary();
}

main();
