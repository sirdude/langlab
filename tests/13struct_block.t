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
	$testast->add_base_node('op', '{', 0, 18);
	$testast->add_base_node('op', '}', 0, 19);
	$testast->add_base_node('op', ';', 0, 19);
	is(struct_block::start($testast), 1, 'Testing start of block.');
	is(struct_block::get($testast, $output), 1, 'Testing get empty block;');

	is(struct_block::start($testast), 0, 'Testing invalid start of block ";".');
	is(struct_block::get($testast, $output), 0, 'Testing get invalid block;');
	$testast->consume(); # get rid of the ';'

	return 1;
}

sub test_simple_block {
	$testast->add_base_node('op', '{', 0, 27);
	$testast->add_base_node('type', 'int', 0, 28);
	$testast->add_base_node('ident', 'x', 0, 29);
	$testast->add_base_node('op', ';', 0, 30);
	$testast->add_base_node('op', '}', 0, 31);
	$testast->add_base_node('op', ';', 0, 31);

	is(struct_block::get($testast, $output), 1, 'Testing get simple block.');
	$testast->consume(); # get rid of the ';'
	return 1;
}

sub test_multistatement_block {
	$testast->add_base_node('op', '{', 0, 27);
	$testast->add_base_node('type', 'int', 0, 28);
	$testast->add_base_node('ident', 'x', 0, 29);
	$testast->add_base_node('op', ';', 0, 30);
	$testast->add_base_node('ident', 'x', 0, 29);
	$testast->add_base_node('op', '=', 0, 30);
	$testast->add_base_node('float', '5.0', 0, 30);
	$testast->add_base_node('op', ';', 0, 30);
	$testast->add_base_node('op', '}', 0, 31);
	$testast->add_base_node('op', ';', 0, 31);
	is(struct_block::get($testast, $output), 1, 'Testing get on multistatement block.');
	$testast->consume(); # get rid of the ';'
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_empty_block();
	test_simple_block();
	test_multistatement_block();
	return test_summary();
}

main();
