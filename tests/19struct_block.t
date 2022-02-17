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
	$testast->add_base_node('op', ';', 0, 20);

	is(struct_block::start($testast), 1, 'Testing start of block.');
	is(struct_block::get($testast, \%{$output}), 1, 'Testing get empty block;');
	is(struct_block::start($testast), 0, 'Testing invalid start of block ";".');
	is(struct_block::get($testast, \%{$output}), 0, 'Testing get invalid block;');

	$testast->clear();
	return 1;
}

sub test_simple_block {
	$testast->add_base_node('op', '{', 0, 32);
	$testast->add_base_node('type', 'int', 0, 33);
	$testast->add_base_node('ident', 'x', 0, 34);
	$testast->add_base_node('op', ';', 0, 35);
	$testast->add_base_node('op', '}', 0, 36);
	$testast->add_base_node('op', ';', 0, 37);

	is(struct_block::get($testast, \%{$output}), 1, 'Testing get simple block.');

	$testast->clear();
	return 1;
}

sub test_multistatement_block {
	$testast->add_base_node('op', '{', 0, 46);
	$testast->add_base_node('type', 'int', 0, 47);
	$testast->add_base_node('ident', 'x', 0, 48);
	$testast->add_base_node('op', ';', 0, 49);
	$testast->add_base_node('ident', 'x', 0, 50);
	$testast->add_base_node('op', '=', 0, 51);
	$testast->add_base_node('float', '5.0', 0, 52);
	$testast->add_base_node('op', ';', 0, 53);
	$testast->add_base_node('op', '}', 0, 54);
	$testast->add_base_node('op', ';', 0, 55);

	is(struct_block::get($testast, \%{$output}), 1, 'Testing get on multistatement block.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_empty_block();
	test_simple_block();
	test_multistatement_block();
	return test_summary();
}

main();
