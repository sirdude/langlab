#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_pkg;

my ($testast, $output);

sub test_use_pkg {
	$testast->add_base_node('keyword', 'use', 0, 18);
	$testast->add_base_node('ident', 'options', 0, 19);
	$testast->add_base_node('op', ';', 0, 20);

	is(struct_pkg::start($testast), 1, 'Testing start of use.');
	is(struct_pkg::get($testast, $output), 1, 'Testing use options;');

	$testast->clear();
	return 1;
}

sub test_use_lib {
	$testast->add_base_node('keyword', 'use', 0, 30);
	$testast->add_base_node('keyword', 'lib', 0, 31);
	$testast->add_base_node('string', './', 0, 32);
	$testast->add_base_node('op', ';', 0, 33);

	is(struct_pkg::get($testast, $output), 1, 'Testing use lib "./";.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_use_pkg();
	test_use_lib();
	return test_summary();
}

main();
