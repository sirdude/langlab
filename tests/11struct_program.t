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
	is(struct_program::get($testast, $output), 1, 'Testing get program on empty.');

	return 1;
}

sub test_hello_world {
	$testast->add_base_node('comment', '# Hello world', 1, 0);
	$testast->add_base_node('keyword', "void", 2, 0);
	$testast->add_base_node('ident', "main", 2, 0);
	$testast->add_base_node('op', "(", 2, 0);
	$testast->add_base_node('op', ")", 2, 0);
	$testast->add_base_node('op', "{", 2, 0);
	$testast->add_base_node('keyword', "print", 2, 0);
	$testast->add_base_node('string', "Hello World!\n", 2, 0);
	$testast->add_base_node('op', ";", 2, 0);
	$testast->add_base_node('op', "}", 2, 0);

	is(struct_program::start($testast), 1, 'Testing if we have the start of a program.');
	is(struct_program::get($testast, $output), 1, 'Testing get hello world.');
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_empty_program();
	test_hello_world();
	return test_summary();
}

main();
