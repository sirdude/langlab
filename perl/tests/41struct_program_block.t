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

sub test_hello_world {
	$testast->add_base_node('type', 'object', 0, 25);
	$testast->add_base_node('ident', 'hello', 0, 25);
	$testast->add_base_node('op', '=', 0, 25);
	$testast->add_base_node('op', '{', 0, 25);
	$testast->add_base_node('keyword', 'void', 0, 25);
	$testast->add_base_node('ident', 'main', 0, 26);
	$testast->add_base_node('op', '(', 0, 27);
	$testast->add_base_node('op', ')', 0, 28);
	$testast->add_base_node('op', '{', 0, 29);
	$testast->add_base_node('keyword', 'print', 0, 30);
	$testast->add_base_node('string', "Hello World!\n", 0, 31);
	$testast->add_base_node('op', ';', 0, 32);
	$testast->add_base_node('op', '}', 0, 33);
	$testast->add_base_node('op', '}', 0, 33);

	is(struct_program::get($testast, \%{$output}), 1, 'Testing get hello world object.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_hello_world();
	return test_summary();
}

main();
