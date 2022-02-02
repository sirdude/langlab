#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_program;

my ($testast, $output);

sub test_empty_program {
	is(struct_program::start($testast), 1, 'Testing if we have the start of a program.');
	is(struct_program::get($testast, \$output), 1, 'Testing get program on empty.');

	return 1;
}

sub test_hello_world {
	$testast->add_base_node('keyword', 'void', 0, 25);
	$testast->add_base_node('ident', 'main', 0, 26);
	$testast->add_base_node('op', '(', 0, 27);
	$testast->add_base_node('op', ')', 0, 28);
	$testast->add_base_node('op', '{', 0, 29);
	$testast->add_base_node('keyword', 'print', 0, 30);
	$testast->add_base_node('string', "Hello World!\n", 0, 31);
	$testast->add_base_node('op', ';', 0, 32);
	$testast->add_base_node('op', '}', 0, 33);

	is(struct_program::get($testast, \$output), 1, 'Testing get hello world.');

	$testast->clear();
	return 1;
}

sub test_pkg {
	$testast->add_base_node('keyword', 'use', 0, 42);
	$testast->add_base_node('string', 'options', 0, 43);
	$testast->add_base_node('op', ';', 0, 44);
	$testast->add_base_node('keyword', 'void', 0, 45);
	$testast->add_base_node('ident', 'main', 0, 46);
	$testast->add_base_node('op', '(', 0, 47);
	$testast->add_base_node('op', ')', 0, 48);
	$testast->add_base_node('op', '{', 0, 49);
	$testast->add_base_node('keyword', 'print', 0, 50);
	$testast->add_base_node('string', "Hello World!\n", 0, 51);
	$testast->add_base_node('op', ';', 0, 52);
	$testast->add_base_node('op', '}', 0, 53);

	is(struct_program::start($testast), 1, 'Testing if we have the start of a program with use.');
	is(struct_program::get($testast, \$output), 1, 'Testing get pkg program.');
	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_empty_program();
	test_hello_world();
	test_pkg();
	return test_summary();
}

main();
