#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_if;

my ($testast, $output);

sub test_simple_if {
	$testast->add_base_node('keyword', 'if', 0, 18);
	$testast->add_base_node('op', '(', 0, 19);
	$testast->add_base_node('int', '1', 0, 20);
	$testast->add_base_node('op', ')', 0, 21);
	$testast->add_base_node('op', '{', 0, 22);
	$testast->add_base_node('op', '}', 0, 23);
	$testast->add_base_node('op', ';', 0, 24);

	is(struct_if::start($testast), 1, 'Testing start of if statement.');
	is(struct_if::get($testast, $output), 1, 'Testing if (1) {};');
	is(struct_if::start($testast), 0, 'Testing start of if statement with ;.');
	is(struct_if::get($testast, $output), 0, 'Testing get on invalid if');

	$testast->clear();
	return 1;
}

sub test_if_else() {
	$testast->add_base_node('keyword', 'if', 0, 36);
	$testast->add_base_node('op', '(', 0, 37);
	$testast->add_base_node('ident', 'x', 0, 38);
	$testast->add_base_node('op', ')', 0, 39);
	$testast->add_base_node('op', '{', 0, 40);
	$testast->add_base_node('op', '}', 0, 41);
	$testast->add_base_node('keyword', 'else', 0, 42);
	$testast->add_base_node('op', '{', 0, 43);
	$testast->add_base_node('op', '}', 0, 44);
	$testast->add_base_node('op', ';', 0, 45);

	is(struct_if::get($testast, $output), 1, 'Testing if else');

	$testast->clear();
	return 1;
}

sub test_if_else_noblock() {
	$testast->add_base_node('keyword', 'if', 0, 54);
	$testast->add_base_node('op', '(', 0, 55);
	$testast->add_base_node('ident', 'x', 0, 56);
	$testast->add_base_node('op', ')', 0, 57);
	$testast->add_base_node('op', '{', 0, 58);
	$testast->add_base_node('op', '}', 0, 59);
	$testast->add_base_node('keyword', 'else', 0, 60);
	$testast->add_base_node('ident', 'x', 0, 61);
	$testast->add_base_node('op', ';', 0, 62);

	is(struct_if::get($testast, $output), 0, 'Testing if else noblock');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_simple_if();
	test_if_else();
	test_if_else_noblock();
	return test_summary();
}

main();
