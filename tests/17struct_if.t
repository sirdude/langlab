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
	$testast->add_base_node('type', "int", 1, 0);
	$testast->add_base_node('ident', "x", 1, 2);
	$testast->add_base_node('op', ";", 1, 3);
	is(struct_if::start($testast), 1, 'Testing start of definintion type int.');
	is(struct_if::get($testast, $output), 1, 'Testing int x;');

	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_simple_if();
	return test_summary();
}

main();
